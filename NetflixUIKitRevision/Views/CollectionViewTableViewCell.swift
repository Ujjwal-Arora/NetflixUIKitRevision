//
//  CollectionViewTableViewCell.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 15/02/25.
//

import UIKit
/*Why Can’t TitleCollectionViewCell or CollectionViewTableViewCell Directly Push a New View Controller?
doesn’t have access to UINavigationController, so it cannot push a new view controller.
 It doesn’t own the navigation stack—it belongs to HomeViewController, which is responsible for screen transitions.

✅ Best Practice → UI components should be dumb (focused only on UI).
✅ Navigation logic should be handled at the View Controller level (i.e., HomeViewController).
 
 What Happens If We Force CollectionViewTableViewCell to Push the View?
     1.    CollectionViewTableViewCell doesn’t have direct access to UINavigationController.
     •    We would need to pass it from HomeViewController, which makes things tightly coupled.
     2.    Reusability is compromised.
     •    CollectionViewTableViewCell might be used in multiple screens. If it directly handles navigation, it won’t be reusable across different view controllers.
     3.    Violates MVC/MVVM principles.
     •    UI components should not control navigation; that responsibility belongs to the View Controller.
 Eg:
 In CollectionViewTableViewCell =>
 class CollectionViewTableViewCell: UITableViewCell, UICollectionViewDelegate {
 weak var navigationController: UINavigationController?  // ❌ Bad practice

 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     let selectedMovie = movies[indexPath.row]
     let vc = MovieDetailViewController(movie: selectedMovie)
     navigationController?.pushViewController(vc, animated: true)  // ❌ Bad practice
 }
 In HomeViewController =>
 class HomeViewController: UIViewController {
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableViewCell", for: indexPath) as? CollectionViewTableViewCell else {
             return UITableViewCell()
         }
         
         cell.navigationController = self.navigationController  // ❌ Bad practice
         return cell
     }
 }
 or similarly passing the whole homeViewController : HomeViewController? inside CollectionViewTableViewCell is also bad
 so we use delegate protocol pattern to avoid this
}
 
 */
//A protocol defines a set of methods and properties that a conforming class, struct, or enum must implement.
protocol CollectionViewTableViewCellProtocol : AnyObject{
    func CollectionViewTableViewCellDidTap(cell : CollectionViewTableViewCell, viewModel : TitleDetailsViewModel)
}

//content view comes above the class inherited eg here its above UITableViewCell
//CollectionViewTableViewCell means collectionview inside table veiw cell
//inherits from UITableViewCell, meaning it is used as a row in a UITableView.
class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    //A delegate is an object that conforms to the protocol and implements its methods to respond to events or pass data.
    //used to communicate between 2 ViewControllers
    weak var delegate : CollectionViewTableViewCellProtocol?
    
    private var moviesOrTvs = [MovieOrTv]()
    
    //custom collection view inside tableViewCell
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        
        //custom cell inside collectionView
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { //programatic initializer for UITableViewCell
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /*
         UITableViewCell.CellStyle Options
         public enum CellStyle : Int {
         case `default`
         case subtitle
         case value1
         case value2
         }
         .default    A single text label (no subtitle).
         .subtitle    A primary text label with a smaller subtitle below it.
         .value1    A primary text label on the left and a smaller secondary label on the right (good for settings-style cells).
         .value2    A bold text label on the left and a normal text label on the right (good for key-value pairs).
         */
        
        
        
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) { //storyboard initializer for UITableViewCell
        fatalError("init(coder:) has not been implemented") //if storyboard is initialised here then this will give fatal error
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    //cell configure function
    public func configure(moviesOrTvs : [MovieOrTv]){
        self.moviesOrTvs = moviesOrTvs
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData() //as data is coming asyncronously so we have to tell collection view to update
        }
    }
    
    private func downloadTitleAt(indexPath : IndexPath){
        DataPersistanceManager.shared.downloadTitle(model: moviesOrTvs[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension CollectionViewTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesOrTvs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(model: moviesOrTvs[indexPath.row].posterPath ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = moviesOrTvs[indexPath.row]
        guard let titleName = title.title ?? title.name else { return }
        
        Task{
            do{
                print("👻",titleName + " trailer")
                let ytVideoId = try await APICaller.shared.getYoutubeData(searchText: titleName + " trailer")
                print("🌿",ytVideoId)
                let titleDetailsVM  = TitleDetailsViewModel(title: titleName, youtubeVideoId: ytVideoId, description: title.overview ?? "no description available")
                delegate?.CollectionViewTableViewCellDidTap(cell: self, viewModel: titleDetailsVM)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
            let downloadAction = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
#Preview{
    CollectionViewTableViewCell()
}
