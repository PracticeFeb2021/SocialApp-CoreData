//
//  AppDelegate.swift
//  SocialApp-MVC
//
//  Created by Oleksandr Bretsko on 2/13/21.
//

import UIKit
import CoreData


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        let rootVC = PostListVC.initFromStoryboard()
        rootVC.netService = NetworkManager.shared
        
        let coreDataManager = dataManager
        //coreDataManager.deleteStore()
        coreDataManager.loadStore()
        rootVC.dataManager = coreDataManager
        
        let rootNC = UINavigationController(rootViewController: rootVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - Core Data 
    
    lazy var dataManager: CoreDataManager = {
        CoreDataManager(datamodelName: "SocialApp_CoreData")
    }()
}

