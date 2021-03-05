//
//  TrashPage.swift
//  School Binder
//
//  Created by Joshua Laurence on 01/08/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
var temporarilyDeleted = [[[Any]]]()
class TrashPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var editingIndex = 0
    @IBOutlet weak var TrashPageDeleteButton: UIButton!
    @IBAction func TrashPageDeleteButtonAction(_ sender: UIButton) {
        if settingsPreferances[3][0] as! String == "on" {
            let pow = UINotificationFeedbackGenerator()
            pow.notificationOccurred(.warning)
        }
        let title = "Delete " + String(TrashPageTableView.indexPathsForSelectedRows!.count)
        var message = String()
        if TrashPageTableView.indexPathsForSelectedRows!.count == 1 {
            message = "Are you sure you wish to perminantley delete this note? This action can not be reversed"
        } else {
            message = "Are you sure you wish to perminantley delete these notes? This action can not be reversed"
        }
        let al = UIAlertController(title: title, message: message, preferredStyle: .alert)
        al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            for a in 0..<self.TrashPageTableView.indexPathsForSelectedRows!.count {
                var pages = Int64()
                if self.temporarilyDeletedFormatted[a][5] as! Int64 == 0 {
                    let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[a][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[a][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[a][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[a][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[a][4] as! Bool && $0[0][5] as! Int64 == Int64(0)})!
                    temporarilyDeleted.remove(at: indexx)
                } else {
                    pages = self.temporarilyDeletedFormatted[a][5] as! Int64
                    let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[a][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[a][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[a][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[a][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[a][4] as! Bool && $0[0][5] as! Int64 == Int64(1)})!
                    temporarilyDeleted.remove(at: indexx)
                    for b in 2...pages {
                        let indexxAgain = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[a][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[a][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[a][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[a][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[a][4] as! Bool && $0[0][5] as! Int64 == Int64(b)})!
                        temporarilyDeleted.remove(at: indexxAgain)
                    }
                }
            }
            var tempArray = [[Any]]()
            for a in 0..<temporarilyDeleted.count {
                print(a)
                tempArray.append(temporarilyDeleted[a][0])
            }
            self.temporarilyDeletedFormatted.removeAll()
            self.temporarilyDeletedFormatted = self.global.DataFetch(arrayIn: self.temporarilyDeletedFormatted, arrayWhole: tempArray)
            self.TrashPageTableView.deleteRows(at: self.TrashPageTableView.indexPathsForSelectedRows!, with: .fade)
            self.TrashPageTableView.setEditing(false, animated: true)
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(al, animated: true, completion: nil)
    }
    @IBAction func TrashPageRecoverEditButtonAction(_ sender: UIButton) {
        if settingsPreferances[3][0] as! String == "on" {
            let pow = UINotificationFeedbackGenerator()
            pow.notificationOccurred(.warning)
        }
        let title = "Recover " + String(TrashPageTableView.indexPathsForSelectedRows!.count)
        var message = String()
        if TrashPageTableView.indexPathsForSelectedRows!.count == 1 {
            message = "Do you wish to recover this note?"
        } else {
            message = "Do you wish to recover these notes?"
        }
        let al = UIAlertController(title: title, message: message, preferredStyle: .alert)
        al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            for a in 0..<self.TrashPageTableView.indexPathsForSelectedRows!.count {
                var pages = Int64()
                if self.temporarilyDeletedFormatted[a][5] as! Int64 == 0 {
                    let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[a][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[a][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[a][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[a][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[a][4] as! Bool && $0[0][5] as! Int64 == Int64(0)})!
                    theNotes.append(temporarilyDeleted[indexx][0])
                    temporarilyDeleted.remove(at: indexx)
                } else {
                    pages = self.temporarilyDeletedFormatted[a][5] as! Int64
                    let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[a][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[a][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[a][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[a][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[a][4] as! Bool && $0[0][5] as! Int64 == Int64(1)})!
                    theNotes.append(temporarilyDeleted[indexx][0])
                    temporarilyDeleted.remove(at: indexx)
                    for b in 2...pages {
                        let indexxAgain = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[a][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[a][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[a][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[a][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[a][4] as! Bool && $0[0][5] as! Int64 == Int64(b)})!
                        theNotes.append(temporarilyDeleted[indexx][0])
                        temporarilyDeleted.remove(at: indexxAgain)
                    }
                }
            }
            var tempArray = [[Any]]()
            for a in 0..<temporarilyDeleted.count {
                print(a)
                tempArray.append(temporarilyDeleted[a][0])
            }
            self.temporarilyDeletedFormatted.removeAll()
            self.temporarilyDeletedFormatted = self.global.DataFetch(arrayIn: self.temporarilyDeletedFormatted, arrayWhole: tempArray)
            self.TrashPageTableView.deleteRows(at: self.TrashPageTableView.indexPathsForSelectedRows!, with: .fade)
            self.TrashPageTableView.setEditing(false, animated: true)
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(al, animated: true, completion: nil)
    }
    @IBOutlet weak var TrashPageRecoverEditButton: UIButton!
    @IBOutlet weak var TrashPageEmptyTrashLabel: UILabel!
    @IBOutlet weak var TrashPageEditButton: UIButton!
    @IBAction func TrashPageEditButtonAction(_ sender: UIButton) {
        global.pow()
        if editingIndex % 2 == 0 {
            TrashPageDeleteButton.alpha = 0.4
            TrashPageDeleteButton.backgroundColor = .secondaryLabel
            TrashPageDeleteButton.isEnabled = false
            TrashPageRecoverEditButton.alpha = 0.4
            TrashPageRecoverEditButton.backgroundColor = .secondaryLabel
            TrashPageRecoverEditButton.isEnabled = false
            TrashPageEditButton.setTitle("Done", for: .normal)
            TrashPageTableView.setEditing(true, animated: true)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.TrashPageDeleteButton.bounds = CGRect(x: 20, y: 833, width: 124, height: 42)
            }, completion: nil)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.TrashPageRecoverEditButton.bounds = CGRect(x: 270, y: 833, width: 124, height: 42)
            }, completion: nil)
            editingIndex += 1
        } else {
            TrashPageTableView.setEditing(false, animated: true)
            TrashPageEditButton.setTitle("Edit", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.TrashPageDeleteButton.bounds = CGRect(x: 82, y: 833, width: 0, height: 42)
            }) { (success) in
                self.TrashPageDeleteButton.isEnabled = false
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.TrashPageRecoverEditButton.bounds = CGRect(x: 332, y: 833, width: 0, height: 42)
            }) { (success) in
                self.TrashPageRecoverEditButton.isEnabled = false
            }
            editingIndex += 1
        }
    }
    
    var temporarilyDeletedFormatted = [[Any]]()
    var global = GlobalFunctions()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if temporarilyDeletedFormatted.count == 0 {
            tableView.setEmptyConditions(title: "You have no notes in the trash", message: "Notes here will be here for 7 days before being perminantley deleted", width: tableView.frame.width, height: tableView.frame.height, center: tableView.center, iconImageTitle: "trash")
        } else {
            tableView.restoreFromEmpty()
        }
        return temporarilyDeletedFormatted.count
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (context, view, bool) in
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.warning)
            }
            let al = UIAlertController(title: "Delete", message: "Are you sure you wish to perminantley delete this note? This action can not be reversed", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                var pages = Int64()
                if self.temporarilyDeletedFormatted[indexPath.row][5] as! Int64 == 0 {
                    let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[indexPath.row][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[indexPath.row][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[indexPath.row][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[indexPath.row][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[indexPath.row][4] as! Bool && $0[0][5] as! Int64 == Int64(0)})!
                    temporarilyDeleted.remove(at: indexx)
                } else {
                    pages = self.temporarilyDeletedFormatted[indexPath.row][5] as! Int64
                    let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[indexPath.row][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[indexPath.row][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[indexPath.row][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[indexPath.row][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[indexPath.row][4] as! Bool && $0[0][5] as! Int64 == Int64(1)})!
                    temporarilyDeleted.remove(at: indexx)
                    for b in 2...pages {
                        let indexxAgain = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[indexPath.row][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[indexPath.row][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[indexPath.row][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[indexPath.row][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[indexPath.row][4] as! Bool && $0[0][5] as! Int64 == Int64(b)})!
                        temporarilyDeleted.remove(at: indexxAgain)
                    }
                }
                var tempArray = [[Any]]()
                for a in 0..<temporarilyDeleted.count {
                    print(a)
                    tempArray.append(temporarilyDeleted[a][0])
                }
                self.temporarilyDeletedFormatted.removeAll()
                self.temporarilyDeletedFormatted = self.global.DataFetch(arrayIn: self.temporarilyDeletedFormatted, arrayWhole: tempArray)
                tableView.deleteRows(at: [indexPath], with: .right)
                tableView.reloadData()
            }))
            al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(al, animated: true, completion: nil)
        }
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "trash")
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let recover = UIContextualAction(style: .normal, title: "Recover") { (context, view, bool) in
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.warning)
            }
            let al = UIAlertController(title: "Recover", message: "Would you like to recover this note?", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Recover", style: .default, handler: { (action) in
                var pages = Int64()
                if self.temporarilyDeletedFormatted[indexPath.row][5] as! Int64 == 0 {
                    let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[indexPath.row][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[indexPath.row][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[indexPath.row][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[indexPath.row][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[indexPath.row][4] as! Bool && $0[0][5] as! Int64 == Int64(0)})!
                    theNotes.append(temporarilyDeleted[indexx][0])
                    temporarilyDeleted.remove(at: indexx)
                } else {
                    pages = self.temporarilyDeletedFormatted[indexPath.row][5] as! Int64
                    let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[indexPath.row][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[indexPath.row][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[indexPath.row][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[indexPath.row][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[indexPath.row][4] as! Bool && $0[0][5] as! Int64 == Int64(1)})!
                    theNotes.append(temporarilyDeleted[indexx][0])
                    temporarilyDeleted.remove(at: indexx)
                    for b in 2...pages {
                        let indexxAgain = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == self.temporarilyDeletedFormatted[indexPath.row][0] as! String && $0[0][1] as! String == self.temporarilyDeletedFormatted[indexPath.row][1] as! String && $0[0][2] as! String == self.temporarilyDeletedFormatted[indexPath.row][2] as! String && $0[0][3] as! String == self.temporarilyDeletedFormatted[indexPath.row][3] as! String && $0[0][4] as! Bool == self.temporarilyDeletedFormatted[indexPath.row][4] as! Bool && $0[0][5] as! Int64 == Int64(b)})!
                        theNotes.append(temporarilyDeleted[indexxAgain][0])
                        temporarilyDeleted.remove(at: indexxAgain)
                    }
                }
                var tempArray = [[Any]]()
                for a in 0..<temporarilyDeleted.count {
                    print(a)
                    tempArray.append(temporarilyDeleted[a][0])
                }
                self.temporarilyDeletedFormatted.removeAll()
                self.temporarilyDeletedFormatted = self.global.DataFetch(arrayIn: self.temporarilyDeletedFormatted, arrayWhole: tempArray)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }))
            al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(al, animated: true, completion: nil)
        }
        recover.backgroundColor = .systemGray
        recover.image = UIImage(systemName: "purchased")
        let swipeActions = UISwipeActionsConfiguration(actions: [recover])
        return swipeActions
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if tableView.indexPathForSelectedRow == nil {
                TrashPageDeleteButton.isEnabled = false
                TrashPageDeleteButton.backgroundColor = .secondaryLabel
                TrashPageDeleteButton.alpha = 0.4
                TrashPageDeleteButton.setTitle("Delete", for: .normal)
                TrashPageRecoverEditButton.isEnabled = false
                TrashPageRecoverEditButton.backgroundColor = .secondaryLabel
                TrashPageRecoverEditButton.alpha = 0.4
                TrashPageRecoverEditButton.setTitle("Recover", for: .normal)
            } else if tableView.indexPathsForSelectedRows!.count >= 1 {
                TrashPageDeleteButton.isEnabled = true
                TrashPageDeleteButton.backgroundColor = .red
                TrashPageDeleteButton.alpha = 1
                TrashPageRecoverEditButton.isEnabled = true
                TrashPageRecoverEditButton.backgroundColor = .systemGreen
                TrashPageRecoverEditButton.alpha = 1
                let titleDel = "Delete " + String(tableView.indexPathsForSelectedRows!.count)
                TrashPageDeleteButton.setTitle(titleDel, for: .normal)
                let titleRec = "Recover " + String(tableView.indexPathsForSelectedRows!.count)
                TrashPageRecoverEditButton.setTitle(titleRec, for: .normal)
            }
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if tableView.indexPathForSelectedRow == nil {
                TrashPageDeleteButton.isEnabled = false
                TrashPageDeleteButton.backgroundColor = .secondaryLabel
                TrashPageDeleteButton.alpha = 0.4
                TrashPageDeleteButton.setTitle("Delete", for: .normal)
                TrashPageRecoverEditButton.isEnabled = false
                TrashPageRecoverEditButton.backgroundColor = .secondaryLabel
                TrashPageRecoverEditButton.alpha = 0.4
                TrashPageRecoverEditButton.setTitle("Recover", for: .normal)
            } else if tableView.indexPathsForSelectedRows!.count >= 1 {
                TrashPageDeleteButton.isEnabled = true
                TrashPageDeleteButton.backgroundColor = .red
                TrashPageDeleteButton.alpha = 1
                TrashPageRecoverEditButton.isEnabled = true
                TrashPageRecoverEditButton.backgroundColor = .systemGreen
                TrashPageRecoverEditButton.alpha = 1
                let titleDel = "Delete " + String(tableView.indexPathsForSelectedRows!.count)
                TrashPageDeleteButton.setTitle(titleDel, for: .normal)
                let titleRec = "Recover " + String(tableView.indexPathsForSelectedRows!.count)
                TrashPageRecoverEditButton.setTitle(titleRec, for: .normal)
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "TrashTVC", for: indexPath) as! TrashPageTVCell
        Cell.TrashPageTVCTitleLabel.text = (temporarilyDeletedFormatted[indexPath.row][0] as! String)
        Cell.TrashPageTVCTagsLabel.text = "🗂" +  String(temporarilyDeletedFormatted[indexPath.row][1] as! String)
        Cell.TrashPageTVCMainContentView.layer.cornerRadius = 12
        Cell.TrashPageTVCMainContentView.layer.masksToBounds = true
        if temporarilyDeletedFormatted[indexPath.row][4] as! Bool == true {
            let image = global.convertBase64StringToImage(imageBase64String: temporarilyDeletedFormatted[indexPath.row][2] as! String)
            Cell.TrashPageTVCTextContentLabel.isHidden = true
            Cell.TrashPageTVCImageView.isHidden = false
            Cell.TrashPageTVCImageView.image = image
        } else {
            Cell.TrashPageTVCTextContentLabel.isHidden = false
            Cell.TrashPageTVCImageView.isHidden = true
            Cell.TrashPageTVCTextContentLabel.text = String(temporarilyDeletedFormatted[indexPath.row][2] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if temporarilyDeletedFormatted[indexPath.row][5] as! Int64 == 0 {
            Cell.TrashPageTVCPageNumber.text = ""
        } else if temporarilyDeletedFormatted[indexPath.row][5] as! Int64 > 0 {
            Cell.TrashPageTVCPageNumber.text = String(temporarilyDeletedFormatted[indexPath.row][5] as! Int64)
        }
        let currentDate = Date()
        var noteDate = Date()
        if temporarilyDeletedFormatted[indexPath.row][5] as! Int64 == 0 {
            noteDate = temporarilyDeleted[indexPath.row][1][0] as! Date
        } else {
            let indexx = temporarilyDeleted.firstIndex(where: {$0[0][0] as! String == temporarilyDeletedFormatted[indexPath.row][0] as! String && $0[0][1] as! String == temporarilyDeletedFormatted[indexPath.row][1] as! String && $0[0][2] as! String == temporarilyDeletedFormatted[indexPath.row][2] as! String && $0[0][3] as! String == temporarilyDeletedFormatted[indexPath.row][3] as! String && $0[0][4] as! Bool == temporarilyDeletedFormatted[indexPath.row][4] as! Bool && $0[0][5] as! Int64 == Int64(1)})!
            noteDate = temporarilyDeleted[indexx][1][0] as! Date
        }
        let comparisonDay =  Calendar.current.dateComponents([.day], from: currentDate, to: noteDate)
        if comparisonDay.day! == 0 {
            let comparisonHour = Calendar.current.dateComponents([.hour], from: currentDate, to: noteDate)
            if comparisonHour.hour! == 0 {
                let comparisonMinute = Calendar.current.dateComponents([.minute], from: currentDate, to: noteDate)
                Cell.TrashPageTVCTrashDateLabel.text = String(comparisonMinute.minute!)
                Cell.TrashPageTVCTrashDateLabelSecondary.text = "Mins"
            } else {
                Cell.TrashPageTVCTrashDateLabel.text = String(comparisonHour.hour! + 1)
                Cell.TrashPageTVCTrashDateLabelSecondary.text = "Hours"
            }
        } else {
            Cell.TrashPageTVCTrashDateLabel.text = String(comparisonDay.day! + 1)
            Cell.TrashPageTVCTrashDateLabelSecondary.text = "Days"
        }
        Cell.TrashPageTVCTrashDateLabel.textColor = .white
        Cell.TrashPageTVCTrashDateLabel.backgroundColor = .systemRed
        Cell.TrashPageTVCTrashDateLabel.layer.cornerRadius = 17.5
        Cell.TrashPageTVCTrashDateLabel.layer.masksToBounds = true
        
        var rating = temporarilyDeletedFormatted[indexPath.row][3] as! String
        if (temporarilyDeletedFormatted[indexPath.row][3] as! String).contains("/") {
            rating = (temporarilyDeletedFormatted[indexPath.row][3] as! String).components(separatedBy: "/")[0]
        }
        if rating == "unrated" {
            Cell.TrashPageTVCDifficultyImageView.image = UIImage(systemName: "0.cirlce.fill")
        } else if rating == "green" {
            Cell.TrashPageTVCDifficultyImageView.image = UIImage(systemName: "1.cirlce.fill")
        } else if rating == "orange" {
            Cell.TrashPageTVCDifficultyImageView.image = UIImage(systemName: "2.cirlce.fill")
        } else if rating == "red" {
            Cell.TrashPageTVCDifficultyImageView.image = UIImage(systemName: "3.cirlce.fill")
        }
        
        return Cell
    }
    
    
    @IBOutlet weak var TrashPageRecoverButton2: UIButton!
    @IBAction func TrashPageRecoverButtonAction(_ sender: UIButton) {
        if settingsPreferances[3][0] as! String == "on" {
            let pow = UINotificationFeedbackGenerator()
            pow.notificationOccurred(.warning)
        }
        let al = UIAlertController(title: "Recover All?", message: "Do you wish to recover all of the items in the trash currently", preferredStyle: .alert)
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        al.addAction(UIAlertAction(title: "Recover", style: .default, handler: { (action) in
            for a in 0..<temporarilyDeleted.count {
                theNotes.append(temporarilyDeleted[a][0])
            }
            var indexs = [IndexPath]()
            for b in 0..<temporarilyDeleted.count {
                indexs.append(IndexPath(row: b, section: 0))
            }
            temporarilyDeleted.removeAll()
            self.temporarilyDeletedFormatted.removeAll()
            self.TrashPageTableView.deleteRows(at: indexs, with: .left)
            DispatchQueue.main.async {
                self.TrashPageTableView.reloadData()
            }
        }))
        self.present(al, animated: true, completion: nil)
    }
    @IBOutlet weak var TrashPageDeleteAllTrashButton: UIButton!
    @IBAction func TrashPageDeleteAllTrashButtonAction(_ sender: UIButton) {
        if settingsPreferances[3][0] as! String == "on" {
            let pow = UINotificationFeedbackGenerator()
            pow.notificationOccurred(.warning)
        }
        let al = UIAlertController(title: "Empty Trash?", message: "This means all notes in the trash will be perminatley deleted. Do you wish to continue?", preferredStyle: .alert)
        al.addAction(UIAlertAction(title: "Empty", style: .destructive, handler: { (action) in
            self.temporarilyDeletedFormatted.removeAll()
            var indexs = [IndexPath]()
            for b in 0..<temporarilyDeleted.count {
                indexs.append(IndexPath(row: b, section: 0))
            }
            temporarilyDeleted.removeAll()
            self.temporarilyDeletedFormatted.removeAll()
            self.TrashPageTableView.deleteRows(at: indexs, with: .right)
            DispatchQueue.main.async {
                self.TrashPageTableView.reloadData()
            }
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(al, animated: true, completion: nil)
    }
    @IBOutlet weak var TrashPageTableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        orderTrash()
        changeTrashButtonColours()
        checkIfButtonsActive()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if TrashPageTableView.isEditing {
            TrashPageTableView.setEditing(false, animated: true)
            TrashPageEditButton.setTitle("Edit", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.TrashPageDeleteButton.bounds = CGRect(x: 82, y: 833, width: 0, height: 42)
            }) { (success) in
                self.TrashPageDeleteButton.isEnabled = false
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.TrashPageRecoverEditButton.bounds = CGRect(x: 332, y: 833, width: 0, height: 42)
            }) { (success) in
                self.TrashPageRecoverEditButton.isEnabled = false
            }
            editingIndex += 1
        }
    }
    func checkIfButtonsActive() {
        if temporarilyDeleted.isEmpty {
            TrashPageEmptyTrashLabel.alpha = 0.4
            TrashPageEmptyTrashLabel.textColor = .secondaryLabel
            TrashPageDeleteAllTrashButton.tintColor = .secondaryLabel
            TrashPageRecoverButton2.tintColor = .secondaryLabel
            TrashPageDeleteAllTrashButton.isEnabled = false
            TrashPageDeleteAllTrashButton.alpha = 0.4
            TrashPageEditButton.alpha = 0.4
            TrashPageRecoverButtonLabel.alpha = 0.4
            TrashPageRecoverButtonLabel.textColor = .secondaryLabel
            TrashPageEditButton.backgroundColor = .secondaryLabel
            TrashPageEditButton.isEnabled = false
            TrashPageRecoverButton2.isEnabled = false
            TrashPageRecoverButton2.alpha = 0.4
        } else {
            TrashPageEmptyTrashLabel.textColor = (settingsPreferances[1][1] as! UIColor)
            TrashPageDeleteAllTrashButton.tintColor = (settingsPreferances[1][1] as! UIColor)
            TrashPageRecoverButton2.tintColor = (settingsPreferances[1][1] as! UIColor)
            TrashPageRecoverButtonLabel.alpha = 1
            TrashPageRecoverButtonLabel.textColor = (settingsPreferances[1][1] as! UIColor)
            TrashPageEditButton.alpha = 1
            TrashPageEditButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
            TrashPageEditButton.isEnabled = true
            TrashPageEmptyTrashLabel.alpha = 1
            TrashPageDeleteAllTrashButton.isEnabled = true
            TrashPageDeleteAllTrashButton.alpha = 1
            TrashPageRecoverButton2.isEnabled = true
            TrashPageRecoverButton2.alpha = 1
        }
    }
    @objc func changeTrashButtonColours() {
        TrashPageEditButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        TrashPageRecoverButton2.tintColor = (settingsPreferances[1][1] as! UIColor)
        TrashPageDeleteAllTrashButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        TrashPageEmptyTrashLabel.textColor = (settingsPreferances[1][1] as! UIColor)
    }
    
    func orderTrash() {
        var tempArray = [[Any]]()
        for a in 0..<temporarilyDeleted.count {
            print(a)
            tempArray.append(temporarilyDeleted[a][0])
        }
        temporarilyDeletedFormatted.removeAll()
        temporarilyDeletedFormatted = global.DataFetch(arrayIn: temporarilyDeletedFormatted, arrayWhole: tempArray)
        print("Ordering Trash")
        TrashPageTableView.reloadData()
    }
    @objc func longPressEdit() {
        if editingIndex % 2 == 0 {
            TrashPageDeleteButton.alpha = 0.4
            TrashPageDeleteButton.backgroundColor = .secondaryLabel
            TrashPageDeleteButton.isEnabled = true
            TrashPageRecoverEditButton.alpha = 0.4
            TrashPageRecoverEditButton.backgroundColor = .secondaryLabel
            TrashPageRecoverEditButton.isEnabled = true
            TrashPageEditButton.setTitle("Done", for: .normal)
            TrashPageTableView.setEditing(true, animated: true)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.TrashPageDeleteButton.bounds = CGRect(x: 20, y: 833, width: 124, height: 42)
            }, completion: nil)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.TrashPageRecoverEditButton.bounds = CGRect(x: 270, y: 833, width: 124, height: 42)
            }, completion: nil)
            editingIndex += 1
        }
    }
    @IBOutlet weak var TrashPageRecoverButtonLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        TrashPageRecoverEditButton.layer.cornerRadius = 16
        TrashPageDeleteButton.layer.cornerRadius = 16
        TrashPageEditButton.layer.cornerRadius = 16
        TrashPageTableView.allowsMultipleSelectionDuringEditing = true
        TrashPageTableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressEdit)))
        NotificationCenter.default.addObserver(self, selector: #selector(changeTrashButtonColours), name: NSNotification.Name("changeTrashButtonColours"), object: nil)
        print("Trash loaded")
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(checkDeletion), userInfo: nil, repeats: true)
        TrashPageTableView.layer.zPosition = 0
        TrashPageTableView.allowsSelection = false
        TrashPageTableView.delegate = self
        TrashPageTableView.dataSource = self
        TrashPageTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    @objc func checkDeletion() {
        global.sortOutTheTrash()
        orderTrash()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
