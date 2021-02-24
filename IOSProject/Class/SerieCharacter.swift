//
//  Result.swift
//  CallAPI
//
//  Created by Emilien Champion on 27/01/2021.
//

import Foundation


struct SerieCharacter: Hashable{
    let identifier: Int
    let name: String
    let imageURL: URL
    let createdDate: Date
    
}

extension SerieCharacter: Decodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name = "name"
        case imageURL = "image"
        case createdDate = "created"
    }
}
