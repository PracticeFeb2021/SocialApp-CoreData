//
//  NetworkManager.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import Foundation



protocol NetworkingService {
    
    func loadPosts(_ completion: @escaping ([PostModel]?) -> ())
    
    func loadUsers(_ completion: @escaping ([UserModel]?) -> ())
    
    func loadComments(_ completion: @escaping ([CommentModel]?) -> ())
    
    func loadComments(forPostWithID id: String,
                      _ completion: @escaping ([CommentModel]?) -> Void)
    
    func loadUser(withID id: String,
                  _ completion: @escaping (UserModel?) -> Void)
}

class NetworkManager: NetworkingService {
    static let shared: NetworkManager = { .init() }()
    
    func loadPosts(_ completion: @escaping ([PostModel]?) -> ()) {
        load(.posts, completion)
    }
    
    func loadUsers(_ completion: @escaping ([UserModel]?) -> ()) {
        load(.users, completion)
    }
    
    func loadComments(_ completion: @escaping ([CommentModel]?) -> ()) {
        load(.comments, completion)
    }
    
    func loadUser(withID id: String,
                  _ completion: @escaping (UserModel?) -> Void) {
        loadUsers { users in
            if let user = users?.first(where: {
                $0.id == id
            }) {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func loadComments(forPostWithID uid: String,
                      _ completion: @escaping ([CommentModel]?) -> Void) {
        
        loadComments { comments in
            if let commentsForPost = comments?.filter ({
                $0.postId == uid
            }), !commentsForPost.isEmpty {
                completion(commentsForPost)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - private
    
    private func load<T: Decodable>(_ endPoint: EndPoint,
                                    _ completion: @escaping (T?) -> ()) {
        
        let request = endPoint.makeURLRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                completion(decodedData)
                
            } else {
                print("ERROR: failed to decode received data")
                print(data)
            }
        }.resume()
    }
}

