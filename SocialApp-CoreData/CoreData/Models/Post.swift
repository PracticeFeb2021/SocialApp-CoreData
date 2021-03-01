//
//  Post.swift
//  SocialApp-CoreData
//
//  Created by Oleksandr Bretsko on 2/18/21.
//
//

import CoreData


@objc(Post)
final class Post: NSManagedObject, Identifiable, NSManagedObjectP {
    
    @NSManaged var uid: String?
    @NSManaged var title: String?
    @NSManaged var body: String?
    @NSManaged var user: User?
    
    @nonobjc class func makeFetchRequest() -> NSFetchRequest<Post> {
        .init(entityName: "Post")
    }
}

