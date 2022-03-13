//
//  Article+CoreDataProperties.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension Article : Identifiable {

}
