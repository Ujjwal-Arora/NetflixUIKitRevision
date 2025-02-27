//
//  YoutubeSearchModel.swift
//  NetflixUIKit
//
//  Created by Ujjwal Arora on 17/10/24.
//

import Foundation

struct YoutubeSearchModel : Codable{
    let items: [Item]
}

struct Item  : Codable{
    let id: ID
}

struct ID : Codable {
    let kind, videoId: String
}
