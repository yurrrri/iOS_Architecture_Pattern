//
//  ToDoData+CoreDataProperties.swift
//  MVC
//
//  Created by 이유리 on 2023/05/26.
//
//

import Foundation
import CoreData


extension ToDoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoData> {
        return NSFetchRequest<ToDoData>(entityName: "ToDoData")
    }

    @NSManaged public var todoText: String?
    @NSManaged public var date: Date?
    @NSManaged public var type: Int64

    var dateString: String? {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = self.date else { return "" }
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }
}

extension ToDoData : Identifiable {

}

