//
//  NotificationScheduler.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/21/22.
//

import Foundation
import UserNotifications

class NotificationScheduler {
    
    func schedulerNotification(for medication: Medication) {
        
        guard let id = medication.id else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to take your: \(medication.name ?? "")"
        content.sound = .default
        content.userInfo = [Strings.medicationIDKey:id]
        content.categoryIdentifier = Strings.notificationCategoryIdentifier
        
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: medication.timeOfDay ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to add notification request: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotifications(for medication: Medication) {
        guard let id = medication.id else { return }
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }
}
