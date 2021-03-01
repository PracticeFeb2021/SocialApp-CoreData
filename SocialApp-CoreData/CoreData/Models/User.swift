//
//  User.swift
//  SocialApp-CoreData
//
//  Created by Oleksandr Bretsko on 2/18/21.
//
//

import CoreData

@objc(User)
final class User: NSManagedObject, Identifiable, NSManagedObjectP {

    @NSManaged var uid: String?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var username: String?
    @NSManaged var email: String?
    @NSManaged var website: String?
    @NSManaged var address: Address?
    @NSManaged var company: Company?
    @NSManaged var posts: NSSet?
    
   
    @objc(addPostsObject:)
    @NSManaged func addToPosts(_ value: Post)
    
    @objc(removePostsObject:)
    @NSManaged func removeFromPosts(_ value: Post)
    
    @objc(addPosts:)
    @NSManaged func addToPosts(_ values: NSSet)
    
    @objc(removePosts:)
    @NSManaged func removeFromPosts(_ values: NSSet)
    
    @nonobjc class func makeFetchRequest() -> NSFetchRequest<User> {
        .init(entityName: "User")
    }
}
