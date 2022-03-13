//
//  Articles+CoreDataProperties.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//
//

import Foundation
import CoreData


extension Articles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Articles> {
        return NSFetchRequest<Articles>(entityName: "Articles")
    }

    @NSManaged public var date: String?
    @NSManaged public var urlToImage: Date?
    @NSManaged public var url: String?
    @NSManaged public var title: String?

}

extension Articles : Identifiable {

}
