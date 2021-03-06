//
//  AppDelegate.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var instanceToken: String?
    var deviceTokenString: String?
    var notificationBadgeCount = Int(0)
    var fcm_token : String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        application.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            if session.isPaired != true {
                print("Apple Watch is not paired")
            }
            
            if session.isWatchAppInstalled != true {
                print("WatchKit app is not installed")
            }
        } else {
            print("WatchConnectivity is not supported on this device")
        }
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -500.0, vertical: 0.0), for: .default)

        let Logged = UserDefaults.standard.bool(forKey: "Logged")
        if Logged == true{
            RootPatientHomeVC()
        } else {
            SwitchLogin()
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        notificationBadgeCount = 0
        application.registerForRemoteNotifications()
        self.registerForPushNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Override point for customization after application launch.
        return true
    }
    
    func SwitchLogin(){
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPage")
        window?.rootViewController = loginViewController
    }
    func RootPatientHomeVC(){
        let Rootvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "splitview") as? UISplitViewController
        Rootvc?.preferredDisplayMode = .allVisible
        
        window?.rootViewController = Rootvc
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let detailvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MedicineViewController")
            let nav = UINavigationController(rootViewController: detailvc)
            nav.navigationBar.barTintColor = #colorLiteral(red: 0.2117647059, green: 0.09411764706, blue: 0.3294117647, alpha: 1)
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            Rootvc?.showDetailViewController(nav, sender: nil)
        }
        Rootvc?.preferredDisplayMode = .allVisible
        if let navController = Rootvc?.viewControllers[0] as? UINavigationController {
            navController.popViewController(animated: true)
        }
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("resignactive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("becomeactive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        print("terminate")
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "medocpatient")
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
extension AppDelegate:  UNUserNotificationCenterDelegate, MessagingDelegate{
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        self.fcm_token = fcmToken
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
    }
    
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content
        
        print(userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        
        if response.actionIdentifier == SoonzeIdentifier {
            let request = response.notification.request
            let content = request.content
            print(content)
            let attachments = content.attachments as? [UNNotificationAttachment]
            
            guard let oldTrigger = response.notification.request.trigger as? UNCalendarNotificationTrigger else {
                debugPrint("Cannot reschedule notification without calendar trigger.")
                return
            }
            
            let oldcomponents = oldTrigger.dateComponents
            let currentDate = Calendar.current.date(from: oldcomponents)
            let addDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate!)
            print(oldcomponents)
            let components = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second], from: addDate!)
            print(components)
            
            let snoozeTrigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false)
            let snoozeRequest = UNNotificationRequest(
                identifier: request.identifier,
                content: content,
                trigger: snoozeTrigger)
            center.add(snoozeRequest){
                (error) in
                if error != nil {
                    print("Snooze Request Error: \(error?.localizedDescription)")
                }
                else {
                    if (WCSession.default.isReachable) {
                        do {
                            let data = try NSKeyedArchiver.archivedData(withRootObject: snoozeRequest, requiringSecureCoding: false)
                            let message = ["AddSoonze": data]
                            WCSession.default.sendMessage(message, replyHandler: nil)
                        } catch {
                            print("catch nskeyarchiever")
                        }
                    }
                }
            }
        }
        else if response.actionIdentifier == TakenIdentifier {
            let request = response.notification.request
            let content = response.notification.request.content
            print(content)
            
            let medicineid: String = String(request.identifier.split(separator: "-")[1])
            
            let def = UserDefaults(suiteName: group)
            
            let takendata = ["id": medicineid,"time": Date()] as [String : Any]
            var gettakenmedicinetime = def?.array(forKey: "TakenMedicineTime") as? [[String: Any]]
            
            if gettakenmedicinetime?.count == 0 || gettakenmedicinetime == nil {
                var dict = [[String: Any]]()
                dict.append(takendata)
                def?.set(dict, forKey: "TakenMedicineTime")
                def?.synchronize()
            } else {
                gettakenmedicinetime?.append(takendata)
                def?.set(gettakenmedicinetime, forKey: "TakenMedicineTime")
                def?.synchronize()
            }
            
            
            if (WCSession.default.isReachable) {
                let message = ["refresh": true]
                WCSession.default.sendMessage(message, replyHandler: nil)
            }
        }
        
        completionHandler()
    }
   
    func application(received remoteMessage: MessagingRemoteMessage)
    {
        print(remoteMessage.appData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        // Print full message.
        print("message recived")
        notificationBadgeCount = notificationBadgeCount + 1
        UIApplication.shared.applicationIconBadgeNumber = notificationBadgeCount
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func instance() -> AppDelegate{
        return AppDelegate()
    }
}
extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    
}
