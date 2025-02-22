//
//  ViewController.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 15/02/25.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
//        APICaller.shared.fetchUpcomingMovies { [weak self] result in
//            switch result {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrowshape.down.circle")
        
        vc1.title = "Home"
        vc2.title = "Upcoming"
        vc3.title = "Search"
        vc4.title = "Downloads"
        /*
         When you set vc1.title = "Home", it automatically applies the title to both:
         ✅ The Navigation Bar title (if inside a UINavigationController)
         ✅ The Tab Bar item title
         
         You should explicitly use vc1.tabBarItem.title only if you want a different name in the Tab Bar than in the Navigation Bar.
         */
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
    }


}
#Preview{
    MainTabBarViewController()
}
