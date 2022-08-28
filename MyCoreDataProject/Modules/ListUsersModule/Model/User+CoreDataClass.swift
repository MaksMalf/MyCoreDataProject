//
//  User+CoreDataClass.swift
//  MyCoreDataProject
//
//  Created by Maksim Malofeev on 28/08/2022.
//

import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged public var avatar: Data?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
}
