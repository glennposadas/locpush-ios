//
//  ViewController.swift
//  LocPushSample
//
//  Created by Glenn Posadas on 12/24/20.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
          if success {
              print("All set!")
          } else if let error = error {
              print(error.localizedDescription)
          }
      }
      

      let content = UNMutableNotificationContent()
      content.title = "Feed the cat + \(Int.random(in: 0..<5))!"
      content.subtitle = "It looks hungry2"
      content.sound = UNNotificationSound.default

      // show this notification five seconds from now
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

      // choose a random identifier
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

      // add our notification request
      UNUserNotificationCenter.current().add(request)
      
      
    }
  }
}

