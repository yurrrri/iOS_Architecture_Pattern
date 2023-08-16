//
//  Music.swift
//  MVVM
//
//  Created by 이유리 on 2023/07/19.
//

import Foundation

//MARK: - 데이터 모델

struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}


struct Music: Codable {
    let songName: String?
    let artistName: String?
    let albumName: String?
    let previewUrl: String?
    let imageUrl: String?
    private let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case songName = "trackName"
        case artistName
        case albumName = "collectionName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
    
    var releaseDateString: String? {
        let myFormatter = DateFormatter()
        guard let date = myFormatter.date(from: releaseDate ?? "") else {
            return ""
        }
        myFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = myFormatter.string(from: date)
        return dateString
    }
}
