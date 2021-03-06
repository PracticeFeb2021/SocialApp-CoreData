//
//  Comment.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import Foundation


// {
//    "postId": 1,
//    "id": 1,
//    "name": "id labore ex et quam laborum",
//    "email": "Eliseo@gardner.biz",
//    "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
//},
struct CommentModel: Decodable {
    
    @IntRepresentedString
    var id: String
    
    @IntRepresentedString
    var postId: String
    
    let name: String
    
    let body: String
    
    let email: String
}
