//
//  Untitled.swift
//  FlickerImageSearch
//
//  Created by Swetha on 2/3/25.
//
import Foundation

struct FlickrResponse: Decodable {
    let items: [PhotoItem]
}

struct PhotoItem: Identifiable, Decodable {
    var id: String
    
    let title: String
    let description: String?
    let author: String?
    let published: String
    let media: Media

    struct Media: Decodable {
            let m: URL
    }
        
    enum CodingKeys: String, CodingKey {
        case title, description, author, published, media
        case id = "link"
    }
}
