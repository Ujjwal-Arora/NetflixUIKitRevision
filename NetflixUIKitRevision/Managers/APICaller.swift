//
//  APICaller.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 16/02/25.
//

import Foundation
import Alamofire

struct Constants{
    static let apiKey = "581d5a061651c336cbc121da6b3bc4ab"
}
enum APIError : Error{
    case failedToGetData
}
class APICaller {
    static let shared = APICaller()
    
    let headers : HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODFkNWEwNjE2NTFjMzM2Y2JjMTIxZGE2YjNiYzRhYiIsIm5iZiI6MTcyODk5NzcwNS4xNjQsInN1YiI6IjY3MGU2OTQ5YjE1ZDk3YjFhOTNkOGViOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CRo2PCdQeDJgzQlGMfN9O1v4KZu0w8zZ8lRX_Yjhnxs"
    ]
    
    func fetchTrendingMovies(completion : @escaping(Result<MoviesOrTvsResponseModel,Error>) -> Void){
        AF.request("https://api.themoviedb.org/3/trending/movie/day", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MoviesOrTvsResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchTrendingTV(completion : @escaping(Result<MoviesOrTvsResponseModel,Error>) -> Void){
        AF.request("https://api.themoviedb.org/3/trending/tv/day", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MoviesOrTvsResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func fetchUpcomingMovies(completion : @escaping(Result<MoviesOrTvsResponseModel,Error>) -> Void){
        AF.request("https://api.themoviedb.org/3/movie/upcoming", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MoviesOrTvsResponseModel.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func fetchPopularMovies(completion : @escaping(Result<MoviesOrTvsResponseModel,Error>) -> Void){
        AF.request("https://api.themoviedb.org/3/movie/popular", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MoviesOrTvsResponseModel.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func fetchTopRatedMovies(completion : @escaping(Result<MoviesOrTvsResponseModel,Error>) -> Void){
        AF.request("https://api.themoviedb.org/3/movie/top_rated", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MoviesOrTvsResponseModel.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func fetchDiscoverMovies(completion : @escaping(Result<MoviesOrTvsResponseModel,Error>) -> Void){
        AF.request("https://api.themoviedb.org/3/discover/movie", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MoviesOrTvsResponseModel.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
