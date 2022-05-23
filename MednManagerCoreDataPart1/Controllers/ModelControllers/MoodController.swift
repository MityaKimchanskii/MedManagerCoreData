//
//  MoodController.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/20/22.
//

import Foundation
import CoreData


class MoodController {
    
    // MARK: - Properties
    static let shared = MoodController()
    
    private init() {}
    
    var moods: [Mood] = []
    var todayMoodServey: Mood?
    
    private lazy var fetchRequest: NSFetchRequest<Mood> = {
        let request = NSFetchRequest<Mood>(entityName: "Mood")
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
        let afterPredicate = NSPredicate(format: "date > %@", startOfDay as NSDate)
        let beforePredicate = NSPredicate(format: "date < %@", endOfDay as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterPredicate, beforePredicate])
        return request
    }()
    
    // MARK: - CRUD
    // Create
    private func createMood(mentalState: String) {
        let mood = Mood(mentalState: mentalState, date: Date())
        todayMoodServey = mood
        CoreDataStack.saveContext()
    }
    
    // Read
    func fetchMood() -> Mood? {
        guard let todayMood = try? CoreDataStack.context.fetch(fetchRequest).first else { return nil }
        self.todayMoodServey = todayMood
        
        return todayMoodServey
    }
    
    // Update
    private func update(newMentalState: String) {
        guard let todayMoodServey = todayMoodServey else { return }
        todayMoodServey.mentalState = newMentalState
        CoreDataStack.saveContext()
    }
    
    func didTapMoodEmoji(_ emoji: String) {
        if todayMoodServey != nil {
            update(newMentalState: emoji)
        } else {
            createMood(mentalState: emoji)
        }
    }
}
