//
//  Post.swift
//  PostsApp
//
//  Created by Prince$$ Di on 11.08.2022.
//

import Foundation

//MARK: - PostsResponse

struct Posts: Codable {
    let posts: [Post]
}

//MARK: - Post

struct Post: Codable {
    let postID: Int
    let timeshamp: Int
    let title: String
    let previewText: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}

struct ConcretePost: Codable {
    let post: ConcretePostDetail
}

struct ConcretePostDetail: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let text: String
    let postImage: String
    let likes_count: Int
}

enum PostsError: Error {
    case invalidResponse
}
