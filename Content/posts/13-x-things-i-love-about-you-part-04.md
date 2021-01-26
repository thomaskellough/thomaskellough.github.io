---
date: 2021-01-24 12:08
description: This section adds local notifications to your app.
tags: LocalNotifications
---
# Create a unique Valentine's Day app for your loved one - Part 4

<div class="post-tags" markdown="1">
  <a class="post-category post-category-localnotifications" href="/tags/localnotifications">LocalNotifications</a>
</div>

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/13-x-things-i-love-about-you-part-03" style="text-decoration: none">&larr; Animations and UserDefaults</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/13-x-things-i-love-about-you-part-05" style="text-decoration: none">Conclusion &rarr;</a></th>
    </tr>
</table>

### Adding local notifications
Now that we have our app configured how we want, we need to add local notifications. This means every day the user will get a reminder to open the app and see the next thing you love about them.

I think it's best to separate your local notification in one class by itself. So, create a new swift file called `NotificationManager.swift`. UserNotifications can be complicated, so I'll just paste the entire file and comment out what's happening in each step:
```
import Foundation
import UserNotifications

class NotificationManager {
    
    // This will be the function we call in order to register local notifications for the user
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        // If we are at the end of the list, stop scheduling notifications
        let maxDay = UserDefaults.standard.integer(forKey: "maxDay")
        let totalCompliments = AllCompliments().compliments.count - 1

        // If we are at the maximum number of compliments, stop sending notifications!
        if maxDay == totalCompliments {
            center.removeAllPendingNotificationRequests()
            return
        }
        
        // If we made it here then we still have more compliments to go. Ask the user for permission and if they grant, schedule the notifications.
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                self.scheduleLocal()
            } else {
                print("User denied permission!")
            }
        }
        
        registerCateories()
    }
    
    // This function is what shows then the user gets the notification and swipes down.
    func registerCateories() {
        let center = UNUserNotificationCenter.current()

        let show = UNNotificationAction(identifier: "show", title: "Okay, tell me!", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    // This is what the notification will say to the user
    func scheduleLocal() {
        registerCateories()
        let center = UNUserNotificationCenter.current()
        // It's a good idea to remove any pending notifications before we schedule more.
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "I love you!"
        content.body = "Come see the next thing I love about you!"
        content.categoryIdentifier = "alarm"
        content.sound = .default
        
        // When do you want to show it. This will notify the user at 8:00 am every morning. 
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let requests = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(requests)
    }
}
```

Then, in `viewDidLoad` of `ComplimentViewController.swift` add the following line at the end:
```
NotificationManager().registerLocal()
```

<table class="posts-table">
    <tr>
        <th class="th-left"><a href="/posts/13-x-things-i-love-about-you-part-03" style="text-decoration: none">&larr; Animations and UserDefaults</a></th>
        <th class="th-middle"></th>
        <th class="th-right"><a href="/posts/13-x-things-i-love-about-you-part-05" style="text-decoration: none">Conclusion &rarr;</a></th>
    </tr>
</table>
