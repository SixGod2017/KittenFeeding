//
//  AppDelegate.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import UIKit
import LeanCloud
import SnapKit
import Reachability
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rotation = 0
    var reachability = Reachability()!
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        switch rotation {
        case 0:
            return .landscape
        case 1:
            return .portrait
        case 2:
            return .allButUpsideDown
        default:
            return .landscape
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        try! reachability.startNotifier()
        configureNofication()
        configureLeanCloud()
        configureJPush(launchOptions)
    return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

}

extension AppDelegate: JPUSHRegisterDelegate {
    func configureNofication() {
        NotificationCenter.default.addObserver(self, selector: #selector(getNetworkStatus), name: .reachabilityChanged, object: nil)
    }
    
    @objc func getNetworkStatus() {
        let info: [String: Bool]
        switch reachability.connection {
        case .cellular, .wifi:
            info = ["key": true]
        case .none:
            info = ["key": false]
        }
        NotificationCenter.default.post(name: Notification.Name("KittenFeeding"), object: nil, userInfo: info)
    }
    
    func configureLeanCloud() {
        do {
            try LCApplication.default.set(id: LeanCloudAppId, key: LeanCloudAppKey)
        } catch {
            fatalError("\(error)")
        }
    }
    
    func configureJPush(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        entity.types = 1 << 0 | 1 << 1 | 1 << 2
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: jPushAppKey, channel: "App Store", apsForProduction: true)
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {}
}

