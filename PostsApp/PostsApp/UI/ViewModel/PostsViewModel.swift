//
//  PostViewModel.swift
//  PostsApp
//
//  Created by Prince$$ Di on 12.08.2022.
//

import Foundation
import Combine

class PostsViewModel: ObservableObject {
    
    private let networkService: NetworkService = NetworkService()
    @Published var posts = [Post]()
    
    init() {
        fetchPosts(endpoint: .main)
    }
    
    func get(by index: Int) -> Post {
        posts[index]
    }
    
    func fetchPosts(endpoint: NetworkService.Endpoints) {
        
        guard let url = URL(string: endpoint.path) else {
            return
        }
        
        networkService.fetch(url: url) { (result: Result<Posts, Error>) in
            switch result {
            case .success(let result):
                self.posts = result.posts
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

