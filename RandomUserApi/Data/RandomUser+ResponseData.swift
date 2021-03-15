//
//  RandomUser+ResponseData.swift
//  RandomUserApi
//
//  Created by Jeff Jeong on 2021/03/10.
//

import Foundation


struct RandomUser: Codable, Identifiable, CustomStringConvertible {
    var id = UUID()
    var name : Name
    var photo : Photo
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case photo = "picture"
    }
    static func getDummy() -> Self {
        print(#fileID, #function, #line, "")
        return RandomUser(name: Name.getDummy(), photo: Photo.getDummy())
    }
    
    var profileImgUrl : URL {
        get {
            URL(string: photo.medium)!
        }
    }
    
    var description: String {
        return name.description
    }
}

// 비교를 위한 Equatable 프로토콜
extension RandomUser : Equatable {
    
    static func == (lhs: RandomUser, rhs: RandomUser) -> Bool {
        return lhs.id == rhs.id
    }
    
}


struct Name: Codable, CustomStringConvertible {
    var title : String
    var first : String
    var last : String
    
    var description: String {
        return "[\(title)] \(last), \(first)"
    }
    
    static func getDummy() -> Self {
        print(#fileID, #function, #line, "")
        return Name(title: "유튜버", first: "정대리", last: "개발하는")
    }
}

struct Photo: Codable {
    var large : String
    var medium : String
    var thumbnail : String
    static func getDummy() -> Self {
        print(#fileID, #function, #line, "")
        return Photo(large: "https://randomuser.me/api/portraits/women/93.jpg",
                     medium: "https://randomuser.me/api/portraits/women/93.jpg",
                     thumbnail: "https://randomuser.me/api/portraits/women/93.jpg")
    }
}

struct Info : Codable, CustomStringConvertible {
    var seed : String
    var resultsCount : Int
    var page : Int
    var version : String
    private enum CodingKeys: String, CodingKey {
        case seed = "seed"
        case resultsCount = "results"
        case page = "page"
        case version = "version"
    }
    var description: String {
        return "seed: \(seed) / version: \(version) / resultsCount: \(resultsCount), page: \(page)"
    }
}

struct RandomUserResponse: Codable, CustomStringConvertible {
    var results: [RandomUser]
    var info: Info
    private enum CodingKeys: String, CodingKey {
        case results, info
    }
    var description: String {
        return "results.count: \(results.count) / info : \(info.seed)"
    }
}
