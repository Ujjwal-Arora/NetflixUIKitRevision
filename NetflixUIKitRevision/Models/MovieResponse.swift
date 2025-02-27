//
//  MovieResponse.swift
//  NetflixUIKitRevision
//
//  Created by Ujjwal Arora on 16/02/25.
//


import Foundation

// MARK: - MovieResponse
struct MoviesOrTvsResponseModel: Codable {
    let page: Int
    let results: [MovieOrTv]
}

// MARK: - Movie
struct MovieOrTv: Codable {
    let id: Int?
    
    let title: String?
    let originalTitle: String?
    
    let name: String?
    let originalName: String?
    
    
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let mediaType: String?
    let adult: Bool?
    let originalLanguage: String?
//    let genreIDs: [Int]?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult, popularity, video
        case originalTitle = "original_title"
        case name
        case originalName = "original_name"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
//        case genreIDs = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
//
//// MARK: - MediaType Enum
//enum MediaType: String, Codable {
//    case movie = "movie"
//    case tv = "tv"
//}
//
//// MARK: - Genre Enum
//enum Genre: Int, Codable {
//    case action = 28
//    case adventure = 12
//    case animation = 16
//    case comedy = 35
//    case crime = 80
//    case documentary = 99
//    case drama = 18
//    case family = 10751
//    case fantasy = 14
//    case history = 36
//    case horror = 27
//    case music = 10402
//    case mystery = 9648
//    case romance = 10749
//    case scienceFiction = 878
//    case tvMovie = 10770
//    case thriller = 53
//    case war = 10752
//    case western = 37
//}
