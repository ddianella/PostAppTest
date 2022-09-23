//
//  NetworkService.swift
//  PostsApp
//
//  Created by Prince$$ Di on 18.08.2022.
//

import Foundation
import Combine

class NetworkService {
    
    enum Endpoints {
        private var baseURL: String {return "https://raw.githubusercontent.com/anton-natife/jsons/master/api" }
        
        case main
        case detailedPost(postID: String)
        
        var path: String {
            var endpoint: String
            switch self {
            case .main:
                endpoint = "/main.json"
            case .detailedPost(let postID):
                endpoint = "/posts/\(postID).json"
            }
            return baseURL + endpoint
        }
    }
    
    private var subscriber = Set<AnyCancellable>()
    
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void )  {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { (resultCompletion) in
                switch resultCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    return
                }
            } receiveValue: { (resultArr) in
                completion(.success(resultArr))
            }
            .store(in: &subscriber)
    }
}
