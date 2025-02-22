//
//  CollectionViewTableViewCell.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 15/02/25.
//

import UIKit

//content view comes above the class inherited eg here its above UITableViewCell
//CollectionViewTableViewCell means collectionview inside table veiw cell
//inherits from UITableViewCell, meaning it is used as a row in a UITableView.
class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
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
}
#Preview{
    CollectionViewTableViewCell()
}
