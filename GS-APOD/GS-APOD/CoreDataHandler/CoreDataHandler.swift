//
//  CoreDataHandler.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 26/01/22.
//

import Foundation
import CoreData

class CoreDataHandler {
    
    static let shared = CoreDataHandler()

    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "GS_APOD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
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
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - APOD
    
    /// Return array of 'APOD' coreData model
    /// - Parameter fetchRequest: fetchRequest
    /// - Returns: Array of 'APOD' e.g [APOD]
    func fetchAPOD(fetchRequest: NSFetchRequest<APOD>) -> [APOD] {
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    /// Insert new record (row) in coreData if 'dict' is valid 'Dictionary' AND have valid data
    /// - Parameter dict: dict contains record for an 'APOD'
    func insertAPOD(dict: [String: Any]?) {
        guard let _ = dict?["date"] as? String, let _ = dict?["url"] as? String else {
            print("invalid dict!")
            return
        }
        let apodModel = APOD(context: persistentContainer.viewContext)
        apodModel.date = dict?["date"] as? String
        apodModel.title = dict?["title"] as? String
        apodModel.explanation = dict?["explanation"] as? String
        apodModel.url = dict?["url"] as? String
        apodModel.media_type = dict?["media_type"] as? String
        apodModel.thumbnail_url = dict?["thumbnail_url"] as? String
        
        saveContext()
    }

}
