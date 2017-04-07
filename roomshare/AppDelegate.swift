//
//  AppDelegate.swift
//  roomshare
//
//  Created by Daniel Berger on 14/03/2017.
//  Copyright © 2017 Daniel Berger. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
  
  var window: UIWindow?
  let gcmMessageIDKey = "gcm.message_id"
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // iOS 10 support
    if #available(iOS 10, *) {
      UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
      application.registerForRemoteNotifications()
      // For iOS 10 data message (sent via FCM)
      FIRMessaging.messaging().remoteMessageDelegate = self
    }
      /*     // iOS 9 support
       else if #available(iOS 9, *) {
       UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
       UIApplication.shared.registerForRemoteNotifications()
       }
       // iOS 8 support
       else if #available(iOS 8, *) {
       UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
       UIApplication.shared.registerForRemoteNotifications()
       }*/
      // iOS 7 support
    else {
      application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
    }
    
    //Do Firebase configurations
    FIRApp.configure()
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //APNS Token receive
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    UserDefaults.standard.setValue(deviceTokenString, forKey: "apn_token")
    print("APN register succesfull, token: \(deviceTokenString)")
    
    FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("APN register failed: \(error)")
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    completionHandler(UIBackgroundFetchResult.newData)
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    FIRMessaging.messaging().disconnect()
    print("Disconnected from FCM.")
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    FIRMessaging.messaging().disconnect()
    FIRMessaging.messaging().connect { (error) in
      if error != nil {
        print("Unable to connect with FCM. \(error)")
      } else {
        print("Connected to FCM token: \(FIRInstanceID.instanceID().token()!)")
        UserDefaults.standard.setValue(FIRInstanceID.instanceID().token()!, forKey: "fcm_token")
      }
    }
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    self.saveContext()
  }
  
  
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "db")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

extension AppDelegate : FIRMessagingDelegate {
  // Receive data message on iOS 10 devices while app is in the foreground.
  func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
    print(remoteMessage.appData)
  }
}

