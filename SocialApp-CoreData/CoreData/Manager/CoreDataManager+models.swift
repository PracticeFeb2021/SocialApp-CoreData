//
//  CoreDataManager.swift
//  CoreDataManager
//
//  Created by Oleksandr Bretsko on 1/2/21.
//

import UIKit
import CoreData


extension CoreDataManager {
    
    //MARK: - Post
    
    func fetchAllPosts() -> [Post] {
        let context = getViewContext()
        var posts: [Post]?
        do {
            posts = try context.fetch(Post.makeFetchRequest())
        } catch {
            print(error)
        }
        return posts!
    }
    
    @discardableResult
    func createPost(with postModel: PostModel) -> Post? {
        
        let context = getViewContext()
        guard let post = createRecord(forEntity: "Post", in: context) as? Post else {
            print("ERROR: Failed to create new User")
            return nil
        }
        
        post.uid = postModel.id
        post.title = postModel.title
        post.body = postModel.body
        
        if let user: User = fetchObject(with: postModel.userId){
            post.setValue(user, forKey: "user")
        } else {
            print("Info: Failed to add relation, User doesn't exist")
        }
        do {
            try context.save()
            return post
        } catch  {
            print("Error creating notes")
            return nil
        }
    }
    
    //MARK: - Comment
    
    func fetchAllComments() -> [Comment] {
        let context = getViewContext()
        var comments: [Comment]?
        do {
            comments = try context.fetch(Comment.makeFetchRequest())
        } catch {
            print(error)
        }
        return comments!
    }
    
    @discardableResult
    func createComment(with commentModel: CommentModel) -> Comment? {
        
        let context = getViewContext()
        guard let comment = createRecord(forEntity: "Comment", in: context) as? Comment else {
            print("ERROR: Failed to create new User")
            return nil
        }
        
        comment.uid = commentModel.id
        
        comment.body = commentModel.body
        comment.email = commentModel.email
        comment.name = commentModel.name
        comment.postId = commentModel.postId
        
        do {
            try context.save()
            return comment
        } catch  {
            print("Error creating notes")
            return nil
        }
    }
    
    //MARK: - User
    
    func fetchAllUsers() -> [User] {
        let context = getViewContext()
        var users: [User]?
        do {
            users = try context.fetch(User.makeFetchRequest())
        } catch {
            print(error)
        }
        return users!
    }
    
    @discardableResult
    func createUser(with userModel: UserModel) -> User? {
        
        let context = getViewContext()
        guard let user = createRecord(forEntity: "User", in: context) as? User else {
            print("ERROR: Failed to create new User")
            return nil
        }
        
        user.uid = userModel.id
        user.name = userModel.name
        user.email = userModel.email
        
        //TODO: try get created Address and set it
        if let address = createAddress(with: userModel.address) {
            user.setValue(address, forKey: "address")
        }
        if let company = createCompany(with: userModel.company) {
            user.setValue(company, forKey: "company")
        }
        
        user.phone = userModel.phone
        user.username = userModel.username
        user.website = userModel.website
        
        do {
            try context.save()
            return user
        } catch  {
            print("Error creating User")
            return nil
        }
    }
    
    func fetchUser(with uid: String) -> User? {
        let predicate = NSPredicate(format: "uid == %@", uid)
        let request = User.makeFetchRequest()
        request.predicate = predicate
        
        //let predicate = NSPredicate(format: "%K = %@", #keyPath(User.id), id)
        //let predicate = NSPredicate(format: "%K = %@", (\User.id)._kvcKeyPathString!, id)
        
        let context = getViewContext()
        do {
            if let post = try context.fetch(request).first {
                return post
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    //MARK: - Company
    
    func fetchAllCompanies() -> [Company] {
        let context = getViewContext()
        var companies: [Company]?
        do {
            companies = try context.fetch(Company.makeFetchRequest())
        } catch {
            print(error)
        }
        return companies!
    }
    
    @discardableResult
    func createCompany(with companyModel: CompanyModel) -> Company? {
        
        let context = getViewContext()
        guard let company = createRecord(forEntity: "Company", in: context) as? Company else {
            return nil
        }
        
        company.name = companyModel.name
        company.catchPhrase = companyModel.catchPhrase
        company.bs = companyModel.bs
        do {
            try context.save()
            return company
        } catch  {
            print("Error creating company")
            return nil
        }
    }
    
    //MARK: - Address
    
    func fetchAllAddresses() -> [Address] {
        let context = getViewContext()
        var addresses: [Address]?
        do {
            addresses = try context.fetch(Address.makeFetchRequest())
        } catch {
            print(error)
        }
        return addresses!
    }
    
    @discardableResult
    func createAddress(with addressModel: AddressModel) -> Address? {
        
        let context = getViewContext()
        guard let address = createRecord(forEntity: "Address", in: context) as? Address else {
            return nil
        }
        
        address.street = addressModel.street
        address.suite = addressModel.suite
        address.city = addressModel.city
        address.zipcode = addressModel.zipcode
        
        do {
            try context.save()
            return address
        } catch  {
            print("Error creating address")
            return nil
        }
    }
}
