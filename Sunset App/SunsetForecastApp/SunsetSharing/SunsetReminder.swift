import Foundation
import UserNotifications

class SunsetReminder {
    static let shared = SunsetReminder()

    func scheduleNotification(at sunsetTime: Date) {
        let triggerTime = sunsetTime.addingTimeInterval(-15 * 60) // 15 mins before sunset

        let content = UNMutableNotificationContent()
        content.title = "Sunset Snap"
        content.body = "Time to capture today’s sunset!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "sunsetSnapReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                print("Notifications granted.")
            }
        }
    }
}

