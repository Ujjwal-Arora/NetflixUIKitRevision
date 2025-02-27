//
//  HomeViewController.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 15/02/25.
//

import UIKit
enum Sections : Int{
    case trendingMovies = 0
    case trendingTv = 1
    case populArMovies = 2
    case upcomingMovies = 3
    case topRatedMovies = 4
}
class HomeViewController: UIViewController{
    
    let sectionHeaders = ["trending Movies", "populAr movies", "tOP Rated Movies", "Upcoming Movies"]
    
    private var starHeaderUIView : StarHeaderUIView?
    
    private let homeFeedTable : UITableView = {
//        let table = UITableView() used when we didn't wanted headers for sections
        let table = UITableView(frame: .zero, style: .grouped) //frame==size = 0 works as we have changed it in viewDidLayoutSubviews
        //grouped is used to get headers in section
        
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        //        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") //registers the cell of class type uitableviewcell for this tableveiw
        table.backgroundColor = .green
        
        //        till now size of table is 0
        //        print(table.frame.size)
        
        return table
    }()
    override func viewDidLoad() {
        view.backgroundColor = .red //viewcontroller's color
        view.addSubview(homeFeedTable) //viewcontroller ke upar table view hoyga
        
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        /*
         •    dataSource → Provides the data (rows, sections, cells).
         •    delegate → Handles interactions (cell selection, scrolling, etc.).
         
         ✅ viewDidLoad() is called only once, when the view first loads.
         ✅ It’s the best place to do one-time setup for the table view.
         
         •    If you set them in viewDidLayoutSubviews(), they could be reassigned multiple times, leading to unnecessary processing.
         •    If you set them in cellForRowAt, the table view won’t know how to load data initially.
         */
        
//        homeFeedTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        //custom header view for table
        
        starHeaderUIView = StarHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = starHeaderUIView
        
        configureNavigationBar()
        
        configureStarHeaderView()
    }
    //  viewDidLayoutSubviews is a lifecycle method in UIViewController called after the view’s subviews have laid out. This happens after viewDidLoad() and potentially multiple times during the view’s lifecycle
    override func viewDidLayoutSubviews() {
        /*
         ✅ Ensuring the Table View Covers the Whole Screen
         •    viewDidLayoutSubviews() is called after the view has been sized and laid out.
         •    At this point, view.bounds contains the correct size of the view.
         •    If you set frame in viewDidLoad, the view’s final size might not be determined yet, leading to layout issues.
         */
        homeFeedTable.frame = view.bounds
        
        //        print(homeFeedTable.frame.size)
    }
    func configureNavigationBar(){
//        navigationItem.title = "Home"
        
        
//        navigationItem.leftBarButtonItem?.image = UIImage(systemName: "swift") direclty writing this wont work because navigationItem.leftBarButtonItem is nil by default. You’re trying to modify an optional value (leftBarButtonItem) that doesn’t exist yet.
        
        var logoImage = UIImage(named: "logo")
        logoImage = logoImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    func configureStarHeaderView(){
        APICaller.shared.fetchTrendingMovies { [weak self] result in
            switch result{
            case .success(let data):
                let randomMovie = data.results.randomElement()
                
                self?.starHeaderUIView?.configure(model: TitleViewModel(titleName: randomMovie?.title ?? "no title", posterUrl: randomMovie?.posterPath ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //to change the scrolling of navbar
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
extension HomeViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionHeaders[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = sectionHeaders[section]
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.text = header.textLabel?.text?.capitalisedFirstLetter()
        header.textLabel?.textColor = .label
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
    /*
     •    dequeueReusableCell(withIdentifier:for:) reuses an existing cell (if available) or creates a new one (if needed).
     eg  let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
     
     •    Instead of always creating a brand-new cell, it reuses off-screen cells to improve performance and save memory.
     eg let cell = UITableViewCell()
     
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {  return UITableViewCell() }
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        /*
         cell.backgroundColor = .red //this wont show as you have set contentView.background = .brown inside init of CollectionViewTableViewCell and content view comes above the cell so it will be brown
         //        cell.contentView.backgroundColor = .yellow
         */
        
        //        cell.textLabel?.text = "\(indexPath)"
        //        cell.detailTextLabel?.text = "sdsd"
        
        
        cell.delegate = self
        /*
         cell ko tap kiya par cell ko pta nhi h kya karna h tap pe to cell ne homeViewController ko bol diya tu karle jo karna h => cell.delegate i.e cell ko jb delegate ho to self(homeViewController) ko bol diya
         
         
         When we say “Whenever something happens that requires a delegate, call me”, it means:

         👉 There is an event or action inside a class (like a cell) that needs to notify another class (like a view controller) to handle it.

         Since CollectionViewTableViewCell does not know what to do when an item is selected, it delegates that responsibility to another class (like HomeViewController), which is why it needs a delegate.
         
         🔹 What Kind of Events “Require a Delegate”?

         Any action inside a class that needs an external class to handle it usually requires a delegate. Examples:

         1️⃣ When a user taps a collection view cell inside a table view cell
             •    The CollectionViewTableViewCell doesn’t know what to do when a movie is tapped.
             •    It calls delegate?.didSelectItem(movie:), so HomeViewController handles it.

         2️⃣ When a button is tapped inside a custom cell
             •    Suppose there’s a “Favorite” button inside a cell.
             •    The cell doesn’t store favorites, so it delegates that responsibility to the view controller.
             •    The view controller updates the favorites list when delegate?.didTapFavorite(movie:) is called.

         3️⃣ When a switch is toggled inside a cell
             •    The cell notifies the view controller that the switch changed.
             •    The view controller then updates the settings.
         */
        
        switch indexPath.section{
        case Sections.trendingMovies.rawValue:
            print(indexPath.section)
            APICaller.shared.fetchTrendingMovies { result in
                switch result{
                case .success(let data):
                    cell.configure(moviesOrTvs: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.trendingTv.rawValue:
            print(indexPath.section)
           APICaller.shared.fetchTrendingTV { result in
                switch result{
                case .success(let data):
                    cell.configure(moviesOrTvs: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.populArMovies.rawValue:
            print(indexPath.section)
          APICaller.shared.fetchPopularMovies { result in
                switch result{
                case .success(let data):
                    cell.configure(moviesOrTvs: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.upcomingMovies.rawValue:
            print(indexPath.section)
         APICaller.shared.fetchUpcomingMovies { result in
                switch result{
                case .success(let data):
                    cell.configure(moviesOrTvs: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.topRatedMovies.rawValue:
            print(indexPath.section)
         APICaller.shared.fetchTopRatedMovies { result in
                switch result{
                case .success(let data):
                    cell.configure(moviesOrTvs: data.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        default:
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
extension HomeViewController : CollectionViewTableViewCellProtocol{
    func CollectionViewTableViewCellDidTap(cell: CollectionViewTableViewCell, viewModel: TitleDetailsViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitleDetailsViewController()
            vc.configure(model: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

#Preview{
//    HomeViewController()
    MainTabBarViewController()
}

