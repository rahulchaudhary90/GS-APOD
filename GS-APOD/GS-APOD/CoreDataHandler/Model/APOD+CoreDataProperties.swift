//
//  APOD+CoreDataProperties.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 26/01/22.
//
//

import Foundation
import CoreData


extension APOD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APOD> {
        let fetchRequest = NSFetchRequest<APOD>(entityName: "APOD")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequestForDate(date: String) -> NSFetchRequest<APOD> {
        let fetchRequest = APOD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        return fetchRequest
    }
    
    @nonobjc public class func fetchRequestForFavourite(isFavourite: Bool) -> NSFetchRequest<APOD> {
        let fetchRequest = APOD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavourite == %@", NSNumber.init(value: isFavourite))
        return fetchRequest
    }

    @NSManaged public var date: String?
    @NSManaged public var title: String?
    @NSManaged public var explanation: String?
    @NSManaged public var url: String?
    @NSManaged public var media_type: String?
    @NSManaged public var thumbnail_url: String?
    @NSManaged public var isFavourite: Bool

}

extension APOD : Identifiable {

}
