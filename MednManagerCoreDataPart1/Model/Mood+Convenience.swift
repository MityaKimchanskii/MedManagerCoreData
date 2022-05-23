//
//  Mood+Convenience.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/20/22.
//

import Foundation
import CoreData

extension Mood {
    @discardableResult convenience init(mentalState: String, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.mentalState = mentalState
        self.date = date
    }
}
