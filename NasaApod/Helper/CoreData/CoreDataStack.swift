//
//  CoreDataStack.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
import CoreData

class CoreDataStack {
    
    /// Application document directory
    static var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    /// Managed object model
    static var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle(for: CoreDataStack.self).url(forResource: "NasaApod", withExtension: "momd")! // type your database name here..
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    /// Persistent store coordinator
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent("DatabaseTest.sqlite") // type your database name here...
        var failureReason = "There was an error creating or loading the application's saved data."
        let options = [NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true as Bool), NSInferMappingModelAutomaticallyOption: NSNumber(value: true as Bool)]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    /// Manage object context
    static var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    static func object(for anEntity: String) -> AnyObject {
        return CoreDataStack.managedObject(for: anEntity)
    }
    
    private static func managedObject(for anEntityName: String) -> NSManagedObject {
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: anEntityName, into: (CoreDataStack.managedObjectContext))
        return managedObject
    }
    
    // MARK: - Core Data Saving support
    
    /// Save context
    static func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: Load data from core data
    static func loadData<T:NSFetchRequestResult>(entityName: String, predicate: NSPredicate?, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: CoreDataStack.managedObjectContext) else {
            return [T]()
        }
        
        let request = NSFetchRequest<T>()
        if predicate != nil {
            request.predicate = predicate
        }
        if let sort = sortDescriptor {
            request.sortDescriptors = [sort]
        }
        request.entity = entityDescription
        
        do {
            let results = try CoreDataStack.managedObjectContext.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return [T]()
        }
    }
    
    static func delete(entityName: String, predicate: NSPredicate?) {
        let objects:[NSManagedObject] = loadData(entityName: entityName, predicate: predicate)
        for obj in objects {
            self.managedObjectContext.delete(obj)
        }
        
        do {
            try self.managedObjectContext.save() // <- remember to put this :)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func clearAllData(entityName: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: managedObjectContext)
        } catch _ as NSError {
            print("Unable to delete" + entityName)
        }
    }
}
