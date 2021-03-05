//
//  AppDelegate.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Variable Declaration
    var global = GlobalFunctions()
    var window: UIWindow?
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        //MARK: Ordering Trash When App Regains Foreground Control
        global.sortOutTheTrash()
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: Retrieve Settings Preferances
        if UserDefaults.standard.value(forKey: "settingsPreferences3") as? [[Any]] != nil {
            print("Retrieving Settings")
            settingsPreferances = UserDefaults.standard.value(forKey: "settingsPreferences3") as! [[Any]]
            settingsPreferances[1][1] = global.color(withData: (settingsPreferances[1][1] as! Data))!
            settingsPreferances.append(["1.0"])
        }
        // MARK: Fetch All Data
        global.requestAllNotesData()
        global.requestAllFolderData()
        global.sortOutTheTrash()
        
        UILabel.appearance().adjustsFontForContentSizeCategory = false
    
        for a in 0..<theNotes.count {
            print(theNotes[a][0], "+", theNotes[a][5])
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        if UserDefaults.standard.value(forKey: "firstLaunch") as? Bool == nil {
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
        
        //UserDefaults.standard.set(true, forKey: "firstLaunch")
        
        if UserDefaults.standard.bool(forKey: "firstLaunch") == true {
            
            // MARK: First Launch Configuration
            print("well lets go")
            
            settingsPreferances.removeAll()
            theNotes.removeAll()
            theFolders.removeAll()
            
            settingsPreferances.append(["off"])
            settingsPreferances.append(["Monochrome", UIColor.label.data()])
            settingsPreferances.append(["on"])
            settingsPreferances.append(["on"])
            settingsPreferances.append(["1.0"])
            
            UserDefaults.standard.set(settingsPreferances, forKey: "settingsPreferences3")
            
            settingsPreferances[1][1] = global.color(withData: settingsPreferances[1][1] as! Data)!
            
            theFolders.append(["Welcome", "mainFolder", UIColor.systemPurple, Int64(0), false])
            theFolders.append(["Welcome/The Settings Page", "subFolder", UIColor.clear, Int64(0), false])
            theFolders.append(["Welcome/The Difficulty Page", "subFolder", UIColor.clear, Int64(0), false])
            theFolders.append(["Welcome/The Search Page", "subFolder", UIColor.clear, Int64(0), false])
            theFolders.append(["Welcome/The Home Page", "subFolder", UIColor.clear, Int64(0), false])
            theFolders.append(["Welcome/The Trash Page", "subFolder", UIColor.clear, Int64(0), false])
            
            theNotes.append(["Welcome to School Binder",
                             "Welcome",
                             "School Binder is an app dedicted to Secondary and University Students who need to store their revision notes. Its simple and easy to use, here are the instructions. The app is made up of 5 main pages\n\n*The Settings Page*\n*The Difficulty Page*\n*The Search Page*\n*The Home Page*\n*The Trash Page*\n\nAs you will notice, you can: *bold* by adding (*) around the text, _underline_ by adding (_) around the text, /italic/ by adding (/) around the text, =strike= by adding (=) around the text and ~highlight~ by adding (~) around the text.\n\nCheck out the other notes to see how each page is working",
                             "unrated", false, Int64(0)])
            
            theNotes.append(["The Features of the Folders",
                             "Welcome",
                             " - If you swipe *right* on a _subject_ then you will be able to add a /topic/ to that main folder. This can also be done from within a main folder with the button in the top right corner\n- If you swipe *left* on a _subject_ you can either /edit/ or /delete/ the subject\n- If you swipe *right* on a _topic_ you can /edit/ the topic\n- And finally if you swipe *left* on a _topic_ you can /delete/ said topic\n\nYou may have noticed a little _slider_ with different numbers on just below the foler name. This is the *Difficulty Rating* and will make a lot more sense if you look into _the difficulty page_ subfolder", "green", false, Int64(0)])
            
            
            
            
            
            global.saveFolderData()
            global.saveNotesData()
            
            let initial: UIViewController = storyboard.instantiateViewController(withIdentifier: "OnBoarding")
            self.window?.rootViewController = initial
            self.window?.makeKeyAndVisible()
            
        } else {
            if settingsPreferances[0][0] as! String == "on" {
                // MARK: Biometrics Locking System
                print("Actually worked with face id")
                
                let initial: UIViewController = storyboard.instantiateViewController(withIdentifier: "BiometricsController")
                self.window?.rootViewController = initial
                
            } else if settingsPreferances[0][0] as! String == "off" {
                print("No Face ID")
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initial: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                self.window?.rootViewController = initial
                
            }
            self.window?.makeKeyAndVisible()
        }
        
        // MARK: Customise Navigation Bar
        
        UINavigationBar().frame = CGRect(x: 0, y: 0, width: 414, height: 38)
        UINavigationBar.appearance().frame = CGRect(x: 0, y: 0, width: 414, height: 38)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UINavigationBar().shadowImage = UIImage()
        UINavigationBar().setBackgroundImage(UIImage(), for: .default)
        let navFont = UIFont(name: "Futura", size: 20)
        let navFontAttribute = [NSAttributedString.Key.font : navFont]
        UINavigationBar.appearance().titleTextAttributes = navFontAttribute as [NSAttributedString.Key : Any]
        UINavigationBar.appearance().tintColor = (settingsPreferances[1][1] as! UIColor)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Saved Resign")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        // MARK: Save Data When App Quits
        global.saveNotesData()
        global.saveFolderData()
        settingsPreferances[1][1] = (settingsPreferances[1][1] as! UIColor).data()
        UserDefaults.standard.set(settingsPreferances, forKey: "settingsPreferences3")
        
        print("Quitting...")
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var str = String()
        do {
            str = try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Error")
        }
        print("This Files Contents: \(str)")
        return true
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "School_Binder")
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

