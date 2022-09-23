//
//  ConcretePostDetail.swift
//  PostsApp
//
//  Created by Prince$$ Di on 30.08.2022.
//

import Foundation
import Combine

class ConcretePostDetailsViewModel: ObservableObject {
    @Published var concretePostDetail: ConcretePostDetail?
    @Published var isLoading: Bool = false
    private let networkService: NetworkService = NetworkService()
    private let id: Int
    
    init(id: Int) {
        self.id = id
        fetchDetailedPost(endpoint: .detailedPost(postID: "\(id)"))
    }
    
    func fetchDetailedPost(endpoint: NetworkService.Endpoints) {
        
        guard let url = URL(string: endpoint.path) else { return }
        
        networkService.fetch(url: url) { (result: Result<ConcretePost, Error>) in
            switch result {
            case .success(let result):
                self.concretePostDetail = result.post
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
