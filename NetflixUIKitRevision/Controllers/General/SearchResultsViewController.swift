//
//  SearchResultsViewController.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 22/02/25.
//

import UIKit

//as SearchResultsViewController doesnt have access to navigation controller to push the selected movie's detail view controller so using delegate protocol to share the selected movie from SearchResultsViewController to
protocol SearchResultsViewControllerDelegate : AnyObject{
    func searchResultsViewControllerDidTapItem(viewModel : TitleDetailsViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var movies = [MovieOrTv]()

    public weak var delegate : SearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleTableViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}
extension SearchResultsViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .blue
        
        let title = movies[indexPath.row]
        cell.configure(model: title.posterPath ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = movies[indexPath.row]
        
        Task{
            do{
                guard let titleName = title.title else { return }
                
                let ytVideoId = try await APICaller.shared.getYoutubeData(searchText: titleName + " trailer")
                
                delegate?.searchResultsViewControllerDidTapItem(viewModel: TitleDetailsViewModel(title: titleName, youtubeVideoId: ytVideoId, description: title.overview ?? ""))
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}
/*
 •    internal (default) → Accessible within the same module (e.g., your app target).
 •    public → Accessible from other modules but can’t be subclassed/overridden.
 •    open → Like public, but allows subclassing/overriding in other modules.
 •    private → Accessible only within the same file.
 •    fileprivate → Accessible only within the same Swift file.

 🔹 Example: public (No Subclassing Outside the Module)
 // In MyFramework (a separate module)
 public class Animal {
     public func makeSound() {
         print("Some generic sound")
     }
 }

 // In Another App (importing MyFramework)
 import MyFramework

 class Dog: Animal {} // ❌ ERROR: Cannot subclass a `public` class outside its module
 
 🔹 Example: open (Allows Subclassing Outside the Module)
 // In MyFramework (a separate module)
 open class Animal {
     open func makeSound() {
         print("Some generic sound")
     }
 }

 // In Another App (importing MyFramework)
 import MyFramework

 class Dog: Animal {
     override func makeSound() {
         print("Bark!")
     }
 }

 let pet = Dog()
 pet.makeSound() // ✅ Output: "Bark!"
 
 🔹 Example: private (Only Inside the Class/Struct)
 class Person {
     private var name = "John"

     private func sayHello() {
         print("Hello, my name is \(name)")
     }
 }

 let person = Person()
 print(person.name) // ❌ ERROR: 'name' is private
 person.sayHello()  // ❌ ERROR: 'sayHello()' is private
 
 🔹 Example: fileprivate (Accessible in the Same File)
 class Person {
     fileprivate var name = "John"

     fileprivate func sayHello() {
         print("Hello, my name is \(name)")
     }
 }

 // Same file, different class
 class Friend {
     func introduce() {
         let person = Person()
         print(person.name) // ✅ Works! (Same file)
         person.sayHello()  // ✅ Works! (Same file)
     }
 }
 */
