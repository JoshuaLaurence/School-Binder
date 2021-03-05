//
//  StrugglingPage.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class DifficultyKey: UIViewController {
    @IBOutlet weak var DifficultyKeyDimmingView: UIView!
    @IBOutlet weak var DifficultyKeyInformationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DifficultyKeyDimmingView.layer.zPosition = 0
        DifficultyKeyInformationView.layer.zPosition = 1
        DifficultyKeyInformationView.layer.cornerRadius = 24
        DifficultyKeyDimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedDimmingView)))
        DifficultyKeyInformationView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.movingInfoView)))
    }
    
    @objc func tappedDimmingView() {
        GlobalFunctions().pow()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func movingInfoView(gesture:UIPanGestureRecognizer) {
        if gesture.state == .began {
            print("Beginning")
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            DifficultyKeyInformationView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.success)
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.DifficultyKeyInformationView.transform = .identity
            }, completion: { (_) in
            })
        }
    }
}

class StrugglingPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var struggleNotes = [[Any]]()
    var struggleFiltered = [[Any]]()
    var global = GlobalFunctions()
    var transition = SlidingMenuTransition()
    var editingIndex = 0
    
    @IBAction func StruggleEditButtonAction(_ sender: UIButton) {
        global.pow()
        if editingIndex % 2 == 0 {
            StruggleTrashButton.isEnabled = false
            StruggleTrashButton.backgroundColor = .secondaryLabel
            StruggleTrashButton.alpha = 0.4
            StrugglePinButton.isEnabled = false
            StrugglePinButton.backgroundColor = .secondaryLabel
            StrugglePinButton.alpha = 0.4
            StruggleEditButton.setTitle("Done", for: .normal)
            StrugglePageTableView.setEditing(true, animated: true)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.StruggleTrashButton.bounds = CGRect(x: 302, y: 830, width: 92, height: 42)
                self.StrugglePinButton.bounds = CGRect(x: 29, y: 830, width: 92, height: 42)
            }, completion: nil)
            editingIndex += 1
        } else {
            StrugglePageTableView.setEditing(false, animated: true)
            StruggleEditButton.setTitle("Edit", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.StrugglePinButton.bounds = CGRect(x: 70, y: 830, width: 0, height: 42)
                self.StruggleTrashButton.bounds = CGRect(x: 343, y: 830, width: 0, height: 42)
            }) { (success) in
                self.StrugglePinButton.isEnabled = false
                self.StruggleTrashButton.isEnabled = false
            }
            editingIndex += 1
        }
    }
    
    @IBOutlet weak var StruggleEditButton: UIButton!
    @IBOutlet weak var StruggleTrashButton: UIButton!
    
    @IBAction func StruggleTrashButtonAction(_ sender: UIButton) {
        self.global.pow()
        for a in StrugglePageTableView.indexPathsForSelectedRows! {
            var pages = Int64()
            if struggleFiltered[a.row][5] as! Int64 == 0 {
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == struggleFiltered[a.row][0] as! String && $0[1] as! String == struggleFiltered[a.row][1] as! String && $0[2] as! String == struggleFiltered[a.row][2] as! String && $0[3] as! String == struggleFiltered[a.row][3] as! String && $0[4] as! Bool == struggleFiltered[a.row][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[indexx], [noteDate!]])
                theNotes.remove(at: indexx)
            } else {
                pages = struggleFiltered[a.row][5] as! Int64
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == struggleFiltered[a.row][0] as! String && $0[1] as! String == struggleFiltered[a.row][1] as! String && $0[2] as! String == struggleFiltered[a.row][2] as! String && $0[3] as! String == struggleFiltered[a.row][3] as! String && $0[4] as! Bool == struggleFiltered[a.row][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[indexx], [noteDate!]])
                theNotes.remove(at: indexx)
                for b in 2...pages {
                    let indexxAgain = theNotes.firstIndex(where: {$0[0] as! String == struggleFiltered[a.row][0] as! String && $0[1] as! String == struggleFiltered[a.row][1] as! String && $0[2] as! String == struggleFiltered[a.row][2] as! String && $0[3] as! String == struggleFiltered[a.row][3] as! String && $0[4] as! Bool == struggleFiltered[a.row][4] as! Bool && $0[5] as! Int64 == Int64(b)})!
                    let now = Date()
                    let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                    temporarilyDeleted.append([theNotes[indexxAgain], [noteDate!]])
                    theNotes.remove(at: indexxAgain)
                }
            }
        }
        self.struggleNotes.removeAll()
        self.struggleNotes = self.global.DataFetch(arrayIn: self.struggleNotes, arrayWhole: theNotes)
        if self.StruggleSegmentControl.selectedSegmentIndex == 0 {
            self.struggleFiltered = self.struggleNotes.filter {
                $0[3] as! String == "unrated" || $0[3] as! String == "unrated/pinned"
            }
        } else if self.StruggleSegmentControl.selectedSegmentIndex == 1 {
            self.struggleFiltered = self.struggleNotes.filter {
                $0[3] as! String == "green" || $0[3] as! String == "green/pinned"
            }
        } else if self.StruggleSegmentControl.selectedSegmentIndex == 2 {
            self.struggleFiltered = self.struggleNotes.filter {
                $0[3] as! String == "orange" ||  $0[3] as! String == "orange/pinned"
            }
        } else {
            self.struggleFiltered = self.struggleNotes.filter {
                $0[3] as! String == "red" || $0[3] as! String == "red/pinned"
            }
        }
        StrugglePageTableView.deleteRows(at: StrugglePageTableView.indexPathsForSelectedRows!, with: .fade)
        StrugglePageTableView.setEditing(false, animated: true)
        StruggleEditButton.setTitle("Edit", for: .normal)
        UIView.animate(withDuration: 0.3, animations: {
            self.StrugglePinButton.bounds = CGRect(x: 70, y: 830, width: 0, height: 42)
            self.StruggleTrashButton.bounds = CGRect(x: 343, y: 830, width: 0, height: 42)
        }) { (success) in
            self.StrugglePinButton.isEnabled = false
            self.StruggleTrashButton.isEnabled = false
        }
        struggleFiltered.sort {
            (($0[3] as! String).compare($1[3] as! String)) == .orderedDescending
        }
        editingIndex += 1
    }
    
    @IBOutlet weak var StrugglePinButton: UIButton!
    
    
    func afterPinnedSetup() {
        if StruggleSegmentControl.selectedSegmentIndex == 0 {
            struggleNotes.removeAll()
            struggleNotes = global.DataFetch(arrayIn: struggleNotes, arrayWhole: theNotes)
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "unrated" || $0[3] as! String == "unrated/pinned"
            }
        } else if StruggleSegmentControl.selectedSegmentIndex == 1 {
            struggleNotes.removeAll()
            struggleNotes = global.DataFetch(arrayIn: struggleNotes, arrayWhole: theNotes)
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "green" || $0[3] as! String == "green/pinned"
            }
        } else if StruggleSegmentControl.selectedSegmentIndex == 2 {
            struggleNotes.removeAll()
            struggleNotes = global.DataFetch(arrayIn: struggleNotes, arrayWhole: theNotes)
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "orange" || $0[3] as! String == "orange/pinned"
            }
        } else {
            struggleNotes.removeAll()
            struggleNotes = global.DataFetch(arrayIn: struggleNotes, arrayWhole: theNotes)
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "red" || $0[3] as! String == "red/pinned"
            }
        }
        struggleFiltered.sort {
            (($0[3] as! String).compare($1[3] as! String)) == .orderedDescending
        }
    }
    
    func setUpThePins(isPinning: Bool) {
        for a in StrugglePageTableView.indexPathsForSelectedRows! {
            var pages = Int64()
            if self.struggleFiltered[a.row][5] as! Int64 == 0 {
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == struggleFiltered[a.row][0] as! String && $0[1] as! String == struggleFiltered[a.row][1] as! String && $0[2] as! String == struggleFiltered[a.row][2] as! String && $0[3] as! String == struggleFiltered[a.row][3] as! String && $0[4] as! Bool == struggleFiltered[a.row][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                if isPinning {
                    let rating = theNotes[indexx][3] as! String
                    if rating.contains("/") {
                        theNotes[indexx][3] = rating
                    } else {
                        theNotes[indexx][3] = rating + "/pinned"
                    }
                } else {
                    theNotes[indexx][3] = (theNotes[indexx][3] as! String).components(separatedBy: "/")[0]
                }
            } else {
                pages = self.struggleFiltered[a.row][5] as! Int64
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == struggleFiltered[a.row][0] as! String && $0[1] as! String == struggleFiltered[a.row][1] as! String && $0[2] as! String == struggleFiltered[a.row][2] as! String && $0[3] as! String == struggleFiltered[a.row][3] as! String && $0[4] as! Bool == struggleFiltered[a.row][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                if isPinning {
                    let rating = theNotes[indexx][3] as! String
                    if rating.contains("/") {
                        theNotes[indexx][3] = rating
                    } else {
                        theNotes[indexx][3] = rating + "/pinned"
                    }
                } else {
                    theNotes[indexx][3] = (theNotes[indexx][3] as! String).components(separatedBy: "/")[0]
                }
                for b in 2...pages {
                    let indexxAgain = indexx + (Int(b) - 1)
                    if isPinning {
                        let rating = theNotes[indexxAgain][3] as! String
                        if rating.contains("/") {
                            theNotes[indexxAgain][3] = rating
                        } else {
                            theNotes[indexxAgain][3] = rating + "/pinned"
                        }
                    } else {
                        theNotes[indexxAgain][3] = (theNotes[indexxAgain][3] as! String).components(separatedBy: "/")[0]
                    }
                }
            }
        }
    }
    @IBAction func StrugglePinButtonAction(_ sender: UIButton) {
        var isAleadyPinned = [Bool]()
        for a in 0..<StrugglePageTableView.indexPathsForSelectedRows!.count {
            if (struggleFiltered[a][3] as! String).contains("/") == true {
                isAleadyPinned.append(true)
            } else {
                isAleadyPinned.append(false)
            }
        }
        if isAleadyPinned.contains(false) {
            setUpThePins(isPinning: true)
        } else { setUpThePins(isPinning: false) }
        afterPinnedSetup()
        StrugglePageTableView.setEditing(false, animated: true)
        StruggleEditButton.setTitle("Edit", for: .normal)
        UIView.animate(withDuration: 0.3, animations: {
            self.StrugglePinButton.bounds = CGRect(x: 70, y: 830, width: 0, height: 42)
            self.StruggleTrashButton.bounds = CGRect(x: 343, y: 830, width: 0, height: 42)
        }) { (success) in
            self.StrugglePinButton.isEnabled = false
            self.StruggleTrashButton.isEnabled = false
            self.StrugglePageTableView.reloadData()
        }
        editingIndex += 1
    }
    
    @IBOutlet weak var StruggleKeyButtonLabel: UILabel!
    @IBOutlet weak var StruggleKeyButton: UIButton!
    
    @IBAction func StruggleKeyButtonAction(_ sender: UIButton) {
        global.pow()
        let difficultyKey = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DifficultyKey") as! DifficultyKey
        difficultyKey.modalPresentationStyle = .overCurrentContext
        difficultyKey.modalTransitionStyle = .crossDissolve
        self.present(difficultyKey, animated: true)
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pin = UIContextualAction(style: .normal, title: "Pin") { (context, view, bool) in
            self.global.pow()
            var pages = Int64()
            if self.struggleFiltered[indexPath.row][5] as! Int64 == 0 {
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == self.struggleFiltered[indexPath.row][0] as! String && $0[1] as! String == self.struggleFiltered[indexPath.row][1] as! String && $0[2] as! String == self.struggleFiltered[indexPath.row][2] as! String && $0[3] as! String == self.struggleFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.struggleFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                if (self.struggleFiltered[indexPath.row][3] as! String).contains("/") != true {
                    let rating = theNotes[indexx][3] as! String
                    theNotes[indexx][3] = rating + "/pinned"
                } else {
                    theNotes[indexx][3] = (theNotes[indexx][3] as! String).components(separatedBy: "/")[0]
                }
            } else {
                pages = self.struggleFiltered[indexPath.row][5] as! Int64
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == self.struggleFiltered[indexPath.row][0] as! String && $0[1] as! String == self.struggleFiltered[indexPath.row][1] as! String && $0[2] as! String == self.struggleFiltered[indexPath.row][2] as! String && $0[3] as! String == self.struggleFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.struggleFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                if (self.struggleFiltered[indexPath.row][3] as! String).contains("/") != true {
                    let rating = theNotes[indexx][3] as! String
                    theNotes[indexx][3] = rating + "/pinned"
                } else {
                    theNotes[indexx][3] = (theNotes[indexx][3] as! String).components(separatedBy: "/")[0]
                }
                for a in 2...pages {
                    let indexxAgain = indexx + (Int(a) - 1)
                    if (self.struggleFiltered[indexPath.row][3] as! String).contains("/") != true {
                        let rating = theNotes[indexxAgain][3] as! String
                        theNotes[indexxAgain][3] = rating + "/pinned"
                    } else {
                        theNotes[indexxAgain][3] = (theNotes[indexxAgain][3] as! String).components(separatedBy: "/")[0]
                    }
                }
            }
            self.afterPinnedSetup()
            UIView.transition(with: tableView, duration: 0.25, options: .transitionCrossDissolve, animations: {
                tableView.reloadData()
            }, completion: nil)
        }
        pin.backgroundColor = .systemGray
        if (struggleFiltered[indexPath.row][3] as! String).contains("/") != true {
            pin.image = UIImage(systemName: "pin.fill")
            pin.title = "Pin"
        } else {
            pin.image = UIImage(systemName: "pin.slash.fill")
            pin.title = "Un-Pin"
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [pin])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Trash") { (context, view, bool) in
            self.global.pow()
            var pages = Int64()
            if self.struggleFiltered[indexPath.row][5] as! Int64 == 0 {
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == self.struggleFiltered[indexPath.row][0] as! String && $0[1] as! String == self.struggleFiltered[indexPath.row][1] as! String && $0[2] as! String == self.struggleFiltered[indexPath.row][2] as! String && $0[3] as! String == self.struggleFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.struggleFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[indexx], [noteDate!]])
                theNotes.remove(at: indexx)
            } else {
                pages = self.struggleFiltered[indexPath.row][5] as! Int64
                let indexx = theNotes.firstIndex(where: {$0[0] as! String == self.struggleFiltered[indexPath.row][0] as! String && $0[1] as! String == self.struggleFiltered[indexPath.row][1] as! String && $0[2] as! String == self.struggleFiltered[indexPath.row][2] as! String && $0[3] as! String == self.struggleFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.struggleFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[indexx], [noteDate!]])
                theNotes.remove(at: indexx)
                for a in 2...pages {
                    let indexxAgain = indexx + (Int(a) - 1)
                    let now = Date()
                    let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                    temporarilyDeleted.append([theNotes[indexxAgain], [noteDate!]])
                    theNotes.remove(at: indexxAgain)
                }
            }
            self.struggleNotes.removeAll()
            self.struggleNotes = self.global.DataFetch(arrayIn: self.struggleNotes, arrayWhole: theNotes)
            if self.StruggleSegmentControl.selectedSegmentIndex == 0 {
                self.struggleFiltered = self.struggleNotes.filter {
                    $0[3] as! String == "unrated" || $0[3] as! String == "unrated/pinned"
                }
            } else if self.StruggleSegmentControl.selectedSegmentIndex == 1 {
                self.struggleFiltered = self.struggleNotes.filter {
                    $0[3] as! String == "green" || $0[3] as! String == "green/pinned"
                }
            } else if self.StruggleSegmentControl.selectedSegmentIndex == 2 {
                self.struggleFiltered = self.struggleNotes.filter {
                    $0[3] as! String == "orange" ||  $0[3] as! String == "orange/pinned"
                }
            } else {
                self.struggleFiltered = self.struggleNotes.filter {
                    $0[3] as! String == "red" || $0[3] as! String == "red/pinned"
                }
            }
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
        }
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "trash")
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
    func changeEditButtonAppearence() {
        if struggleFiltered.isEmpty {
            StruggleEditButton.backgroundColor = .secondaryLabel
            StruggleEditButton.alpha = 0.4
            StruggleEditButton.isEnabled = false
        } else {
            StruggleEditButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
            StruggleEditButton.alpha = 1
            StruggleEditButton.isEnabled = true
        }
    }
    
    @IBAction func StruggleSegmentControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            global.pow()
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "unrated" || $0[3] as! String == "unrated/pinned"
            }
            struggleFiltered.sort {
                (($0[3] as! String).compare($1[3] as! String)) == .orderedDescending
            }
            changeEditButtonAppearence()
            StrugglePageTableView.reloadData()
            break
        case 1:
            global.pow()
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "green" || $0[3] as! String == "green/pinned"
            }
            struggleFiltered.sort {
                (($0[3] as! String).compare($1[3] as! String)) == .orderedDescending
            }
            changeEditButtonAppearence()
            StrugglePageTableView.reloadData()
            break
        case 2:
            global.pow()
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "orange" || $0[3] as! String == "orange/pinned"
            }
            struggleFiltered.sort {
                (($0[3] as! String).compare($1[3] as! String)) == .orderedDescending
            }
            changeEditButtonAppearence()
            StrugglePageTableView.reloadData()
            break
        case 3:
            global.pow()
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "red" || $0[3] as! String == "red/pinned"
            }
            struggleFiltered.sort {
                (($0[3] as! String).compare($1[3] as! String)) == .orderedDescending
            }
            changeEditButtonAppearence()
            StrugglePageTableView.reloadData()
            break
        default:
            break
        }
    }
    @IBOutlet weak var StruggleSegmentControl: UISegmentedControl!
    @IBOutlet weak var StrugglePageTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if struggleFiltered.isEmpty {
            var title = String()
            var icon = String()
            let currentlySelected = StruggleSegmentControl.selectedSegmentIndex
            if currentlySelected == 0 {
                title = "You have no notes you're completely comfortable with"
                icon = "0.circle.fill"
            } else if currentlySelected == 1 {
                title = "You have no notes you're slightly struggling on"
                icon = "1.circle.fill"
            } else if currentlySelected == 2 {
                title = "You have no notes you're finding quite tricky"
                icon = "2.circle.fill"
            } else {
                title = "You have no notes you're really struggling with and need to work on"
                icon = "3.circle.fill"
            }
            tableView.setEmptyConditions(title: title, message: "You can rate a note by changing the coloured slider on a note", width: tableView.bounds.width, height: tableView.bounds.height, center: tableView.center, iconImageTitle: icon)
        } else {
            tableView.restoreFromEmpty()
        }
        return struggleFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "StruggleTVC", for: indexPath) as! StruggleTVCell
        Cell.StruggleTitle.text = (struggleFiltered[indexPath.row][0] as! String)
        Cell.StruggleTags.text = "🗂" + String(struggleFiltered[indexPath.row][1] as! String)
        if struggleFiltered[indexPath.row][4] as! Bool == true {
            let image = global.convertBase64StringToImage(imageBase64String: struggleFiltered[indexPath.row][2] as! String)
            Cell.StruggleImageView.isHidden = false
            Cell.StruggleTextContent.isHidden = true
            Cell.StruggleImageView.image = image
        } else {
            Cell.StruggleImageView.isHidden = true
            Cell.StruggleTextContent.isHidden = false
            Cell.StruggleTextContent.text = String(struggleFiltered[indexPath.row][2] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        Cell.StrugglePageNumber.layer.cornerRadius = 9
        Cell.StrugglePageNumber.layer.masksToBounds = true
        if struggleFiltered[indexPath.row][5] as! Int64 == 0 {
            Cell.StrugglePageNumber.text = ""
            Cell.StrugglePageNumber.isHidden = true
        } else if struggleFiltered[indexPath.row][5] as! Int64 > 0 {
            Cell.StrugglePageNumber.isHidden = false
            Cell.StrugglePageNumber.text = String(struggleFiltered[indexPath.row][5] as! Int64)
        }
        Cell.StrugglePinImageView.isHidden = true
        if (struggleFiltered[indexPath.row][3] as! String).contains("/") {
            Cell.StrugglePinImageView.isHidden = false
            Cell.StrugglePinImageView.tintColor = (settingsPreferances[1][1] as! UIColor)
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if tableView.indexPathForSelectedRow == nil {
                StruggleTrashButton.isEnabled = false
                StruggleTrashButton.backgroundColor = .secondaryLabel
                StruggleTrashButton.alpha = 0.4
                StruggleTrashButton.setTitle("Trash", for: .normal)
                StrugglePinButton.isEnabled = false
                StrugglePinButton.backgroundColor = .secondaryLabel
                StrugglePinButton.alpha = 0.4
                StrugglePinButton.setTitle("Pin", for: .normal)
            } else if tableView.indexPathsForSelectedRows!.count >= 1 {
                StruggleTrashButton.isEnabled = true
                StruggleTrashButton.backgroundColor = .red
                StruggleTrashButton.alpha = 1
                StrugglePinButton.isEnabled = true
                StrugglePinButton.backgroundColor = .systemGreen
                StrugglePinButton.alpha = 1
                let titleDel = "Trash " + String(tableView.indexPathsForSelectedRows!.count)
                StruggleTrashButton.setTitle(titleDel, for: .normal)
                var containsANonPin = [Bool]()
                var titlePin = String()
                for a in tableView.indexPathsForSelectedRows! {
                    if (struggleFiltered[a.row][3] as! String).contains("/") {
                        containsANonPin.append(true)
                    } else {
                        containsANonPin.append(false)
                    }
                }
                if containsANonPin.contains(false) {
                    titlePin = "Pin " + String(tableView.indexPathsForSelectedRows!.count)
                } else {
                    titlePin = "Un-Pin " + String(tableView.indexPathsForSelectedRows!.count)
                }
                StrugglePinButton.setTitle(titlePin, for: .normal)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        global.pow()
        if tableView.isEditing {
            if tableView.indexPathForSelectedRow == nil {
                StruggleTrashButton.isEnabled = false
                StruggleTrashButton.backgroundColor = .secondaryLabel
                StruggleTrashButton.alpha = 0.4
                StruggleTrashButton.setTitle("Trash", for: .normal)
                StrugglePinButton.isEnabled = false
                StrugglePinButton.backgroundColor = .secondaryLabel
                StrugglePinButton.alpha = 0.4
                StrugglePinButton.setTitle("Pin", for: .normal)
            } else if tableView.indexPathsForSelectedRows!.count >= 1 {
                StruggleTrashButton.isEnabled = true
                StruggleTrashButton.backgroundColor = .red
                StruggleTrashButton.alpha = 1
                StrugglePinButton.isEnabled = true
                StrugglePinButton.backgroundColor = .systemGreen
                StrugglePinButton.alpha = 1
                let titleDel = "Trash " + String(tableView.indexPathsForSelectedRows!.count)
                StruggleTrashButton.setTitle(titleDel, for: .normal)
                var containsANonPin = [Bool]()
                var titlePin = String()
                for a in tableView.indexPathsForSelectedRows! {
                    if (struggleFiltered[a.row][3] as! String).contains("/") {
                        containsANonPin.append(true)
                    } else {
                        containsANonPin.append(false)
                    }
                }
                if containsANonPin.contains(false) {
                    titlePin = "Pin " + String(tableView.indexPathsForSelectedRows!.count)
                } else {
                    titlePin = "Un-Pin " + String(tableView.indexPathsForSelectedRows!.count)
                }
                StrugglePinButton.setTitle(titlePin, for: .normal)
            }
        } else {
            if struggleFiltered[indexPath.row][5] as! Int64 == 0 {
                
            } else {
                struggleFiltered[indexPath.row][5] = Int64(1)
            }
            ind = theNotes.firstIndex(where: {$0[0] as! String == struggleFiltered[indexPath.row][0] as! String && $0[1] as! String == struggleFiltered[indexPath.row][1] as! String && $0[2] as! String == struggleFiltered[indexPath.row][2] as! String && $0[3] as! String == struggleFiltered[indexPath.row][3] as! String && $0[4] as! Bool == struggleFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == struggleFiltered[indexPath.row][5] as! Int64})!
            if theNotes[ind][4] as! Bool == true {
                performSegue(withIdentifier: "ImgSegueStruggle", sender: self)
            } else {
                performSegue(withIdentifier: "TxtSegueStruggle", sender: self)
            }
            tableView.deselectRow(at: IndexPath(row: indexPath.row, section: 0), animated: true)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if StrugglePageTableView.isEditing {
            StrugglePageTableView.setEditing(false, animated: true)
            StruggleEditButton.setTitle("Edit", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.StrugglePinButton.bounds = CGRect(x: 70, y: 830, width: 0, height: 42)
                self.StruggleTrashButton.bounds = CGRect(x: 343, y: 830, width: 0, height: 42)
            }) { (success) in
                self.StrugglePinButton.isEnabled = false
                self.StruggleTrashButton.isEnabled = false
            }
            editingIndex += 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        struggleNotes.removeAll()
        struggleNotes = global.DataFetch(arrayIn: struggleNotes, arrayWhole: theNotes)
        if StruggleSegmentControl.selectedSegmentIndex == 0 {
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "unrated" || $0[3] as! String == "unrated/pinned"
            }
        } else if StruggleSegmentControl.selectedSegmentIndex == 1 {
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "green" || $0[3] as! String == "green/pinned"
            }
        } else if StruggleSegmentControl.selectedSegmentIndex == 1 {
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "orange" || $0[3] as! String == "orange/pinned"
            }
        } else {
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "red" || $0[3] as! String == "red/pinned"
            }
        }
        struggleFiltered.sort {
            (($0[3] as! String).compare($1[3] as! String)) == .orderedDescending
        }
        changeDifficultyButtonColours()
        changeEditButtonAppearence()
        StrugglePageTableView.reloadData()
    }
    
    @objc func changeDifficultyButtonColours() {
        StruggleEditButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        StruggleKeyButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        StruggleKeyButtonLabel.textColor = (settingsPreferances[1][1] as! UIColor)
    }
    
    @objc func reloadStrugglingTV() {
        struggleNotes.removeAll()
        struggleNotes = global.DataFetch(arrayIn: struggleNotes, arrayWhole: theNotes)
        if StruggleSegmentControl.selectedSegmentIndex == 0 {
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "unrated" || $0[3] as! String == "unrated/pinned"
            }
        } else if StruggleSegmentControl.selectedSegmentIndex == 1 {
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "green" || $0[3] as! String == "green/pinned"
            }
        } else if StruggleSegmentControl.selectedSegmentIndex == 1 {
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "orange" || $0[3] as! String == "orange/pinned"
            }
        } else {
            struggleFiltered = struggleNotes.filter {
                $0[3] as! String == "red" || $0[3] as! String == "red/pinned"
            }
        }
        struggleFiltered.sort {
            (($0[3] as! String).compare($1[3] as! String)) == .orderedDescending
        }
        StrugglePageTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StrugglePageTableView.allowsMultipleSelectionDuringEditing = true
        StruggleEditButton.layer.cornerRadius = 16
        StrugglePinButton.layer.cornerRadius = 16
        StruggleTrashButton.layer.cornerRadius = 16
        NotificationCenter.default.addObserver(self, selector: #selector(changeDifficultyButtonColours), name: NSNotification.Name(rawValue: "changeDifficultyButtonColours"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStrugglingTV), name: NSNotification.Name(rawValue: "reloadStrugglingTV"), object: nil)
        StrugglePageTableView.delegate = self
        StrugglePageTableView.dataSource = self
        StrugglePageTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
}
extension StrugglingPage: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
