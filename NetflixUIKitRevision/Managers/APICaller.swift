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
//enum APIError : Error{
//    case failedToGetData
//}
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
    func fetchSearchResults(query : String, completion : @escaping(Result<MoviesOrTvsResponseModel, Error>) -> Void){
        /*.urlHostAllowed is a predefined CharacterSet that allows only safe characters in a URL host (like example.com).
        •    Allowed Characters: Letters, numbers, . (dot), - (hyphen).
        •    Not Allowed (Gets Encoded): Spaces (  → %20), #, ?, &, =.
        When making network requests, special characters (like spaces, ?, &, #) can break a URL if not properly encoded.
            •    Example: If the user searches for "iPhone 15", the space must be replaced with %20 in a URL.
         */
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        AF.request("https://api.themoviedb.org/3/search/movie?query=\(query)", method: .get, headers: headers)
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
    
    func getYoutubeData(searchText: String) async throws -> String {
        guard let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "https://www.googleapis.com/youtube/v3/search?q=\(query)&key=AIzaSyCF7xSo9A82RUSIQk-k-tKXbW7Dp6PHfyE") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200:
            let searchData = try JSONDecoder().decode(YoutubeSearchModel.self, from: data)
            return searchData.items.first?.id.videoId ?? "no video id"
        case 403:
            throw APIError.unauthorized
        case 404:
            throw APIError.notFound
        case 500:
            let serverMessage = String(data: data, encoding: .utf8) ?? "Internal Server Error"
            throw APIError.serverError(serverMessage)
        default:
            throw APIError.unknown
        }
    }
}
enum APIError: LocalizedError {
    case unauthorized
    case notFound
    case serverError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Unauthorized access. Please check your credentials."
        case .notFound:
            return "Resource not found."
        case .serverError(let message):
            return "Server error: \(message)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}


