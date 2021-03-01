//
//  Company.swift
//  SocialApp-CoreData
//
//  Created by Oleksandr Bretsko on 2/18/21.
//
//

import CoreData

@objc(Company)
final class Company: NSManagedObject, Identifiable, NSManagedObjectP {
    
    @NSManaged var name: String?
    @NSManaged var catchPhrase: String?
    @NSManaged var bs: String?
    
    @nonobjc class func makeFetchRequest() -> NSFetchRequest<Company> {
        .init(entityName: "Company")
    }
}

