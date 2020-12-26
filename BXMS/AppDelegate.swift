//
//  AppDelegate.swift
//  bxms
//
//  Created by Coder on 09/10/20.
//  Copyright © 2020 Coder. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        LocalizationSystem.shared.locale =
            Bundle.main.localizations.filter { $0 != "Base" }.map { Locale(identifier: $0) }[AppSettings.shared.langs.rawValue + 1]
        
        return true
    }

}

