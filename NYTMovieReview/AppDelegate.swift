//
//  AppDelegate.swift
//  NYTMovieReview
//
//  Created by Kevin Phua on 2020/1/23.
//  Copyright © 2020 HagarSoft. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let reviewListVC = ReviewListViewController()
        window?.rootViewController = UINavigationController(rootViewController: reviewListVC)
        
        // Create database file
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Save data to database file
        CoreDataStack.sharedInstance.saveContext()
    }
}

