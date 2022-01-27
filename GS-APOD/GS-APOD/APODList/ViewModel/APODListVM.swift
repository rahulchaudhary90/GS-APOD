//
//  APODListVM.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 26/01/22.
//

import Foundation
import CoreData
import UIKit

class APODListVM {
    
    /// NSFetchedResultsController will provide the updated records via delegate calls
    lazy var fetchedResultsController: NSFetchedResultsController<APOD> = {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: APOD.fetchRequest(), managedObjectContext: CoreDataHandler.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    /// Fetch 'APOD' from backend using REST API call
    /// - Parameter dateString: date of APOD
    func fetchAPODFor(dateString: String?, completion: @escaping (String?) -> Void) {
        guard let dateStr = dateString, let _ = SharedUtility.shared.getDateFrom(str: dateStr) else {
            completion("Invalid date")
            return
        }
        NetworkHandler.shared.getAPOD(dateString: dateStr) { [weak self] data, res, err in
            var dict: [String: Any]?
            do {
                if err != nil {
                    completion(err?.localizedDescription)
                } else if let data = data {
                    dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    self?.insertAPODInCoreDataIfNeeded(dict: dict)
                    completion(dict?["msg"] as? String)
                }
            } catch let error {
                completion(error.localizedDescription)
            }
        }
    }
    
    /// Insert the new record in coreData If it is not there
    /// - Parameter dict: APOD details in dict format
    private func insertAPODInCoreDataIfNeeded(dict: [String: Any]?){
        guard let date = dict?["date"] as? String, let _ = dict?["url"] as? String else {
            return
        }
        if CoreDataHandler.shared.fetchAPOD(fetchRequest: APOD.fetchRequestForDate(date: date)).count == 0 {//No record found, So insert it.
            CoreDataHandler.shared.insertAPOD(dict: dict)
        }
    }
    
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
