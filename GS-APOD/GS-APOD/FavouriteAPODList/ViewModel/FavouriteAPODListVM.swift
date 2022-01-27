//
//  FavouriteAPODListVM.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 26/01/22.
//

import Foundation
import CoreData

class FavouriteAPODListVM {
    
    /// NSFetchedResultsController will provide the updated records via delegate calls
    lazy var fetchedResultsController: NSFetchedResultsController<APOD> = {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: APOD.fetchRequestForFavourite(isFavourite: true), managedObjectContext: CoreDataHandler.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    /// Perform fetch on 'NSFetchedResultsController' and set the delegate
    /// - Parameter onDeledate: delegate of
    func performFetchViaFetchedResultsController(onDeledate: NSFetchedResultsControllerDelegate) {
        fetchedResultsController.delegate = onDeledate
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error)
        }
    }
    
    /// Return url of 'APOD' from selected 'IndexPath'
    /// - Parameter indexPath: selected 'IndexPath'
    /// - Returns: URL instance or nil
    func getURLFor(indexPath: IndexPath) -> URL? {
        guard let urlStr = fetchedResultsController.object(at: indexPath).url, let url = URL(string: urlStr) else {
            return nil
        }
        return url
    }
}
