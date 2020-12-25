//
//  LocalPush.swift
//  LocPushSample
//
//  Created by Glenn Posadas on 12/24/20.
//

import UIKit
import UserNotifications

/**
 A simple wrapper for scheduling local push notification.
 
 #IMPORTANT!:
 - Conform your `AppDelegate` to `UNUserNotificationCenterDelegate`.
 - Implement `optional func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)`
 */
class LocalPush {
  
  // MARK: - Properties
  
  static let shared = LocalPush()
  
  // MARK: Functions
  
  private init () { }
  
  // MARK: Start
  
  /// The block called by `requestPush`.
  typealias RequestAuthorizationCompletionBlock = ((_ success: Bool, _ error: Error?) -> Void)
  ///Start by requesting authorization for push notification.
  func requestPush(block: @escaping RequestAuthorizationCompletionBlock) {
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: block)
  }
  
  /// Start scheduling local push notification. This calls the `requestPush`.
  /// Only present an alert when there's an error. User may decline the permission request but there'd be no use for an alert.
  func start() {
    requestPush { (success, error) in
      if let error = error {
        self.alert("An error has occured: \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: - Canceling
  
  /// Remove a scheduled local push by id.
  func removePush(_ id: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
  }
  
  /// Remove all scheduled local push
  func removeAllScheduled() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
  
  /// Remove all delivered push.
  func removeAllDelivered() {
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
  }
  
  /// Remove all delivered and scheduled push.
  func removeAllDeliveredAndScheduled() {
    removeAllDelivered()
    removeAllScheduled()
  }
  
  // MARK: - Scheduling
  
  /// Schedule a default push, using trigger.
  func schedulePush(
    id: String = UUID().uuidString,
    title: String,
    subtitle: String?,
    sound: UNNotificationSound = .default,
    trigger: UNNotificationTrigger?) {

    let content = UNMutableNotificationContent()
    content.title = title
    
    if let subtitle = subtitle {
      content.subtitle = subtitle
    }
    
    content.sound = UNNotificationSound.default

    // choose a random identifier
    let request = UNNotificationRequest(
      identifier: id,
      content: content,
      trigger: trigger
    )

    // add our notification request
    UNUserNotificationCenter.current().add(request)
  }
  
  /// Schedule a default push, with all the parameters involved.
  func schedulePush(
    id: String,
    title: String,
    subtitle: String?,
    sound: UNNotificationSound = .default,
    interval: TimeInterval,
    repeats: Bool) {
    
    let trigger = getTrigger(timeInterval: interval, repeats: repeats)
    
    schedulePush(id: id, title: title, subtitle: subtitle, trigger: trigger)
  }
  
  /// Schedule a push using hour and minute.
  func schedulePush(
    id: String = UUID().uuidString,
    title: String,
    subtitle: String?,
    hour: Int,
    minute: Int,
    repeats: Bool) {
    
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current

    dateComponents.hour = hour
    dateComponents.minute = minute
       
    // Create the trigger as a repeating event.
    let trigger = UNCalendarNotificationTrigger(
      dateMatching: dateComponents,
      repeats: repeats
    )
    
    schedulePush(id: id, title: title, subtitle: subtitle, trigger: trigger)
  }
  
  // MARK: - Private
  
  /// Get a trigger using `TimeInterval`.
  private func getTrigger(timeInterval: TimeInterval, repeats: Bool) -> UNTimeIntervalNotificationTrigger {
    let trigger = UNTimeIntervalNotificationTrigger(
      timeInterval: timeInterval,
      repeats: repeats
    )
    
    return trigger
  }
  
  /// Present an alert from the `UIApplication.shared.currentScreen()`.
  private func alert(_ message: String) {
    let alert = UIAlertController(
      title: nil,
      message: message,
      preferredStyle: .alert
    )
    
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alert.addAction(ok)
    
    UIApplication.shared.currentScreen()?
      .present(alert, animated: true, completion: nil)
  }
}
