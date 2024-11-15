//
//  NotificationBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 15/11/24.
//

import SwiftUI
import UserNotifications
import CoreLocation

class  NotificationManager {
    static let instance = NotificationManager()
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Authorization granted")
            } else if let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func sheduleNotification () {
        
        let content  = UNMutableNotificationContent()
        content.title = "this is notificaiton tiitle"
        content.subtitle = "this is notificaiton subtitle"
        content.sound = .default
        content.badge = 1
        
        // time notification
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        // date notificaion
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 21
//        dateComponents.minute = 50
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)//
        
        // location notificaiton
        
        let cordinate = CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2088)
        let region = CLCircularRegion(center: cordinate, radius: 100, identifier: "notification")
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func cacnelNotification () {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
            
    
    
}

struct NotificationBootCamp: View {
    var body: some View {
        VStack {
            Button {
                NotificationManager.instance.requestAuthorization()
            } label: {
            Text("request authorization")
            }
            Button {
                NotificationManager.instance.sheduleNotification()
            } label: {
            Text("shedule notification")
            }
        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        

    }
}

#Preview {
    NotificationBootCamp()
}
