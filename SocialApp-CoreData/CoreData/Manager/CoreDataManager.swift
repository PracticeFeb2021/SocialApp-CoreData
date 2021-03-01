//
//  CoreDataManager.swift
//  CoreDataManager
//
//  Created by Oleksandr Bretsko on 1/2/21.
//

import UIKit
import CoreData


class CoreDataManager {
    
    private let datamodelName: String
    private let persistentContainer: NSPersistentContainer
    
    init(datamodelName: String) {
        self.persistentContainer = NSPersistentContainer(name: datamodelName)
        self.datamodelName = datamodelName
        setupNotificationHandling()
    }
    
    // MARK: -

    func loadStore() {
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func deleteStore() {
        do {
        try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: databaseURL, ofType: NSSQLiteStoreType, options: nil)
        }
        catch {
            print("Unable to destroy persistent store: \(error) - \(error.localizedDescription)")
        }
    }
    
    // MARK: -
    
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
        } catch {
            #if DEBUG
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            #else
            context.rollback()
            #endif
        }
    }
    
    // MARK: - Notifications
    
    @objc func saveChanges(_ notification: NSNotification) {
        let ctx = getViewContext()
        ctx.perform {
            do {
                if ctx.hasChanges {
                    try ctx.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Managed Object Context")
                print("\(saveError), \(saveError.localizedDescription)")
            }
        }
    }
    
    private func setupNotificationHandling() {
        let ncenter = NotificationCenter.default
        ncenter.addObserver(self,
                            selector: #selector(saveChanges),
                            name: UIApplication.willTerminateNotification,
                            object: nil)
        
        ncenter.addObserver(self,
                            selector: #selector(saveChanges),
                            name: UIApplication.didEnterBackgroundNotification,
                            object: nil)
    }
    
    private var databaseURL: URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent(datamodelName + ".sqlite")
        assert(FileManager.default.fileExists(atPath: url.path))
        return url
    }
    
    //MARK: - Helpers
    
    func createRecord(forEntity entity: String,
                      in context: NSManagedObjectContext) -> NSManagedObject? {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: context) else {
            return nil
        }
        return NSManagedObject(entity: entityDescription, insertInto: context)
    }
    
    func fetchRecords(forEntity entity: String,
                      in context: NSManagedObjectContext) -> [NSManagedObject]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let records = try context.fetch(fetchRequest)
            return records as? [NSManagedObject]
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
            return nil
        }
    }
    
    func fetchObject<T: NSManagedObjectP>(with uid: String) -> T? {
        let predicate = NSPredicate(format: "uid == %@", uid as CVarArg)
        let request = T.makeFetchRequest()
        request.predicate = predicate
        
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
    
    func getViewContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
