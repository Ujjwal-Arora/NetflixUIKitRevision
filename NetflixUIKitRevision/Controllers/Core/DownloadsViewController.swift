//
//  DownloadsViewController.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 15/02/25.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var movies = [TitleItem]()
    
    private let downloadedTable : UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Downlods"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadedTable)
        downloadedTable.dataSource = self
        downloadedTable.delegate = self
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame  = view.bounds
    }
    private func fetchLocalStorageForDownload(){
        DataPersistanceManager.shared.fetchTitlesFromDatabase {[weak self] result in
            switch result {
            case .success(let titles):
                self?.movies = titles
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension DownloadsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = movies[indexPath.row]
        cell.configure(model: TitleViewModel(titleName: (title.title ?? title.name) ?? "", posterUrl: title.posterPath ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistanceManager.shared.deleteTitle(model: movies[indexPath.row]) {[weak self] result in
                switch result {
                case .success():
                    print("Deleted from database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self?.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default :
            break
        }
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

