//
//  TakenDate.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/16/22.
//

import CoreData

extension TakenDate {
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.medication = medication
    }
}
