//
//  SearchViewController.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 15/02/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies = [MovieOrTv]()
    
    private let discoverTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    //UISearchController is a built-in search bar component in iOS that allows users to search within an app. It provides a search bar and an optional search results controller to display filtered results.
    private let searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController()) //It assigns SearchResultsViewController() as the search results controller, meaning that when a user searches, the results will be displayed in that view controller instead of the current one.
        controller.searchBar.placeholder = "Search for a movie or a tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        //    •   sets a global preference for large titles in the navigation stack.
        //    •    This enables large titles globally for all view controllers within the navigation
        //    •    It doesn’t force large titles on every screen—it allows them where applicable.
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        //             controls how a specific view controller’s title behaves within that preference.
        //             This is specific to the current view controller.
        //        •    It forces a large title even if the previous screen didn’t use one.
        //        •    Overrides the global setting for this screen.
        
        view.addSubview(discoverTable)
        discoverTable.dataSource = self
        discoverTable.delegate = self
        
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .red
        /*
         Each UIViewController has a navigationItem, which controls only the settings of the navigation bar for that specific screen. It includes :
         Property  -  Description
         title   - The title of the navigation bar for this view controller.
         titleView -   A custom view (e.g., an image or label) instead of the title text.
         leftBarButtonItem  -  A single button (like a back or menu button) on the left.
         leftBarButtonItems  -  Multiple buttons on the left side.
         rightBarButtonItem  -  A single button (like a save or settings button) on the right.
         rightBarButtonItems -   Multiple buttons on the right side.
         hidesBackButton  -  Hides the default back button.
         largeTitleDisplayMode  -  Controls how large titles behave (always, automatic, or never).
         
         The navigationBar is part of the UINavigationController, which manages the navigation stack for multiple view controllers. It includes :
         barTintColor  -  Changes the background color of the navigation bar.
         tintColor  -  Changes the color of interactive elements (back button, bar buttons, etc.).
         isTranslucent  -  Determines whether the navigation bar is transparent or not.
         prefersLargeTitles  -  Enables large titles across the app (true or false).
         titleTextAttributes  -  Customizes font, size, and color of the title.
         largeTitleTextAttributes  -  Customizes font, size, and color of large titles.
         setBackgroundImage(_:for:)  -  Sets a custom background image for the navigation bar.
         
         Feature    navigationItem (Per View Controller)    navigationController?.navigationBar (Global)
         Controls title?    ✅ Yes    ✅ Yes (for global appearance)
         Controls bar button items?    ✅ Yes    ❌ No
         Controls back button?    ❌ No (back button belongs to the previous screen’s navigationItem)    ✅ Yes (via tintColor)
         Controls background color?    ❌ No    ✅ Yes (barTintColor)
         Controls interactive element colors?    ❌ No    ✅ Yes (tintColor)
         Controls large title mode?    ✅ Yes (largeTitleDisplayMode)    ✅ Yes (prefersLargeTitles)
         
         ✅ Use navigationItem → When setting title, left/right buttons, or hiding back button.
         ✅ Use navigationController?.navigationBar → When setting global styles like colors, large titles, and back button color.
         
         */
        
        fetchDiscoverMovies()
        
        //The searchResultsUpdater property expects an object that conforms to the UISearchResultsUpdating protocol.
        //            This protocol notifies when the search bar’s text changes, so we can update the search results dynamically.
        searchController.searchResultsUpdater = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    private func fetchDiscoverMovies(){
        APICaller.shared.fetchDiscoverMovies { result in
            switch result {
            case .success(let data):
                self.movies = data.results
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let currentTitle = movies[indexPath.row]
        let model = TitleViewModel(titleName: (currentTitle.title ?? currentTitle.name) ?? "no name", posterUrl: currentTitle.posterPath ?? "")
        cell.configure(model: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = movies[indexPath.row]
        
        Task{
            do{
                guard let titleName = title.title else { return }
                
                let ytVideoId = try await APICaller.shared.getYoutubeData(searchText: titleName + " trailer")
                
                DispatchQueue.main.async { [weak self] in
                    let titleDetailsVM  = TitleDetailsViewModel(title: titleName, youtubeVideoId: ytVideoId, description: title.overview ?? "no description available")
                    let vc = TitleDetailsViewController()
                    vc.configure(model: titleDetailsVM)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}
extension SearchViewController : UISearchResultsUpdating, SearchResultsViewControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController
        else { return }
        //UIViewController has no proerties/functions so to access them from SearchResultsViewController we have to downcast by as? SearchResultsViewController
        
        resultsController.delegate = self
        
        APICaller.shared.fetchSearchResults(query: query) { result in
            switch result {
            case .success(let data):
                resultsController.movies = data.results
                DispatchQueue.main.async {
                    resultsController.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func searchResultsViewControllerDidTapItem(viewModel: TitleDetailsViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitleDetailsViewController()
            vc.configure(model: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
#Preview{
    SearchViewController()
}
