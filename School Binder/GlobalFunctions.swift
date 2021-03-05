//
//  GlobalFunctions.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GlobalFunctions: NSObject {
    
    //MARK: GLOBALLY USED FUNCTIONS
    
    func sortOutTheTrash() {
        //MARK: Check What In The Trash Needs Emptying
        print(temporarilyDeleted.count)
        var deletedItems = [[[Any]]]()
        for a in 0..<temporarilyDeleted.count {
            print(a)
            print(temporarilyDeleted[a][0][1])
            print(Date())
            print(temporarilyDeleted[a][1][0])
            let noteDate = temporarilyDeleted[a][1][0] as! Date
            let currentDate = Date()
            if currentDate >= noteDate {
                deletedItems.append(temporarilyDeleted[a])
            }
        }
        if deletedItems.isEmpty != true {
            for b in 0..<deletedItems.count {
                let index = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == deletedItems[b][0][0] as! String && $0[0][1] as! String == deletedItems[b][0][1] as! String && $0[0][2] as! String == deletedItems[b][0][2] as! String && $0[0][3] as! String == deletedItems[b][0][3] as! String && $0[0][4] as! Bool == deletedItems[b][0][4] as! Bool && $0[0][5] as! Int64 == deletedItems[b][0][5] as! Int64 && $0[1][0] as! Date == deletedItems[b][1][0] as! Date})!
                temporarilyDeleted.remove(at: index)
            }
            deletedItems.removeAll()
        }
    }
    
    func pow() {
        //MARK: Check Whether Or Not To Perform A Haptic Tap
        if settingsPreferances[3][0] as! String == "on" {
            let pow = UIImpactFeedbackGenerator()
            pow.prepare()
            pow.impactOccurred()
        }
    }
    
    func DataFetch (arrayIn:[[Any]], arrayWhole:[[Any]]) -> [[Any]] {
        //MARK: Ordering The Arrays Into An Easier Format
        var arr = arrayIn
        arr.removeAll()
        for a in 0..<arrayWhole.count {
            if arrayWhole[a][5] as! Int64 == 0 {
                arr.append(arrayWhole[a])
            } else if arrayWhole[a][5] as! Int64 == 1 {
                arr.append(arrayWhole[a])
            } else {
                if a == (arrayWhole.count - 1) {
                    arr[arr.count - 1][5] = arrayWhole[a][5]
                } else if arrayWhole[a + 1][5] as! Int64 == 0 || arrayWhole[a + 1][5] as! Int64 == 1 {
                    arr[arr.count - 1][5] = arrayWhole[a][5]
                }
            }
        }
        return arr
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        //MARK: Converting A Stored String Into Its Image
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }

    func convertImageToBase64String (img: UIImage) -> String {
        //MARK: Converting An Image Into A Storable String
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func requestAllNotesData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.returnsObjectsAsFaults = false
        var titleTemp = String()
        var tagsTemp = String()
        var contentTemp = String()
        var struggleRatingTemp = String()
        var isImageTemp = Bool()
        var pageNumberTemp = Int64()
        var deleteDateTemp = Date()
        let requestTrash = NSFetchRequest<NSFetchRequestResult>(entityName: "TrashNote")
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        titleTemp = title
                    }
                    if let tags = result.value(forKey: "tags") as? String {
                        tagsTemp = tags
                    }
                    if let content = result.value(forKey: "content") as? String {
                        contentTemp = content
                    }
                    if let struggleRating = result.value(forKey: "struggleRating") as? String {
                        struggleRatingTemp = struggleRating
                    }
                    if let isImage = result.value(forKey: "isImage") as? Bool {
                        isImageTemp = isImage
                    }
                    if let pageNumber = result.value(forKey: "pageNumber") as? Int64 {
                        pageNumberTemp = pageNumber
                    }
                    theNotes.append([titleTemp, tagsTemp, contentTemp, struggleRatingTemp, isImageTemp, pageNumberTemp])
                }
            }
        } catch {
            print("Error")
        }
        
        do {
            let results = try context.fetch(requestTrash)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        titleTemp = title
                    }
                    if let tags = result.value(forKey: "tags") as? String {
                        tagsTemp = tags
                    }
                    if let content = result.value(forKey: "content") as? String {
                        contentTemp = content
                    }
                    if let struggleRating = result.value(forKey: "struggleRating") as? String {
                        struggleRatingTemp = struggleRating
                    }
                    if let isImage = result.value(forKey: "isImage") as? Bool {
                        isImageTemp = isImage
                    }
                    if let pageNumber = result.value(forKey: "pageNumber") as? Int64 {
                        pageNumberTemp = pageNumber
                    }
                    if let deleteDate = result.value(forKey: "deletionDate") as? Date {
                        deleteDateTemp = deleteDate
                    }
                    temporarilyDeleted.append([[titleTemp, tagsTemp, contentTemp, struggleRatingTemp, isImageTemp, pageNumberTemp],[deleteDateTemp]])
                }
            }
        } catch {
            print("Error")
        }
    }
    func requestAllFolderData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        request.returnsObjectsAsFaults = false
        var titleTemp = String()
        var stateTemp = String()
        var colourTemp = UIColor()
        var subStateTemp = Int64()
        var hiddenTemp = Bool()
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        titleTemp = title
                    }
                    if let state = result.value(forKey: "state") as? String {
                        stateTemp = state
                    }
                    if let colour = result.value(forKey: "colour") as? UIColor {
                        colourTemp = colour
                    }
                    if let subState = result.value(forKey: "subState") as? Int64 {
                        subStateTemp = subState
                    }
                    if let hidden = result.value(forKey: "hidden") as? Bool {
                        hiddenTemp = hidden
                    }
                    theFolders.append([titleTemp, stateTemp, colourTemp, subStateTemp, hiddenTemp])
                }
            }
        } catch {
            print("Error")
        }
    }
    
    func saveNotesData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let DelAllReqVarNote = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Note"))
        do {
            try context.execute(DelAllReqVarNote)
        }
        catch {
            print(error)
        }
        
        let DelAllReqVarTrash = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "TrashNote"))
        do {
            try context.execute(DelAllReqVarTrash)
        }
        catch {
            print(error)
        }
        
        for a in 0..<theNotes.count {
            let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
            newNote.setValue(theNotes[a][0], forKey: "title")
            newNote.setValue(theNotes[a][1], forKey: "tags")
            newNote.setValue(theNotes[a][2], forKey: "content")
            newNote.setValue(theNotes[a][3], forKey: "struggleRating")
            newNote.setValue(theNotes[a][4], forKey: "isImage")
            newNote.setValue(theNotes[a][5], forKey: "pageNumber")
            
            do {
                try context.save()
            } catch {
                print("Error")
            }
        }
        for a in 0..<temporarilyDeleted.count  {
            let newNote = NSEntityDescription.insertNewObject(forEntityName: "TrashNote", into: context)
            newNote.setValue(temporarilyDeleted[a][0][0], forKey: "title")
            newNote.setValue(temporarilyDeleted[a][0][1], forKey: "tags")
            newNote.setValue(temporarilyDeleted[a][0][2], forKey: "content")
            newNote.setValue(temporarilyDeleted[a][0][3], forKey: "struggleRating")
            newNote.setValue(temporarilyDeleted[a][0][4], forKey: "isImage")
            newNote.setValue(temporarilyDeleted[a][0][5], forKey: "pageNumber")
            newNote.setValue(temporarilyDeleted[a][1][0], forKey: "deletionDate")
            
            do {
                try context.save()
            } catch {
                print("Error")
            }
        }
    }
    func saveFolderData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Folder"))
        do {
            try context.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
        
        for a in 0..<theFolders.count {
            let newNote = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: context)
            newNote.setValue(theFolders[a][0], forKey: "title")
            newNote.setValue(theFolders[a][1], forKey: "state")
            newNote.setValue(theFolders[a][2], forKey: "colour")
            newNote.setValue(theFolders[a][3], forKey: "subState")
            newNote.setValue(theFolders[a][4], forKey: "hidden")
            do {
                try context.save()
            } catch {
                print("Error")
            }
        }
    }
    func color(withData data: Data) -> UIColor? {
        do {
           return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        } catch {
            print("Error")
        }
        return UIColor()
    }
    
    func colorString(withCodedString string: String) -> UIColor? {
        guard let data = Data(base64Encoded: string) else{
            return nil
        }

        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}
extension UIColor {
   func data() -> Data {
    do {
        return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    } catch {
        print("Error")
    }
    return Data()
   }
    
    func dataString() -> String {
         do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            return data.base64EncodedString()
         } catch {
             print("Error")
         }
        return String()
    }
    
    func lighter(by percentage: CGFloat = 10.0) -> UIColor {
        return self.adjust(by: abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor {

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {

            let pFactor = (100.0 + percentage) / 100.0

            let newRed = (red*pFactor).clamped(to: 0.0 ... 1.0)
            let newGreen = (green*pFactor).clamped(to: 0.0 ... 1.0)
            let newBlue = (blue*pFactor).clamped(to: 0.0 ... 1.0)

            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
        }

        return self
    }
}

extension Comparable {

    func clamped(to range: ClosedRange<Self>) -> Self {

        if self > range.upperBound {
            return range.upperBound
        } else if self < range.lowerBound {
            return range.lowerBound
        } else {
            return self
        }
    }
}
