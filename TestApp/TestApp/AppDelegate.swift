//
//  AppDelegate.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let module = LoginModule()
        let navigation = UINavigationController(rootViewController: module.showLogin())
        module.setNavigation(navigation: navigation)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        setupNavigationController()
        return true
    }

    func setupNavigationController() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = UIColor.AppColors.navigationColor
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
}

