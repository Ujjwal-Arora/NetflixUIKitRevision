//
//  DataPersistanceManager.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 27/02/25.
//

import Foundation
import CoreData
import UIKit

enum DatabaseError : Error{
    case failedToStoreData
    case failedToFetchData
    case failedToDeleteData
}
class DataPersistanceManager{
    static let shared = DataPersistanceManager()
    
    func downloadTitle(model : MovieOrTv, completion : @escaping (Result<Void,Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id ?? 0)
        item.title = model.title ?? ""
        item.originalTitle = model.originalTitle ?? ""
        item.name = model.name ?? ""
        item.originalName = model.originalName ?? ""
        item.overview = model.overview ?? ""
        item.posterPath = model.posterPath ?? ""
        item.backdropPath = model.backdropPath ?? ""
        item.mediaType = model.mediaType ?? ""
        item.adult = model.adult ?? false
        item.originalLanguage = model.originalLanguage ?? ""
        item.popularity = model.popularity ?? 0
        item.releaseDate = model.releaseDate
        item.video = model.video ?? false
        item.voteAverage = model.voteAverage ?? 0
        item.voteCount = Int64(model.voteCount ?? 0)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToStoreData))
        }
    }
    
    func fetchTitlesFromDatabase(completion : @escaping (Result<[TitleItem], Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    func deleteTitle(model : TitleItem, completion : @escaping (Result <Void,Error> ) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
