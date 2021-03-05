//
//  ViewController.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
import VisionKit
var theNotes = [[Any]]()
var ind = 0
var previouslyDimissed = false

class AllNotesPage: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VNDocumentCameraViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    var editingIndex = 0
    
    
    struct folder {
        var folderTitle = String()
        var folderContent = [[Any]]()
    }
    
    @IBAction func AllNotesTrashButtonAction(_ sender: UIButton) {
        for a in 0..<AllNotesTableView.indexPathsForSelectedRows!.count {
            global.pow()
            let section = self.AllNotesTableView.indexPathsForSelectedRows![a].section
            let row = self.AllNotesTableView.indexPathsForSelectedRows![a].row
            var pages = Int64()
            if self.folderContentArray[self.AllNotesTableView.indexPathsForSelectedRows![a].section].folderContent[a][5] as! Int64 == 0 {
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == self.folderContentArray[section].folderContent[row][0] as! String && $0[1] as! String == self.folderContentArray[section].folderContent[row][1] as! String && $0[2] as! String == self.folderContentArray[section].folderContent[row][2] as! String && $0[3] as! String == self.folderContentArray[section].folderContent[row][3] as! String && $0[4] as! Bool == self.folderContentArray[section].folderContent[row][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[indexx], [noteDate!]])
                theNotes.remove(at: indexx)
            } else {
                pages = self.folderContentArray[section].folderContent[row][5] as! Int64
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == self.folderContentArray[section].folderContent[row][0] as! String && $0[1] as! String == self.folderContentArray[section].folderContent[row][1] as! String && $0[2] as! String == self.folderContentArray[section].folderContent[row][2] as! String && $0[3] as! String == self.folderContentArray[section].folderContent[row][3] as! String && $0[4] as! Bool == self.folderContentArray[section].folderContent[row][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[indexx], [noteDate!]])
                theNotes.remove(at: indexx)
                for b in 2...pages {
                    let indexxAgain = theNotes.firstIndex(where: {$0[0] as! String == self.folderContentArray[self.AllNotesTableView.indexPathsForSelectedRows![a].section].folderContent[a][0] as! String && $0[1] as! String == self.folderContentArray[self.AllNotesTableView.indexPathsForSelectedRows![a].section].folderContent[a][1] as! String && $0[2] as! String == self.folderContentArray[self.AllNotesTableView.indexPathsForSelectedRows![a].section].folderContent[a][2] as! String && $0[3] as! String == self.folderContentArray[self.AllNotesTableView.indexPathsForSelectedRows![a].section].folderContent[a][3] as! String && $0[4] as! Bool == self.folderContentArray[self.AllNotesTableView.indexPathsForSelectedRows![a].section].folderContent[a][4] as! Bool && $0[5] as! Int64 == Int64(b)})!
                    temporarilyDeleted.append([theNotes[indexxAgain], [noteDate!]])
                    theNotes.remove(at: indexx)
                }
            }
            arrayOrdering()
            if (AllNoteSearchBar.text?.isEmpty != true) {
                searchTextArrayOrdering(searchText: AllNoteSearchBar.text!)
            }
            creatingArrays()
        }
        AllNotesEditingButton2.setTitle("Edit", for: .normal)
        UIView.animate(withDuration: 0.3, animations: {
            self.AllNotesTrashButton.bounds = CGRect(x: 202, y: 832, width: 0, height: 42)
        }) { (success) in
            self.AllNotesTrashButton.isEnabled = false
        }
        editingIndex += 1
        AllNotesTableView.deleteRows(at: AllNotesTableView.indexPathsForSelectedRows!, with: .fade)
        AllNotesTableView.setEditing(false, animated: true)
    }
    @IBOutlet weak var AllNotesTrashButton: UIButton!
    @IBOutlet weak var AllNotesEditingButton2: UIButton!
    @IBAction func AllNotesEditingButtonAction2(_ sender: UIButton) {
        global.pow()
        if editingIndex % 2 == 0 {
            AllNotesTrashButton.isEnabled = false
            AllNotesTrashButton.backgroundColor = .secondaryLabel
            AllNotesTrashButton.alpha = 0.4
            AllNotesEditingButton2.setTitle("Done", for: .normal)
            AllNotesTableView.setEditing(true, animated: true)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.AllNotesTrashButton.bounds = CGRect(x: 161, y: 832, width: 92, height: 42)
            }, completion: nil)
            editingIndex += 1
        } else {
            AllNotesTableView.setEditing(false, animated: true)
            AllNotesEditingButton2.setTitle("Edit", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.AllNotesTrashButton.bounds = CGRect(x: 202, y: 832, width: 0, height: 42)
            }) { (success) in
                self.AllNotesTrashButton.isEnabled = false
            }
            editingIndex += 1
        }
        
    }
    
    
    var transition = SlidingMenuTransition()
    @objc func closeViewAll() {
        print("TRYINGs")
        self.dismiss(animated: false, completion: nil)
    }
    
    var allNotes = [[Any]]()
    var allNotesFiltered = [[Any]]()
    var folderContentArray = [folder]()
    
    @IBOutlet weak var AllNoteSearchBar: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextArrayOrdering(searchText: searchText)
        AllNotesTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if folderContentArray.isEmpty {
            tableView.setEmptyConditions(title: "You have no notes :(", message: "Try adding one with the add button in the top left hand corner", width: tableView.bounds.width, height: tableView.bounds.height, center: tableView.center, iconImageTitle: "plus.app.fill")
        } else {
            tableView.restoreFromEmpty()
        }
        return folderContentArray.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if folderContentArray[section].folderTitle.contains("/") {
            let information = folderContentArray[section].folderTitle.split(separator: "/")
            let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Futura", size: 15), NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel]
            let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Futura", size: 15), NSAttributedString.Key.foregroundColor : UIColor.label]
            let attributedString1 = NSMutableAttributedString(string: String("  " + information[0] + "/"), attributes: attrs1 as [NSAttributedString.Key : Any])
            let attributedString2 = NSMutableAttributedString(string: String(information[1]) , attributes:attrs2)
            attributedString1.append(attributedString2)
            label.attributedText = attributedString1
        } else {
            label.text = String("  " + folderContentArray[section].folderTitle)
            label.textColor = .label
            label.font = UIFont(name: "Futura", size: 15)
        }
        label.textAlignment = .left
        label.backgroundColor = .secondarySystemBackground
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderContentArray[section].folderContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellNote = tableView.dequeueReusableCell(withIdentifier: "AllNotesTVC", for: indexPath) as! AllNotesTVCell
        cellNote.AllNotesTVCTitle.text = (folderContentArray[indexPath.section].folderContent[indexPath.row][0] as! String)
        cellNote.AllNotesTVCTags.text = "🗂" +  String(folderContentArray[indexPath.section].folderContent[indexPath.row][1] as! String)
        if folderContentArray[indexPath.section].folderContent[indexPath.row][4] as! Bool == true {
            let image = global.convertBase64StringToImage(imageBase64String: folderContentArray[indexPath.section].folderContent[indexPath.row][2] as! String)
            cellNote.AllNotesTVCTextContent.isHidden = true
            cellNote.AllNotesTVCImageView.isHidden = false
            cellNote.AllNotesTVCImageView.image = image
        } else {
            cellNote.AllNotesTVCTextContent.isHidden = false
            cellNote.AllNotesTVCImageView.isHidden = true
            cellNote.AllNotesTVCTextContent.text = String(folderContentArray[indexPath.section].folderContent[indexPath.row][2] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        cellNote.AllNotesTVCPageNumber.layer.masksToBounds = true
        if folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64 == 0 {
            cellNote.AllNotesTVCPageNumber.isHidden = true
            cellNote.AllNotesTVCPageNumber.text = ""
        } else if folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64 > 0 {
            cellNote.AllNotesTVCPageNumber.isHidden = false
            cellNote.AllNotesTVCPageNumber.layer.cornerRadius = 9
            cellNote.AllNotesTVCPageNumber.text = String(folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64)
        }
        var rating = folderContentArray[indexPath.section].folderContent[indexPath.row][3] as! String
        if (folderContentArray[indexPath.section].folderContent[indexPath.row][3] as! String).contains("/") {
            rating = (folderContentArray[indexPath.section].folderContent[indexPath.row][3] as! String).components(separatedBy: "/")[0]
        }
        if rating == "unrated" {
            cellNote.AllNotesTVCDifficultyImageView.image = UIImage(systemName: "0.circle.fill")
        } else if rating == "green" {
            cellNote.AllNotesTVCDifficultyImageView.image = UIImage(systemName: "1.circle.fill")
        } else if rating == "orange" {
            cellNote.AllNotesTVCDifficultyImageView.image = UIImage(systemName: "2.circle.fill")
        } else if rating == "red" {
            cellNote.AllNotesTVCDifficultyImageView.image = UIImage(systemName: "3.circle.fill")
        }
        return cellNote
    }
//    func animateTableView() {
//        AllNotesTableView.reloadData()
//        let cells = AllNotesTableView.visibleCells
//        let tvHeight = AllNotesTableView.bounds.size.height
//        for cell in cells {
//            cell.transform = CGAffineTransform(translationX: 0, y: tvHeight)
//        }
//        var delay = 0
//        for cell in cells {
//            UIView.animate(withDuration: 0.8, delay: Double(delay) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform.identity
//            }, completion: nil)
//            delay += 1
//        }
//    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if tableView.indexPathForSelectedRow == nil {
                AllNotesTrashButton.isEnabled = false
                AllNotesTrashButton.backgroundColor = .secondaryLabel
                AllNotesTrashButton.alpha = 0.4
                AllNotesTrashButton.setTitle("Trash", for: .normal)
            } else if tableView.indexPathsForSelectedRows!.count >= 1 {
                AllNotesTrashButton.isEnabled = true
                AllNotesTrashButton.backgroundColor = .red
                AllNotesTrashButton.alpha = 1
                let title = "Trash " + String(tableView.indexPathsForSelectedRows!.count)
                AllNotesTrashButton.setTitle(title, for: .normal)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if tableView.indexPathForSelectedRow == nil  {
                AllNotesTrashButton.isEnabled = false
                AllNotesTrashButton.backgroundColor = .secondaryLabel
                AllNotesTrashButton.alpha = 0.4
                AllNotesTrashButton.setTitle("Trash", for: .normal)
            } else if tableView.indexPathsForSelectedRows!.count >= 1 {
                AllNotesTrashButton.isEnabled = true
                AllNotesTrashButton.backgroundColor = .red
                AllNotesTrashButton.alpha = 1
                let title = "Trash " + String(tableView.indexPathsForSelectedRows!.count)
                AllNotesTrashButton.setTitle(title, for: .normal)
            }
        } else {
            global.pow()
            if folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64 == 0 {
                
            } else {
                folderContentArray[indexPath.section].folderContent[indexPath.row][5] = Int64(1)
            }
            ind = theNotes.firstIndex(where: {$0[0] as! String == folderContentArray[indexPath.section].folderContent[indexPath.row][0] as! String && $0[1] as! String == folderContentArray[indexPath.section].folderContent[indexPath.row][1] as! String && $0[2] as! String == folderContentArray[indexPath.section].folderContent[indexPath.row][2] as! String && $0[3] as! String == folderContentArray[indexPath.section].folderContent[indexPath.row][3] as! String && $0[4] as! Bool == folderContentArray[indexPath.section].folderContent[indexPath.row][4] as! Bool && $0[5] as! Int64 == folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64})!
            if theNotes[ind][4] as! Bool == true {
                performSegue(withIdentifier: "ImgSegue", sender: self)
            } else {
                performSegue(withIdentifier: "TxtSegue", sender: self)
            }
            tableView.deselectRow(at: IndexPath(row: indexPath.row, section: 0), animated: true)
            arrayOrdering()
            if (AllNoteSearchBar.text?.isEmpty != true) {
                searchTextArrayOrdering(searchText: AllNoteSearchBar.text!)
            }
            creatingArrays()
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteNote = UIContextualAction(style: .destructive, title: "Delete") { (context, view, boolValue) in
            var pages = Int64()
            if self.folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64 == 0 {
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][0] as! String && $0[1] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][1] as! String && $0[2] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][2] as! String && $0[3] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][3] as! String && $0[4] as! Bool == self.folderContentArray[indexPath.section].folderContent[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[indexx], [noteDate!]])
                theNotes.remove(at: indexx)
            } else {
                pages = self.folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][0] as! String && $0[1] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][1] as! String && $0[2] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][2] as! String && $0[3] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][3] as! String && $0[4] as! Bool == self.folderContentArray[indexPath.section].folderContent[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[indexx], [noteDate!]])
                theNotes.remove(at: indexx)
                for a in 2...pages {
                    let indexxAgain = theNotes.firstIndex(where: {$0[0] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][0] as! String && $0[1] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][1] as! String && $0[2] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][2] as! String && $0[3] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][3] as! String && $0[4] as! Bool == self.folderContentArray[indexPath.section].folderContent[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(a)})!
                    temporarilyDeleted.append([theNotes[indexxAgain], [noteDate!]])
                    theNotes.remove(at: indexx)
                }
            }
            self.arrayOrdering()
            if (self.AllNoteSearchBar.text?.isEmpty != true) {
                self.searchTextArrayOrdering(searchText: self.AllNoteSearchBar.text!)
            }
            self.creatingArrays()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteNote.backgroundColor = .red
        deleteNote.image = UIImage(systemName: "trash")
        var swipeActions = UISwipeActionsConfiguration()
        swipeActions = UISwipeActionsConfiguration(actions: [deleteNote])
        return swipeActions
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let move = UIContextualAction(style: .normal, title: "Move") { (context, view, boolValue) in
            self.global.pow()
            if self.folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64 == 0 {
                
            } else {
                self.folderContentArray[indexPath.section].folderContent[indexPath.row][5] = Int64(1)
            }
            ind = theNotes.firstIndex(where: {$0[0] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][0] as! String && $0[1] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][1] as! String && $0[2] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][2] as! String && $0[3] as! String == self.folderContentArray[indexPath.section].folderContent[indexPath.row][3] as! String && $0[4] as! Bool == self.folderContentArray[indexPath.section].folderContent[indexPath.row][4] as! Bool && $0[5] as! Int64 == self.folderContentArray[indexPath.section].folderContent[indexPath.row][5] as! Int64})!
            DispatchQueue.main.async {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FolderChoice") as! MovingNotesPage
                vc.modalPresentationStyle = .automatic
                self.present(vc, animated: true, completion: nil)
            }
        }
        move.backgroundColor = .secondaryLabel
        move.image = UIImage(systemName: "tray.full")
        let swipeActions = UISwipeActionsConfiguration(actions: [move])
        return swipeActions
    }
    
    func sorting() {
        arrayOrdering()
        searchTextArrayOrdering(searchText: AllNoteSearchBar.text!)
        creatingArrays()
    }
    
    func checkIfButtonsActive() {
        if theNotes.isEmpty {
            AllNotesEditingButton2.alpha = 0.4
            AllNotesEditingButton2.isEnabled = false
            AllNotesEditingButton2.backgroundColor = .secondaryLabel
            AllNotesSortButton.alpha = 0.4
            AllNotesSortButton.isEnabled = false
            AllNotesSortButton.backgroundColor = .secondaryLabel
        } else {
            AllNotesEditingButton2.alpha = 1
            AllNotesEditingButton2.isEnabled = true
            AllNotesEditingButton2.backgroundColor = (settingsPreferances[1][1] as! UIColor)
            AllNotesSortButton.alpha = 1
            AllNotesSortButton.isEnabled = true
            AllNotesSortButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        }
    }
    
    @IBOutlet weak var AllNotesSortButton: UIButton!
    @IBAction func AllNotesSortButtonAction(_ sender: UIButton) {
        if AllNotesTableView.isEditing {
            AllNotesTableView.setEditing(false, animated: true)
            AllNotesEditingButton2.setTitle("Edit", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.AllNotesTrashButton.bounds = CGRect(x: 202, y: 832, width: 0, height: 42)
            }) { (success) in
                self.AllNotesTrashButton.isEnabled = false
            }
            editingIndex += 1
        }
        global.pow()
        let al = UIAlertController(title: "Sort By?..", message: "", preferredStyle: .actionSheet)
        al.addAction(UIAlertAction(title: "By Title (A-Z)", style: .default, handler: { (action) in
            theNotes.sort {(($0[0] as! String).compare($1[0] as! String)) == .orderedAscending }
            self.sorting()
            self.AllNotesTableView.reloadData()
        }))
        al.addAction(UIAlertAction(title: "By Title (Z-A)", style: .default, handler: { (action) in
            theNotes.sort {(($0[0] as! String).compare($1[0] as! String)) == .orderedDescending }
            self.sorting()
            self.AllNotesTableView.reloadData()
        }))
        al.addAction(UIAlertAction(title: "By Folder (A-Z)", style: .default, handler: { (action) in
            theNotes.sort {(($0[1] as! String).compare($1[1] as! String)) == .orderedAscending }
            self.sorting()
            self.AllNotesTableView.reloadData()
        }))
        al.addAction(UIAlertAction(title: "By Folder (Z-A)", style: .default, handler: { (action) in
            theNotes.sort {(($0[1] as! String).compare($1[1] as! String)) == .orderedDescending }
            self.sorting()
            self.AllNotesTableView.reloadData()
        }))
        al.addAction(UIAlertAction(title: "By Type (Text-Image)", style: .default, handler: { (action) in
            theNotes.sort {((String($0[4] as! Bool)).compare(String($1[4] as! Bool))) == .orderedAscending }
            self.sorting()
            self.AllNotesTableView.reloadData()
        }))
        al.addAction(UIAlertAction(title: "By Type (Image-Text)", style: .default, handler: { (action) in
            theNotes.sort {((String($0[4] as! Bool)).compare(String($1[4] as! Bool))) == .orderedDescending }
            self.sorting()
            self.AllNotesTableView.reloadData()
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(al, animated: true, completion: nil)
    }
    @IBOutlet weak var AllNotesTableView: UITableView!
    var global = GlobalFunctions()

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Did Disappear")
        if AllNotesTableView.isEditing {
            AllNotesTableView.setEditing(false, animated: true)
            AllNotesEditingButton2.setTitle("Edit", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.AllNotesTrashButton.bounds = CGRect(x: 202, y: 832, width: 0, height: 42)
            }) { (success) in
                self.AllNotesTrashButton.isEnabled = false
            }
            editingIndex += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Will Appear")
        self.navigationController?.navigationBar.isHidden = true
        arrayOrdering()
        checkIfButtonsActive()
        creatingArrays()
        AllNotesTableView.reloadData()
            // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Did Appear")
        changeAllNotesButtonColours()
        checkIfButtonsActive()
    }
    @objc func changeAllNotesButtonColours () {
        AllNotesEditingButton2.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        AllNotesSortButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.AllNoteSearchBar.searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.AllNoteSearchBar.searchTextField.endEditing(true)
        return false
    }
    @objc func reloadAllNotesTV () {
        print("Reloading...")
        arrayOrdering()
        if (AllNoteSearchBar.text?.isEmpty != true) {
            searchTextArrayOrdering(searchText: AllNoteSearchBar.text!)
        }
        creatingArrays()
        self.AllNotesTableView.reloadData()
    }
    @objc func longPressEdit(_ gesture: UILongPressGestureRecognizer) {
        if editingIndex % 2 == 0 {
            global.pow()
            AllNotesTrashButton.isEnabled = true
            AllNotesTrashButton.backgroundColor = .secondaryLabel
            AllNotesTrashButton.alpha = 0.4
            AllNotesEditingButton2.setTitle("Done", for: .normal)
            AllNotesTableView.setEditing(true, animated: true)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.AllNotesTrashButton.bounds = CGRect(x: 161, y: 832, width: 92, height: 42)
            }, completion: nil)
            editingIndex += 1
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("Will Layout Subviews")
        AllNotesTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AllNotesTableView.estimatedRowHeight = 65
        AllNotesTableView.rowHeight = 65
        AllNotesTableView.allowsMultipleSelectionDuringEditing = true
        AllNotesTableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressEdit)))
        AllNotesTableView.delegate = self
        AllNotesTableView.dataSource = self
        AllNoteSearchBar.delegate = self
        AllNoteSearchBar.searchTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(changeAllNotesButtonColours), name: NSNotification.Name(rawValue: "changeSearchButtonColours"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAllNotesTV), name: NSNotification.Name(rawValue: "reloadAllNotesTV"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeViewAll), name: NSNotification.Name(rawValue: "closeAll"), object: nil)
        arrayOrdering()
        creatingArrays()
        AllNotesTableView.reloadData()
        print("tah dah")
        AllNotesTableView.layer.zPosition = 5
        self.view.bringSubviewToFront(AllNotesSortButton)
        AllNotesSortButton.layer.cornerRadius = 16
        AllNotesEditingButton2.layer.cornerRadius = 16
        AllNotesTrashButton.layer.cornerRadius = 16
        AllNotesSortButton.setTitleColor(.systemBackground, for: .normal)
        AllNotesEditingButton2.setTitleColor(.systemBackground, for: .normal)
        // Do any additional setup after loading the view.
    }
    func arrayOrdering() {
        allNotes.removeAll()
        allNotes = global.DataFetch(arrayIn: allNotes, arrayWhole: theNotes)
        allNotesFiltered.removeAll()
        allNotesFiltered = allNotes
    }
    func searchTextArrayOrdering(searchText: String) {
        if searchText.isEmpty {
            allNotesFiltered = allNotes
        } else {
            allNotesFiltered = allNotes.filter {
                var boolean = false
                if $0[4] as! Bool == false {
                    boolean = ($0[0] as! String).lowercased().contains(searchText.lowercased()) || ($0[2] as! String).lowercased().contains(searchText.lowercased())
                } else {
                    boolean = ($0[0] as! String).lowercased().contains(searchText.lowercased())
                }
                return boolean
            }
        }
        self.creatingArrays()
    }
    func creatingArrays() {
        folderContentArray.removeAll()
        var temporaryArray = [[Any]]()
        for a in 0..<theFolders.count {
            for b in 0..<allNotesFiltered.count {
                if theFolders[a][0] as! String == allNotesFiltered[b][1] as! String {
                    temporaryArray.append(allNotesFiltered[b])
                }
            }
            if temporaryArray.isEmpty {
                
            } else {
                folderContentArray.append(folder(folderTitle: (theFolders[a][0] as! String), folderContent: temporaryArray))
                temporaryArray.removeAll()
            }
        }
    }
}
extension UITableView {
    func setEmptyConditions(title: String, message: String, width: CGFloat, height: CGFloat, center: CGPoint, iconImageTitle: String) {
        let emptyView = UIView(frame: CGRect(x: center.x, y: center.y, width: width, height: height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        let icon = UIImageView()
        var iconHeight = CGFloat()
        if iconImageTitle.isEmpty {
            icon.image = UIImage()
        } else {
            icon.image = UIImage(systemName: iconImageTitle, withConfiguration: UIImage.SymbolConfiguration(pointSize: 80))
            icon.tintColor = .label
        }
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont(name: "Futura", size: 20)
        titleLabel.textAlignment = .center
        messageLabel.textColor = UIColor.secondaryLabel
        messageLabel.font = UIFont(name: "Futura", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(icon)
        iconHeight = icon.image!.size.height
        icon.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        icon.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        icon.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -40).isActive = true
        icon.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restoreFromEmpty() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
extension AllNotesPage: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
}
