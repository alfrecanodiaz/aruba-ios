//
//  AppDelegate.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import Fabric
import Crashlytics
import UserNotifications
import FirebaseMessaging
import FBSDKLoginKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureSideMenu()
        configureNavBar()
        configureFirebase()
        configureFabric()
        configureGoogleMaps()
        registerFirebaseNotifications(for: application)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    private func configureGoogleMaps() {
        GMSServices.provideAPIKey("AIzaSyD_ySeU0gpiZY8M4qckaUajRMsXqRhMjA0")
    }

    private func registerFirebaseNotifications(for application: UIApplication) {
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

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    private func configureSideMenu() {
//        SideMenuManager.default.menuAnimationBackgroundColor = .clear
//        SideMenuManager.default.
    }

    private func configureNavBar() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .selected)
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        let font: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : AFont.with(size: 16, weight: .bold), .foregroundColor: Colors.alertTitleColor]
        UISegmentedControl.appearance().setTitleTextAttributes(font, for: .normal)

    }

    private func configureFirebase() {
        FirebaseApp.configure()
    }

    private func configureFabric() {
        Fabric.with([Crashlytics.self])
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        UserManager.shared.pushToken = fcmToken
    }
}
