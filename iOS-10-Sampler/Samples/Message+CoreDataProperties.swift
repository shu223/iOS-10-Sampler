//
//  Message+CoreDataProperties.swift
//  iOS-10-Sampler
//
//  Created by Noritaka Kamiya on 2016/08/31.
//  Copyright © 2016 Noritaka Kamiya. All rights reserved.
//

import Foundation
import CoreData

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: NSDate?

}
