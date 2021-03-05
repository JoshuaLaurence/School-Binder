//
//  HomePage.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
var theFolders = [[Any]]()
var isGoingIntoFolder = false
var folderEditing = [0, false, ""] as [Any]

class HomePagePreviewMain: UIViewController {
    
    @IBOutlet weak var HomePagePreviewMainTitle: UILabel!
    @IBOutlet weak var HomePagePreviewMainQuantity: UILabel!
    var mainTitleString = String()
    var mainQuantityString = String()
    var mainBackgroundColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomePagePreviewMainTitle.text = mainTitleString
        HomePagePreviewMainQuantity.text = mainQuantityString
        self.view.backgroundColor = mainBackgroundColor
    }
    
}

class HomePagePreviewSub: UIViewController {
    
}

class HomePage: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    let transition = SlidingMenuTransition()
    let struggling = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Struggling") as! StrugglingPage
    let trash = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Trash") as! TrashPage
    var theFoldersFiltered  = [[Any]]()
    var searchingCurrently = false
    
    @IBOutlet weak var HomePageEditButton: UIButton!
    var rearranging = false
    var editingArrayCloneOfFoldersArray = [[Any]]()
    @IBAction func HomePageEditButtonAction(_ sender: UIButton) {
        if HomePageEditButton.titleLabel!.text == "Edit" {
            HomePageEditButton.setTitle("Done", for: .normal)
            editingArrayCloneOfFoldersArray = theFolders
            for a in 0..<theFolders.count {
                if theFolders[a][1] as! String == "subFolder" {
                    theFolders[a][4] = true
                }
            }
            theFoldersFiltered.removeAll()
            HomePageFolderSearchBar.endEditing(true)
            HomePageFolderSearchBar.text = ""
            for a in 0..<theFolders.count {
                if theFolders[a][1] as! String == "mainFolder" {
                    theFoldersFiltered.append(theFolders[a])
                }
            }
            HomePageTableView.reloadData()
            HomePageTableView.setEditing(true, animated: true)
        } else {
            if rearranging {
                HomePageTableView.setEditing(false, animated: true)
                var index = 0
                for a in (startEditingRowIndex + 1)..<endEditingRowIndex {
                    theFolders[a][4] = booleanRowSaveTemporary[index]
                    index += 1
                }
                booleanRowSaveTemporary.removeAll()
                theFoldersFiltered.removeAll()
                searchingFunction(searchText: HomePageFolderSearchBar.text!)
                startEditingRowIndex = 0
                endEditingRowIndex = 0
                rearranging = false
            } else {
                for a in 0..<theFolders.count {
                   theFolders[a][4] = editingArrayCloneOfFoldersArray[a][4]
                }
                theFoldersFiltered.removeAll()
                theFoldersFiltered = theFolders
                editingArrayCloneOfFoldersArray = [[Any]]()
            }
            HomePageEditButton.setTitle("Edit", for: .normal)
            HomePageTableView.reloadData()
            HomePageTableView.setEditing(false, animated: true)
        }
    }
    
    @IBAction func HomePageMenuButtonAction3(_ sender: UIButton) {
        global.pow()
        let menu = storyboard?.instantiateViewController(identifier: "Menu") as! MenuPage
        menu.didTapMenuType = { menuType in
            self.transitionToNewView(menuType)
        }
        menu.modalPresentationStyle = .custom
        menu.transitioningDelegate = self
        menuItemPreviouslySelected = "Home"
        present(menu, animated: true)
    }
    
    @IBOutlet weak var HomePageSearchButtonLabel: UILabel!
    @IBOutlet weak var HomePageSearchButton: UIButton!
    @IBAction func HomePageSearchButtonAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAllNotesTV"), object: self)
        self.performSegue(withIdentifier: "searchPageSegue", sender: self)
    }
    
    @IBOutlet weak var HomePageMenuButton4: UIButton!
    func transitionToNewView(_ menuType: MenuType) {
        print(menuType)
        switch menuType {
        case .home:
            self.struggling.view.isHidden = true
            self.trash.view.isHidden = true
            self.trash.viewDidDisappear(true)
            self.struggling.viewDidDisappear(true)
            self.view.sendSubviewToBack(self.trash.view)
            self.view.sendSubviewToBack(self.struggling.view)
            HomePageAddFolderButton.tintColor = (settingsPreferances[1][1] as! UIColor)
            HomePageTableView.reloadData()
        case .struggling:
            self.struggling.view.isHidden = false
            self.trash.view.isHidden = true
            self.view.bringSubviewToFront(self.struggling.view)
            self.view.sendSubviewToBack(self.trash.view)
            self.trash.viewDidDisappear(true)
            self.struggling.viewDidAppear(true)
        case .trash:
            self.trash.view.isHidden = false
            self.struggling.view.isHidden = true
            self.view.bringSubviewToFront(self.trash.view)
            self.view.sendSubviewToBack(self.struggling.view)
            self.struggling.viewDidDisappear(true)
            self.trash.viewDidAppear(true)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if theFoldersFiltered.isEmpty {
            tableView.setEmptyConditions(title: "No Folders", message: "Add a folder by using the plus in the top right corner", width: tableView.frame.width, height: tableView.frame.height, center: tableView.center, iconImageTitle: "building.columns")
        } else {
            tableView.restoreFromEmpty()
        }
        return theFoldersFiltered.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var Cell: UITableViewCell = UITableViewCell()
        var noteQuantity = 0
        noteQuantity = theNotes.filter({($0[5] as! Int64 == Int64(0) && $0[1] as! String == theFoldersFiltered[indexPath.row][0] as! String) || ($0[5] as! Int64 == Int64(1) && $0[1] as! String == theFoldersFiltered[indexPath.row][0] as! String)}).count
        if theFoldersFiltered[indexPath.row][1] as! String == "mainFolder" {
            let cellMain = tableView.dequeueReusableCell(withIdentifier: "HomeMainTVC", for: indexPath) as! HomePageMainTVCell2
            cellMain.layer.cornerRadius = 0
            cellMain.HomePageMainTitle.text = (theFoldersFiltered[indexPath.row][0] as! String)
            cellMain.HomePageMainNoteCount.text = String(noteQuantity)
            cellMain.HomePageMainExpandButton.tag = indexPath.row
            cellMain.HomePageMainExpandButton.addTarget(self, action: #selector(hideOrShowSubFolders), for: .touchUpInside)
            if indexPath.row + 1 == theFoldersFiltered.count {
                print("At end of list")
                cellMain.HomePageMainExpandButton.isEnabled = false
                cellMain.HomePageMainExpandButton.alpha = 0.3
                cellMain.HomePageMainExpandButton.setTitle("↓", for: .normal)
            } else {
                if theFoldersFiltered[indexPath.row + 1][1] as! String == "mainFolder" {
                    cellMain.HomePageMainExpandButton.isEnabled = false
                    cellMain.HomePageMainExpandButton.alpha = 0.3
                    cellMain.HomePageMainExpandButton.setTitle("↓", for: .normal)
                } else {
                    if theFoldersFiltered[indexPath.row + 1][4] as! Bool == false {
                        cellMain.HomePageMainExpandButton.isEnabled = true
                        cellMain.HomePageMainExpandButton.alpha = 1
                        cellMain.HomePageMainExpandButton.setTitle("↑", for: .normal)
                    } else {
                        cellMain.HomePageMainExpandButton.isEnabled = true
                        cellMain.HomePageMainExpandButton.alpha = 1
                        cellMain.HomePageMainExpandButton.setTitle("↓", for: .normal)
                    }
                }
            }
            cellMain.backgroundColor = (theFoldersFiltered[indexPath.row][2] as! UIColor)
            Cell = cellMain
        } else if theFoldersFiltered[indexPath.row][1] as! String == "subFolder" {
            let cellSub = tableView.dequeueReusableCell(withIdentifier: "HomeSubTVC", for: indexPath) as! HomePageSubFolderTVCell
            let title = (theFoldersFiltered[indexPath.row][0] as! String).components(separatedBy: "/")
            cellSub.HomePageSubFolderNoteCount.text = String(noteQuantity)
            cellSub.HomePageSubFolderTitle.text = title.last!
            if theFoldersFiltered[indexPath.row][4] as! Bool == true {
                cellSub.isHidden = true
            } else {
                cellSub.isHidden = false
            }
            Cell = cellSub
        }
//        if traitCollection.forceTouchCapability == UIForceTouchCapability.available  {
//            self.registerForPreviewing(with: self, sourceView: Cell)
//        }
        return Cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        print(sourceIndexPath.row)
        print(theFoldersFiltered[sourceIndexPath.row])
        if theFoldersFiltered[sourceIndexPath.row][1] as! String == "subFolder" {
            var upperLimit = 0
            var lowerLimit = 0
            for a in sourceIndexPath.row..<theFoldersFiltered.count {
                if a == theFoldersFiltered.count - 1 {
                    upperLimit = theFoldersFiltered.count
                    break
                } else if theFoldersFiltered[a][1] as! String == "mainFolder" {
                    upperLimit = a
                    break
                }
            }
            for b in (0..<upperLimit).reversed() {
                if b == 0 {
                    lowerLimit = 0
                    break
                } else if theFoldersFiltered[b][1] as! String == "mainFolder" {
                    lowerLimit = b
                    break
                }
            }
            var row = 0
            if proposedDestinationIndexPath.row >= upperLimit || proposedDestinationIndexPath.row <= lowerLimit {
                return IndexPath(row: sourceIndexPath.row, section: 0)
            }
        }
        return proposedDestinationIndexPath
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let index = theFolders.firstIndex(where: { $0[0] as! String == self.theFoldersFiltered[sourceIndexPath.row][0] as! String && $0[1] as! String == self.theFoldersFiltered[sourceIndexPath.row][1] as! String && $0[2] as! UIColor == self.theFoldersFiltered[sourceIndexPath.row][2] as! UIColor && $0[3] as! Int64 == self.theFoldersFiltered[sourceIndexPath.row][3] as! Int64 && $0[4] as! Bool == self.theFoldersFiltered[sourceIndexPath.row][4] as! Bool})!
        if rearranging {
            let item = theFolders[index]
            theFolders.remove(at: index)
            theFolders.insert(item, at: destinationIndexPath.row)
            self.theFoldersFiltered.removeAll()
            self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
        } else {
            if sourceIndexPath.row != destinationIndexPath.row {
                array = theFolders
                rearrangeList(destination: destinationIndexPath.row, source: sourceIndexPath.row, initialIndex: index)
                theFolders = array
                
                array = editingArrayCloneOfFoldersArray
                rearrangeList(destination: destinationIndexPath.row, source: sourceIndexPath.row, initialIndex: index)
                editingArrayCloneOfFoldersArray = array
                
                let item = self.theFoldersFiltered[sourceIndexPath.row]
                self.theFoldersFiltered.remove(at: sourceIndexPath.row)
                self.theFoldersFiltered.insert(item, at: destinationIndexPath.row)
            }
        }
    }
    
    var array = [[Any]]()
    func rearrangeList(destination: Int, source: Int, initialIndex: Int) {
        var item = array[initialIndex]
        var subItems = [[[Any]]]()
        if initialIndex + 1 != array.count {
            if array[initialIndex + 1][1] as! String == "subFolder" {
                for a in (initialIndex + 1)..<array.count {
                    if array[a][1] as! String == "subFolder" {
                        print(array[a][0])
                        subItems.append([array[a]])
                    } else {
                        break
                    }
                }
            }
            for a in 0..<subItems.count {
                let index2 = array.firstIndex(where: { $0[0] as! String == subItems[a][0][0] as! String && $0[1] as! String == subItems[a][0][1] as! String && $0[2] as! UIColor == subItems[a][0][2] as! UIColor && $0[3] as! Int64 == subItems[a][0][3] as! Int64 && $0[4] as! Bool == subItems[a][0][4] as! Bool})!
                print(array[index2][0])
                array.remove(at: index2)
            }
        }
        array.remove(at: initialIndex)
        if destination >= theFoldersFiltered.count - 1 {
            array.append(item)
            if subItems.isEmpty != true {
                for a in 0..<subItems.count {
                    array.append(subItems[a][0])
                }
            }
        } else {
            var index2 = array.firstIndex(where: { $0[0] as! String == self.theFoldersFiltered[destination][0] as! String && $0[1] as! String == self.theFoldersFiltered[destination][1] as! String && $0[2] as! UIColor == self.theFoldersFiltered[destination][2] as! UIColor && $0[3] as! Int64 == self.theFoldersFiltered[destination][3] as! Int64 && $0[4] as! Bool == self.theFoldersFiltered[destination][4] as! Bool})!
            print(self.theFoldersFiltered[destination][0])
            print(destination)
            print(index2)
            print(array[index2][0] as! String)
            if destination > source {
                index2 = array.firstIndex(where: { $0[0] as! String == self.theFoldersFiltered[destination + 1][0] as! String && $0[1] as! String == self.theFoldersFiltered[destination + 1][1] as! String && $0[2] as! UIColor == self.theFoldersFiltered[destination + 1][2] as! UIColor && $0[3] as! Int64 == self.theFoldersFiltered[destination + 1][3] as! Int64 && $0[4] as! Bool == self.theFoldersFiltered[destination + 1][4] as! Bool})!
                array.insert(item, at: index2)
            } else {
                array.insert(item, at: index2)
            }
            if subItems.isEmpty != true {
                for a in 0..<subItems.count {
                    let next = index2 + a + 1
                    array.insert(subItems[a][0], at: next)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if theFoldersFiltered[indexPath.row][1] as! String == "subFolder" {
            if theFoldersFiltered[indexPath.row][4] as! Bool == true {
                height = 0
            } else {
                height = 51
            }
        } else {
            height = 100
        }
        return height
    }
    @objc func hideOrShowSubFolders(sender: UIButton!) {
        if theFolders[sender.tag + 1][4] as! Bool == false {
            for a in (sender.tag + 1)..<theFolders.count {
                if theFolders[a][1] as! String == "subFolder" {
                    theFolders[a][4] = true
                } else {
                    break
                }
            }
            sender.setTitle("↑", for: .normal)
            UIView.transition(with: self.HomePageTableView, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                self.HomePageTableView.reloadData()
            }, completion: nil)
        } else {
            for a in (sender.tag + 1)..<theFolders.count {
                if theFolders[a][1] as! String == "subFolder" {
                    theFolders[a][4] = false
                } else {
                    break
                }
            }
            sender.setTitle("↓", for: .normal)
            UIView.transition(with: self.HomePageTableView, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                self.HomePageTableView.reloadData()
            }, completion: nil)
        }
    }
    var insideFolderTitleIndex = 0
    var goingToPreviewIndex = 0
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        global.pow()
        insideFolderTitleIndex = indexPath.row
        goingToPreviewIndex = theFolders.firstIndex(where: { $0[0] as! String == self.theFoldersFiltered[indexPath.row][0] as! String && $0[1] as! String == self.theFoldersFiltered[indexPath.row][1] as! String && $0[2] as! UIColor == self.theFoldersFiltered[indexPath.row][2] as! UIColor && $0[3] as! Int64 == self.theFoldersFiltered[indexPath.row][3] as! Int64 && $0[4] as! Bool == self.theFoldersFiltered[indexPath.row][4] as! Bool})!
        isGoingIntoFolder = true
        performSegue(withIdentifier: "InsideFolderSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let index = theFolders.firstIndex(where: { $0[0] as! String == self.theFoldersFiltered[indexPath.row][0] as! String && $0[1] as! String == self.theFoldersFiltered[indexPath.row][1] as! String && $0[2] as! UIColor == self.theFoldersFiltered[indexPath.row][2] as! UIColor && $0[3] as! Int64 == self.theFoldersFiltered[indexPath.row][3] as! Int64 && $0[4] as! Bool == self.theFoldersFiltered[indexPath.row][4] as! Bool})!
        let subFolder = UIAction(title: "Add Topic", image: UIImage(systemName: "plus")) { action in
            self.global.pow()
            let al = UIAlertController(title: "Add a topic", message: "", preferredStyle: .alert)
            al.addTextField { (textfield) in
                textfield.addTarget(self, action: #selector(self.enablingAddSubviewAlertButton), for: .editingChanged)
                textfield.placeholder = "Title for '\(theFolders[indexPath.row][0] as! String)' subfolder"
            }
            al.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                let title = al.textFields?[0].text
                let actualTitle = String(theFolders[index][0] as! String + "/" + title!)
                if index + 1 == theFolders.count {
                    theFolders.append([actualTitle, "subFolder", UIColor.clear, Int64(1), false])
                } else {
                    if theFolders[index + 1][4] as! Bool == false {
                        theFolders.insert([actualTitle, "subFolder", UIColor.clear, Int64(1), false], at: index + 1)
                    } else  {
                        theFolders.insert([actualTitle, "subFolder", UIColor.clear, Int64(1), true], at: index + 1)
                    }
                }
                DispatchQueue.main.async {
                    self.theFoldersFiltered.removeAll()
                    self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                    tableView.reloadData()
                }
            }))
            al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(al, animated: true, completion: nil)
        }
        var count = 0
        for a in (index + 1)..<theFolders.count {
            if theFolders[a][1] as! String == "mainFolder" {
                break
            } else {
                count += 1
            }
        }
        let deleteMain = UIAction(title: "Trash", image: UIImage(systemName: "trash")) { action in
            let title = String("Delete the '" + (theFolders[index][0] as! String) + "' folder")
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.error)
            }
            let al = UIAlertController(title: title, message: "This will also delete all notes inside this folder and ANY SUBFOLDERS, unless you choose to move them into another folder, which will keep the notes but delete the folder and all subfolders. Do you wish to continue?", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            al.addAction(UIAlertAction(title: "Move", style: .destructive, handler: { (action) in
                self.indexsForTransferingLotsOfNotes[0] = Int(index)
                self.indexsForTransferingLotsOfNotes[1] = Int(count)
                self.indexsForTransferingLotsOfNotes[2] = Bool(true)
                self.isTransferingNotesToNewFolder = true
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "movingNotesInBulk", sender: self)
                }
                self.checkButtonsEnabled()
            }))
            al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                for a in 0..<theNotes.count {
                    if theNotes[a][1] as! String == theFolders[index][0] as! String {
                        theNotes.remove(at: a)
                    }
                    if count != 0 {
                        for b in 1...count {
                            for c in 0..<theNotes.count {
                                if theNotes[c][1] as! String == theFolders[b][0] as! String {
                                    theNotes.remove(at: c)
                                }
                            }
                        }
                    }
                }
                theFolders.remove(at: index)
                if count != 0 {
                    for d in 1...count {
                        theFolders.remove(at: d)
                    }
                }
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                var indexOfRowsToBeRemovedArray = [IndexPath]()
                indexOfRowsToBeRemovedArray.append(IndexPath(row: indexPath.row, section: 0))
                if count != 0 {
                    for e in 1...count {
                        indexOfRowsToBeRemovedArray.append(IndexPath(row: indexPath.row + e, section: 0))
                    }
                }
                tableView.deleteRows(at: indexOfRowsToBeRemovedArray, with: .left)
                self.checkButtonsEnabled()
            }))
            if theNotes.filter({$0[1] as! String == theFolders[index][0] as! String}).count == 0 && theNotes.filter({ ($0[1] as! String).contains(theFolders[index][0] as! String)}).count == 0 {
                var indexs = [IndexPath]()
                if index + 1 == theFolders.count {
                    indexs.append(IndexPath(row: index, section: 0))
                    indexs.append(IndexPath(row: index + 1, section: 0))
                    theFolders.remove(at: index)
                    theFolders.remove(at: index)
                }
                else {
                    indexs.append(IndexPath(row: index, section: 0))
                    for a in index + 1..<theFolders.count {
                        if (theFolders[a][0] as! String).contains(theFolders[index][0] as! String) {
                            indexs.append(IndexPath(row: a, section: 0))
                        }
                    }
                    for _ in 0..<indexs.count {
                        theFolders.remove(at: index)
                    }
                }
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                tableView.deleteRows(at: indexs, with: .left)
            } else {
                self.present(al, animated: true, completion: nil)
            }
        }
        let deleteSub = UIAction(title: "Trash", image: UIImage(systemName: "trash")) { action in
            let title = String("Delete the '" + (theFolders[index][0] as! String) + "' folder")
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.error)
            }
            let al = UIAlertController(title: title, message: "This will also delete all notes inside this folder, unless you choose to move them into another folder, which will keep the notes but delete this folder. Do you wish to continue?", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            al.addAction(UIAlertAction(title: "Move", style: .destructive, handler: { (action) in
                self.indexsForTransferingLotsOfNotes[0] = Int(index)
                self.indexsForTransferingLotsOfNotes[1] = 0
                self.indexsForTransferingLotsOfNotes[2] = Bool(true)
                self.isTransferingNotesToNewFolder = true
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "movingNotesInBulk", sender: self)
                }
                self.checkButtonsEnabled()
            }))
            al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                for a in 0..<theNotes.count {
                    if theNotes[a][1] as! String == theFolders[index][0] as! String {
                        theNotes.remove(at: a)
                    }
                }
                theFolders.remove(at: index)
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
                self.checkButtonsEnabled()
            }))
            if theNotes.filter({$0[1] as! String == theFolders[index][0] as! String}).count == 0 && theNotes.filter({ ($0[1] as! String).contains(theFolders[index][0] as! String)}).count == 0 {
                theFolders.remove(at: index)
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
                self.checkButtonsEnabled()
            } else {
                self.present(al, animated: true, completion: nil)
            }
        }
        let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { action in
            if theFolders[index][1] as! String == "mainFolder" {
                folderEditing = [Int(index), true, theFolders[index][0] as! String]
                isGoingIntoFolder = false
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "mainFolderSeg", sender: self)
                }
            } else {
                let preName = theFolders[index][0] as! String
                let folderName = (theFolders[index][0] as! String).components(separatedBy: "/")
                let al = UIAlertController(title: "Edit this topic", message: "", preferredStyle: .alert)
                al.addTextField { (textfield) in
                    textfield.placeholder = "Title"
                    textfield.text = folderName[1]
                }
                al.addAction(UIAlertAction(title: "Change", style: .default, handler: { (action) in
                    let newFolderName = folderName[0] + "/" + al.textFields![0].text!
                    for a in 0..<theNotes.count {
                        if theNotes[a][1] as! String == preName {
                            theNotes[a][1] = newFolderName
                        }
                    }
                    theFolders[index][0] = newFolderName
                    self.theFoldersFiltered.removeAll()
                    self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }))
                al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(al, animated: true, completion: nil)
            }
        }
        var menu = UIMenu()
        if theFolders[index][1] as! String == "mainFolder" {
            menu = UIMenu(title: "", children: [subFolder, deleteMain, edit])
        } else {
            menu = UIMenu(title: "", children: [deleteSub, edit])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return menu
        })
    }
    
    var isTransferingNotesToNewFolder = false
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isGoingIntoFolder {
            let insideFolderVC = segue.destination as! InsideFolderPage
            insideFolderVC.innerFolderString = theFoldersFiltered[insideFolderTitleIndex][0] as! String
            var subFolders = [String]()
            if (theFoldersFiltered[insideFolderTitleIndex][0] as! String).contains("/") != true {
                for a in 0..<theFolders.count {
                    if (theFolders[a][0] as! String).contains(String((theFoldersFiltered[insideFolderTitleIndex][0] as! String) + "/")) {
                        subFolders.append(theFolders[a][0] as! String)
                    }
                }
            }
            NSLog("\(subFolders.count)")
            insideFolderVC.subFolders = subFolders
            isGoingIntoFolder = false
        } else if isTransferingNotesToNewFolder {
            let movingNotesPage = segue.destination as! MovingNotesPage
            movingNotesPage.transferingFromAnotherFolder = [indexsForTransferingLotsOfNotes[0], indexsForTransferingLotsOfNotes[1], indexsForTransferingLotsOfNotes[2]]
            isTransferingNotesToNewFolder = false
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if theFoldersFiltered[indexPath.row][1] as! String == "subFolder" {
            if theFoldersFiltered[indexPath.row][4] as! Bool == true {
                height = 0
            } else {
                height = 51
            }
        } else {
            height = 100
        }
        return height
    }
    var startEditingRowIndex = 0
    var endEditingRowIndex = 0
    func returnEditingRowindexs(mainFolderIndex: Int, ending: Bool) {
        if ending {
            print("In funtion, ending")
            startEditingRowIndex = mainFolderIndex
            endEditingRowIndex = theFolders.count
        } else {
            print("In function, not at end")
            startEditingRowIndex = mainFolderIndex
            var count = 0
            print(startEditingRowIndex)
            print(theFolders.count)
            for a in startEditingRowIndex..<theFolders.count {
                print("In For Loop")
                print(a)
                if a == startEditingRowIndex {
                    continue
                } else if theFolders[a][1] as! String == "subFolder" {
                    print("Count: \(count)")
                    count += 1
                } else {
                    endEditingRowIndex = count + startEditingRowIndex
                    break
                }
            }
        }
        print("Function Start \(startEditingRowIndex), Function End \(endEditingRowIndex)")
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        var editingStyle = UITableViewCell.EditingStyle.delete
        print("Row \(indexPath.row)")
        if rearranging {
            print("Rearranging")
            print("Start: \(startEditingRowIndex), End: \(endEditingRowIndex)")
            if endEditingRowIndex == theFolders.count {
                print("Ending")
                if indexPath.row > startEditingRowIndex {
                    print("Delete Style")
                    editingStyle = .delete
                } else {
                    print("No Style")
                    editingStyle = .none
                }
            } else {
                print("Not Ending")
                if indexPath.row > startEditingRowIndex && indexPath.row <= endEditingRowIndex {
                    print("Delete Style")
                    editingStyle = .delete
                } else {
                    print("No Style")
                    editingStyle = .none
                }
            }
        } else {
            editingStyle = .delete
        }
        print("\n---\nRow Editing Style \(editingStyle) \n---\n")
        return editingStyle
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var editingTrue = Bool()
        print("Row \(indexPath.row)")
        if rearranging {
            print("Rearranging")
            print("Start: \(startEditingRowIndex), End: \(endEditingRowIndex)")
            if endEditingRowIndex == theFolders.count {
                print("Ending")
                if indexPath.row > startEditingRowIndex {
                    print("Can Edit")
                    editingTrue = true
                } else {
                    print("No Edit")
                    editingTrue = false
                }
            } else {
                print("Not Ending")
                if indexPath.row > startEditingRowIndex && indexPath.row <= endEditingRowIndex {
                    print("Can Edit")
                    editingTrue = true
                } else {
                    print("No Edit")
                    editingTrue = false
                }
            }
        } else {
            editingTrue = true
        }
        print("\n---\nRow Editing Style \(editingTrue) \n---\n")
        return editingTrue
    }
    var booleanRowSaveTemporary = [Bool]()
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = theFolders.firstIndex(where: { $0[0] as! String == self.theFoldersFiltered[indexPath.row][0] as! String && $0[1] as! String == self.theFoldersFiltered[indexPath.row][1] as! String && $0[2] as! UIColor == self.theFoldersFiltered[indexPath.row][2] as! UIColor && $0[3] as! Int64 == self.theFoldersFiltered[indexPath.row][3] as! Int64 && $0[4] as! Bool == self.theFoldersFiltered[indexPath.row][4] as! Bool})!
        let rearrange = UIContextualAction(style: .normal, title: "Rearrange") { (context, view, bool) in
            self.rearranging = true
            self.HomePageEditButton.setTitle("Done", for: .normal)
            print(index)
            for a in (index + 1)..<theFolders.count {
                print(a)
                if theFolders[a][1] as! String == "mainFolder" {
                    print("main")
                    self.returnEditingRowindexs(mainFolderIndex: index, ending: false)
                    break
                } else if a == theFolders.count - 1 && theFolders[a][1] as! String == "subFolder" {
                    print("sub")
                    self.returnEditingRowindexs(mainFolderIndex: index, ending: true)
                    break
                }
            }
            for a in (self.startEditingRowIndex + 1)..<self.endEditingRowIndex {
                self.booleanRowSaveTemporary.append(theFolders[a][4] as! Bool)
                theFolders[a][4] = false
            }
            self.theFoldersFiltered.removeAll()
            self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
            self.HomePageTableView.reloadData()
            self.HomePageTableView.setEditing(true, animated: true)
        }
        let subFolder = UIContextualAction(style: .normal, title: "+ Subfolder") { (content, view, bool) in
            self.global.pow()
            let al = UIAlertController(title: "Add a topic", message: "", preferredStyle: .alert)
            al.addTextField { (textfield) in
                textfield.addTarget(self, action: #selector(self.enablingAddSubviewAlertButton), for: .editingChanged)
                textfield.placeholder = "Title for '\(theFolders[indexPath.row][0] as! String)' subfolder"
            }
            al.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                let title = al.textFields?[0].text
                let actualTitle = String(theFolders[index][0] as! String + "/" + title!)
                if index + 1 == theFolders.count {
                    theFolders.append([actualTitle, "subFolder", UIColor.clear, Int64(1), false])
                } else {
                    if theFolders[index + 1][4] as! Bool == false {
                        theFolders.insert([actualTitle, "subFolder", UIColor.clear, Int64(1), false], at: index + 1)
                    } else  {
                        theFolders.insert([actualTitle, "subFolder", UIColor.clear, Int64(1), true], at: index + 1)
                    }
                }
                bool(true)
                DispatchQueue.main.async {
                    self.theFoldersFiltered.removeAll()
                    self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                    tableView.reloadData()
                }
            }))
            al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                bool(false)
            }))
            self.present(al, animated: true, completion: nil)
        }
        subFolder.backgroundColor = .black
        rearrange.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        subFolder.image = UIImage(systemName: "folder.badge.plus")
        rearrange.image = UIImage(systemName: "tray.full")
        var swipeActions = UISwipeActionsConfiguration()
        if theFoldersFiltered[indexPath.row][1] as! String == "mainFolder" {
            if indexPath.row < (theFoldersFiltered.count - 2) && theFoldersFiltered[indexPath.row + 1][1] as! String == "subFolder" && theFoldersFiltered[indexPath.row + 2][1] as! String == "subFolder" && theFoldersFiltered[indexPath.row + 1][4] as! Bool == false {
                print(theFoldersFiltered[indexPath.row + 1])
                swipeActions = UISwipeActionsConfiguration(actions: [subFolder, rearrange])
            } else {
                swipeActions = UISwipeActionsConfiguration(actions: [subFolder])
            }
        } else {
            
        }
        DispatchQueue.main.async {
            self.HomePageTableView.reloadData()
        }
        return swipeActions
    }
    @objc func enablingAddSubviewAlertButton(_ sender: UITextField) {
        let tempTitle1 = String((sender.placeholder?.dropFirst(11))!)
        let mainTitle = String(tempTitle1.dropLast(11))
        let actualTitle = String(mainTitle + "/" + sender.text!)
        print(actualTitle)
        var resp : UIResponder! = sender
        while !(resp is UIAlertController) { resp = resp.next }
        let al = resp as! UIAlertController
        var already = false
        for a in 0..<theFolders.count {
            if theFolders[a][0] as! String == actualTitle || (theFolders[a][0] as! String).isEmpty {
                already = true
                break
            }
        }
        if sender.text == "" {
            already = true
        }
        if already == true {
            al.actions[0].isEnabled = false
        } else {
            al.actions[0].isEnabled = true
        }
    }
    var indexsForTransferingLotsOfNotes = [0,0,false] as! [Any]
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = theFolders.firstIndex(where: { $0[0] as! String == self.theFoldersFiltered[indexPath.row][0] as! String && $0[1] as! String == self.theFoldersFiltered[indexPath.row][1] as! String && $0[2] as! UIColor == self.theFoldersFiltered[indexPath.row][2] as! UIColor && $0[3] as! Int64 == self.theFoldersFiltered[indexPath.row][3] as! Int64 && $0[4] as! Bool == self.theFoldersFiltered[indexPath.row][4] as! Bool})!
        var count = 0
        for a in (index + 1)..<theFolders.count {
            if theFolders[a][1] as! String == "mainFolder" {
                break
            } else {
                count += 1
            }
        }
        let deleteMain = UIContextualAction(style: .destructive, title: "Delete") { (context, view, bool) in
            let title = String("Delete the '" + (theFolders[index][0] as! String) + "' folder")
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.error)
            }
            let al = UIAlertController(title: title, message: "This will also delete all notes inside this folder and ANY SUBFOLDERS, unless you choose to move them into another folder, which will keep the notes but delete the folder and all subfolders. Do you wish to continue?", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                bool(false)
            }))
            al.addAction(UIAlertAction(title: "Move", style: .destructive, handler: { (action) in
                self.indexsForTransferingLotsOfNotes[0] = Int(index)
                self.indexsForTransferingLotsOfNotes[1] = Int(count)
                self.indexsForTransferingLotsOfNotes[2] = Bool(true)
                self.isTransferingNotesToNewFolder = true
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "movingNotesInBulk", sender: self)
                }
                self.checkButtonsEnabled()
                bool(true)
            }))
            al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                for a in 0..<theNotes.count {
                    if theNotes[a][1] as! String == theFolders[index][0] as! String {
                        theNotes.remove(at: a)
                    }
                    if count != 0 {
                        for b in 1...count {
                            for c in 0..<theNotes.count {
                                if theNotes[c][1] as! String == theFolders[b][0] as! String {
                                    theNotes.remove(at: c)
                                }
                            }
                        }
                    }
                }
                theFolders.remove(at: index)
                if count != 0 {
                    for d in 1...count {
                        theFolders.remove(at: d)
                    }
                }
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                var indexOfRowsToBeRemovedArray = [IndexPath]()
                indexOfRowsToBeRemovedArray.append(IndexPath(row: indexPath.row, section: 0))
                if count != 0 {
                    for e in 1...count {
                        indexOfRowsToBeRemovedArray.append(IndexPath(row: indexPath.row + e, section: 0))
                    }
                }
                tableView.deleteRows(at: indexOfRowsToBeRemovedArray, with: .left)
                bool(true)
                self.checkButtonsEnabled()
            }))
            if theNotes.filter({$0[1] as! String == theFolders[index][0] as! String}).count == 0 && theNotes.filter({ ($0[1] as! String).contains(theFolders[index][0] as! String)}).count == 0 {
                var indexs = [IndexPath]()
                if index + 1 == theFolders.count {
                    indexs.append(IndexPath(row: index, section: 0))
                    indexs.append(IndexPath(row: index + 1, section: 0))
                    theFolders.remove(at: index)
                    theFolders.remove(at: index)
                }
                else {
                    indexs.append(IndexPath(row: index, section: 0))
                    for a in index + 1..<theFolders.count {
                        if (theFolders[a][0] as! String).contains(theFolders[index][0] as! String) {
                            indexs.append(IndexPath(row: a, section: 0))
                        }
                    }
                    for _ in 0..<indexs.count {
                        theFolders.remove(at: index)
                    }
                }
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                tableView.deleteRows(at: indexs, with: .left)
            } else {
                self.present(al, animated: true, completion: nil)
            }
        }
        let deleteSub = UIContextualAction(style: .destructive, title: "Delete") { (context, view, bool) in
            let title = String("Delete the '" + (theFolders[index][0] as! String) + "' folder")
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.error)
            }
            let al = UIAlertController(title: title, message: "This will also delete all notes inside this folder, unless you choose to move them into another folder, which will keep the notes but delete this folder. Do you wish to continue?", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                bool(false)
            }))
            al.addAction(UIAlertAction(title: "Move", style: .destructive, handler: { (action) in
                self.indexsForTransferingLotsOfNotes[0] = Int(index)
                self.indexsForTransferingLotsOfNotes[1] = 0
                self.indexsForTransferingLotsOfNotes[2] = Bool(true)
                self.isTransferingNotesToNewFolder = true
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "movingNotesInBulk", sender: self)
                }
                self.checkButtonsEnabled()
                bool(true)
            }))
            al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                for a in 0..<theNotes.count {
                    if theNotes[a][1] as! String == theFolders[index][0] as! String {
                        theNotes.remove(at: a)
                    }
                }
                theFolders.remove(at: index)
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
                bool(true)
                self.checkButtonsEnabled()
            }))
            if theNotes.filter({$0[1] as! String == theFolders[index][0] as! String}).count == 0 && theNotes.filter({ ($0[1] as! String).contains(theFolders[index][0] as! String)}).count == 0 {
                theFolders.remove(at: index)
                self.theFoldersFiltered.removeAll()
                self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
                bool(true)
                self.checkButtonsEnabled()
            } else {
                self.present(al, animated: true, completion: nil)
            }
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { (context, view, bool) in
            if theFolders[index][1] as! String == "mainFolder" {
                folderEditing = [Int(index), true, theFolders[index][0] as! String]
                isGoingIntoFolder = false
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "mainFolderSeg", sender: self)
                }
            } else {
                let preName = theFolders[index][0] as! String
                let folderName = (theFolders[index][0] as! String).components(separatedBy: "/")
                let al = UIAlertController(title: "Edit this topic", message: "", preferredStyle: .alert)
                al.addTextField { (textfield) in
                    textfield.placeholder = "Title"
                    textfield.text = folderName[1]
                }
                al.addAction(UIAlertAction(title: "Change", style: .default, handler: { (action) in
                    let newFolderName = folderName[0] + "/" + al.textFields![0].text!
                    for a in 0..<theNotes.count {
                        if theNotes[a][1] as! String == preName {
                            theNotes[a][1] = newFolderName
                        }
                    }
                    theFolders[index][0] = newFolderName
                    self.theFoldersFiltered.removeAll()
                    self.searchingFunction(searchText: self.HomePageFolderSearchBar.text!)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }))
                al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(al, animated: true, completion: nil)
            }
        }
        deleteMain.backgroundColor = .red
        deleteMain.image = UIImage(systemName: "trash")
        deleteSub.backgroundColor = .red
        deleteSub.image = UIImage(systemName: "trash")
        edit.backgroundColor = .systemGray2
        edit.image = UIImage(systemName: "pencil")
        var swipeActions = UISwipeActionsConfiguration()
        if theFolders[index][0] as! String == "General" {
            swipeActions = UISwipeActionsConfiguration(actions: [edit])
        } else if theFolders[index][1] as! String == "mainFolder" {
            swipeActions = UISwipeActionsConfiguration(actions: [deleteMain, edit])
        } else {
            swipeActions = UISwipeActionsConfiguration(actions: [deleteSub, edit])
        }
        DispatchQueue.main.async {
            self.HomePageTableView.reloadData()
        }
        return swipeActions
        
    }
    @objc func checkButtonsEnabled(){
        if theFoldersFiltered.isEmpty {
            HomePageEditButton.alpha = 0.4
            HomePageEditButton.backgroundColor = .secondaryLabel
            HomePageEditButton.isEnabled = false
            HomePageSearchButton.isEnabled = false
            HomePageSearchButton.tintColor = .secondaryLabel
            HomePageSearchButton.alpha = 0.4
        } else {
            HomePageEditButton.alpha = 1
            HomePageEditButton.isEnabled = true
            HomePageEditButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
            HomePageSearchButton.isEnabled = true
            HomePageSearchButton.alpha = 1
            HomePageSearchButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        }
    }
    func searchingFunction(searchText: String) {
        if searchText.isEmpty {
            theFoldersFiltered = theFolders
        } else {
            theFoldersFiltered = theFolders.filter({
                ($0[0] as! String).lowercased().contains(searchText.lowercased())
            })
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingFunction(searchText: searchText)
        HomePageTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        global.pow()
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        global.pow()
        searchBar.text = ""
        theFoldersFiltered = theFolders
        HomePageTableView.reloadData()
        searchBar.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.HomePageFolderSearchBar.endEditing(true)
    }
    @IBOutlet weak var HomePageFolderSearchBar: UISearchBar!
    @IBOutlet weak var HomePageAddFolderButtonLabel: UILabel!
    @IBOutlet weak var HomePageAddFolderButton: UIButton!
    @IBAction func HomePageAddFolderButtonAction(_ sender: UIButton) {
        global.pow()
        performSegue(withIdentifier: "mainFolderSeg", sender: self)
    }
    var global = GlobalFunctions()
    
    @objc func reloadHomeTV () {
        theFoldersFiltered.removeAll()
        theFoldersFiltered = theFolders
        HomePageTableView.reloadData()
        checkButtonsEnabled()
    }
    
    @objc func reloadHomeTVWithSearch () {
        theFoldersFiltered.removeAll()
        searchingFunction(searchText: HomePageFolderSearchBar.text!)
        HomePageTableView.reloadData()
        checkButtonsEnabled()
    }
    
    @IBOutlet weak var HomePageTableView: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if HomePageEditButton.titleLabel!.text == "Done" {
            HomePageEditButton.setTitle("Edit", for: .normal)
            HomePageTableView.setEditing(false, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let size = UILabel.appearance().font.pointSize
//        Float(UILabel.appearance().font.pointSize) += Float(settingsPreferances[4][0] as! String)!
        HomePageTableView.contentOffset = CGPoint(x: 0, y: 56)
        HomePageFolderSearchBar.text = ""
        HomePageFolderSearchBar.delegate = self
        HomePageTableView.delegate = self
        HomePageTableView.dataSource = self
        HomePageTableView.rowHeight = UITableView.automaticDimension
        HomePageTableView.estimatedRowHeight = 100
        HomePageTableView.showsVerticalScrollIndicator = false
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHomeTV), name: NSNotification.Name(rawValue: "reloadHomeTV"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHomeTVWithSearch), name: NSNotification.Name(rawValue: "reloadHomeTVWithSearch"), object: nil)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        NotificationCenter.default.addObserver(self, selector: #selector(accentColorChangeHome), name: NSNotification.Name(rawValue: "changeHomeButtonColours"), object: nil)
        HomePageEditButton.layer.cornerRadius = 16
        HomePageEditButton.setTitleColor(.systemBackground, for: .normal)
        theFoldersFiltered.removeAll()
        theFoldersFiltered = theFolders
        accentColorChangeHome()
        checkButtonsEnabled()
        addchildren()
        // Do any additional setup after loading the view.
    }
    
    @objc func accentColorChangeHome () {
        UINavigationBar.appearance().tintColor = (settingsPreferances[1][1] as! UIColor)
        HomePageAddFolderButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        HomePageAddFolderButtonLabel.textColor = (settingsPreferances[1][1] as! UIColor)
        HomePageSearchButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        HomePageSearchButtonLabel.textColor = (settingsPreferances[1][1] as! UIColor)
        HomePageEditButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        HomePageMenuButton4.tintColor = (settingsPreferances[1][1] as! UIColor)
        self.navigationController?.navigationBar.tintColor = (settingsPreferances[1][1] as! UIColor)
    }
    func addchildren() {
        addChild(struggling)
        addChild(trash)
        view.addSubview(struggling.view)
        view.addSubview(trash.view)
        struggling.view.frame = view.bounds
        trash.view.frame = view.bounds
        struggling.didMove(toParent: self)
        trash.didMove(toParent: self)
        struggling.view.isHidden = true
        trash.view.isHidden = true
        struggling.view.layer.zPosition = 0
        trash.view.layer.zPosition = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(theFolders)
        HomePageTableView.reloadData()
        if fromWidget == true {
            isGoingIntoFolder = true
            performSegue(withIdentifier: "InsideFolderSegue", sender: self)
        }
    }

}
extension HomePage: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
