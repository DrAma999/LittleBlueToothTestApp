//
//  AppDelegate.swift
//  Test
//
//  Created by Andrea Finollo on 11/06/2020.
//  Copyright © 2020 Andrea Finollo. All rights reserved.
//

import UIKit
import LittleBlueTooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var littleBT: LittleBlueTooth!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        var littleBTConf = LittleBluetoothConfiguration()
        littleBTConf.autoconnectionHandler = { (perip, error) -> Bool in
            return true
        }
    
        littleBT = LittleBlueTooth(with: littleBTConf)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20)) {
////            os_log("Crashing ", log: OSLog.BT_Log_General, type: .debug)
////            kill(getpid(), SIGKILL)
//            if ([0][1] == 1){
//                exit(0)
//            }
//            exit(1)
//        }
        
        return true
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
//        os_log("Launch option %{public}@ ", log: OSLog.BT_Log_General, type: .debug, options.description)
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
