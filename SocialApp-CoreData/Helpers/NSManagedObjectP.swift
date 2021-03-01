//
//  NSManagedObjectP.swift
//  NSManagedObjectP
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//


import CoreData


protocol NSManagedObjectP: NSManagedObject {
    
    static func makeFetchRequest() -> NSFetchRequest<Self>
}
