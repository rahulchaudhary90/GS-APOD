//
//  APODTableViewCellVM.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 26/01/22.
//

import Foundation


class APODTableViewCellVM {
    
    var bindDate: ((String?) -> Void)?
    var bindTitle: ((String?) -> Void)?
    var bindImageUrl: ((URL?) -> Void)?
    var bindExplanation: ((String?) -> Void)?
    var bindIsFavourite: ((Bool) -> Void)?
    
    init() {}
    
    var apodModel: APOD? {
        didSet {
            bindDate?(apodModel?.date)
            bindTitle?(apodModel?.title)
            bindExplanation?(apodModel?.explanation)
            bindIsFavourite?(apodModel?.isFavourite ?? false)
            
            var urlString: String?
            if let type = apodModel?.media_type, type == "image" {
                urlString = apodModel?.url
            } else {
                urlString = apodModel?.thumbnail_url
            }
            bindImageUrl?(URL(string: urlString ?? ""))
        }
    }
    
    func setAPODFavourite(isFav: Bool) {
        apodModel?.isFavourite = isFav
        CoreDataHandler.shared.saveContext()
    }
}
