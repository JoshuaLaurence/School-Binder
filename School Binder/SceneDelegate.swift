//
//  SceneDelegate.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
import WidgetKit
import SwiftUI
var fromWidget = false
var globalFolderTitleString = String()
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        maybeOpenedFromWidget(urlContexts: URLContexts)
    }
    
    private func maybeOpenedFromWidget(urlContexts: Set<UIOpenURLContext>) {
        guard let urlLink: UIOpenURLContext = urlContexts.first(where: { $0.url.scheme == "widget-deeplink" }) else { return }
        if UserDefaults(suiteName: "group.Joshua-Laurence.School-Binder.To-Widget")?.value(forKey: "firstFolder") != nil {
            let title = UserDefaults(suiteName: "group.Joshua-Laurence.School-Binder.To-Widget")?.value(forKey: "firstFolder") as! String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
            fromWidget = true
            globalFolderTitleString = title
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        UILabel.appearance().adjustsFontForContentSizeCategory = true
        UIImageView.appearance().accessibilityIgnoresInvertColors = false
        
        UINavigationBar().frame = CGRect(x: 0, y: 0, width: 414, height: 38)
        UINavigationBar.appearance().frame = CGRect(x: 0, y: 0, width: 414, height: 38)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        maybeOpenedFromWidget(urlContexts: connectionOptions.urlContexts)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaults.standard.bool(forKey: "firstLaunch") == true {
            print("well lets go 2")
            let initial: UIViewController = storyboard.instantiateViewController(withIdentifier: "OnBoarding")
            self.window?.rootViewController = initial
            UserDefaults.standard.set(false, forKey: "firstLaunch")
            self.window?.makeKeyAndVisible()
        } else {
            if settingsPreferances[0][0] as! String == "on" {
                print("Actually worked with face id 2")
                let initial: UIViewController = storyboard.instantiateViewController(withIdentifier: "BiometricsController")
                self.window?.rootViewController = initial
            } else if settingsPreferances[0][0] as! String == "off" {
                print("No Face ID 2")
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initial: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                self.window?.rootViewController = initial
            }
            self.window?.makeKeyAndVisible()
            UserDefaults.standard.set(false, forKey: "firstLaunch")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    var global = GlobalFunctions()
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        global.saveNotesData()
        global.saveFolderData()
        settingsPreferances[1][1] = (settingsPreferances[1][1] as! UIColor).data()
        UserDefaults.standard.set(settingsPreferances, forKey: "settingsPreferences3")
        
        settingsPreferances[1][1] = global.color(withData: (settingsPreferances[1][1] as! Data))!
        
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

