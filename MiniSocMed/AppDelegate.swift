//
//  AppDelegate.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let wireframe = HomeWireframeImpl()
        
        window = UIWindow()
        window?.rootViewController = wireframe.rootController
        window?.makeKeyAndVisible()
        
        return true
    }
}
