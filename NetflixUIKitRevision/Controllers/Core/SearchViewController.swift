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
        
        fetchDiscoverMovies()
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
}
