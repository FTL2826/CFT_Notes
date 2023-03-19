//
//  Notes+CoreDataProperties.swift
//  Notes
//
//  Created by Александр Харин on /173/23.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var title: String
    @NSManaged public var noteContex: NSMutableAttributedString
    @NSManaged public var date: Date
}

extension Notes : Identifiable {

}
