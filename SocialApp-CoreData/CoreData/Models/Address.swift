//
//  Address.swift
//  SocialApp-CoreData
//
//  Created by Oleksandr Bretsko on 2/18/21.
//
//

import CoreData

@objc(Address)
final class Address: NSManagedObject, Identifiable, NSManagedObjectP {
    
    @NSManaged var city: String?
    @NSManaged var street: String?
    @NSManaged var suite: String?
    @NSManaged var zipcode: String?
    
    @NSManaged var lat: String?
    @NSManaged var lng: String?
    
    @nonobjc class func makeFetchRequest() -> NSFetchRequest<Address> {
        .init(entityName: "Address")
    }
}
