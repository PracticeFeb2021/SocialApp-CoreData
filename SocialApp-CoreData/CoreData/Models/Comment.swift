//
//  Comment.swift
//  SocialApp-CoreData
//
//  Created by Oleksandr Bretsko on 2/18/21.
//
//

import CoreData

@objc(Comment)
final class Comment: NSManagedObject, Identifiable, NSManagedObjectP {
    
    @NSManaged var uid: String?
    @NSManaged var name: String?
    @NSManaged var body: String?
    @NSManaged var email: String?
    @NSManaged var postId: String
    
    @nonobjc class func makeFetchRequest() -> NSFetchRequest<Comment> {
        .init(entityName: "Comment")
    }
}

