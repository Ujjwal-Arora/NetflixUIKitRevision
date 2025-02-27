//
//  UpcomingViewController.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 15/02/25.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var movies = [MovieOrTv]()
    
    private var upcomingTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    /*
     •    fetchTrendingMovies makes a network request, which runs asynchronously.
     •    The closure escapes (is stored for later execution).
     •    When the request finishes, the closure still needs access to self to update movies.
     
     If self were strongly captured, it would create a retain cycle:
         1.    HomeViewController owns APICaller.shared.fetchTrendingMovies.
         2.    The escaping closure captures self, creating a strong reference.
         3.    self can’t be deallocated because it’s held by the closure.

     🛑 Solution: Use [weak self] to avoid retain cycles!
     */
    private func fetchUpcoming(){
        APICaller.shared.fetchUpcomingMovies { [weak self] result in
            switch result{
            case .success(let data):
                self?.movies = data.results
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension UpcomingViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        let title = movies[indexPath.row]
        cell.configure(model: TitleViewModel(titleName: (title.title ?? title.name) ?? "no title", posterUrl: title.posterPath ?? "no poster url"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    /*
     •    didSelectRowAt works because UpcomingViewController is set as the delegate of upcomingTable.
     •    The tableView parameter tells which table triggered the selection and alos tells its indexPath
     •    If multiple tables exist, you can differentiate them using if tableView == upcomingTable.
     */
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
#Preview{
    UpcomingViewController()
}
