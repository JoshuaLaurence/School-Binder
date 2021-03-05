//
//  MovingNotesPage.swift
//  School Binder
//
//  Created by Joshua Laurence on 30/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
var isNotInSearch = false
class MovingNotesPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var multiple = false
    var indexsForChange = [Int]()
    var transferingFromAnotherFolder = [0,0,false] as [Any]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theFolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "MovingNotesTVC", for: indexPath) as! MovingNotesTVCell
        if theFolders[indexPath.row][1] as! String == "mainFolder" {
            Cell.MovingNotesTitleLabel.text = (theFolders[indexPath.row][0] as! String)
            Cell.MovingNotesTitleLabel.font = UIFont(name: "Futura", size: 28)
            Cell.MovingNotesTitleLabel.textColor = UIColor().colFromHex("E8E9EC")
            Cell.backgroundColor = (theFolders[indexPath.row][2] as! UIColor)
            Cell.layer.cornerRadius = 10
        } else {
            let title = (theFolders[indexPath.row][0] as! String).components(separatedBy: "/")
            Cell.MovingNotesTitleLabel.text = title.last!
            Cell.MovingNotesTitleLabel.font = UIFont(name: "Futura", size: 18)
            Cell.MovingNotesTitleLabel.textColor = .secondaryLabel
            Cell.backgroundColor = .clear
        }
        return Cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if theFolders[indexPath.row][1] as! String == "mainFolder" {
            height = 60
        } else {
            height = 45
        }
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalFunctions().pow()
        print(theFolders[indexPath.row][0] as! String)
        print("index \(ind)")
        if multiple {
            for a in 0..<indexsForChange.count {
                theNotes[indexsForChange[a]][1] = theFolders[indexPath.row][0] as! String
            }
            NotificationCenter.default.post(name: NSNotification.Name("insideFolderMovingNotes"), object: self)
            multiple = false
            indexsForChange = [Int]()
        } else if transferingFromAnotherFolder[2] as! Bool == true {
            let index = transferingFromAnotherFolder[0] as! Int
            let subFolderCount = transferingFromAnotherFolder[1] as! Int
            let folderTitle = theFolders[indexPath.row][0] as! String
            for a in 0..<theNotes.count {
                if theNotes[a][1] as! String == theFolders[index][0] as! String {
                    theNotes[a][1] = folderTitle
                }
                if subFolderCount != 0 {
                    for b in 1...subFolderCount {
                        for c in 0..<theNotes.count {
                            if theNotes[c][1] as! String == theFolders[b][0] as! String {
                                theNotes[c][1] = folderTitle
                            }
                        }
                    }
                }
            }
            for a in 0..<theNotes.count {
                if theNotes[a][1] as! String == theFolders[index][0] as! String {
                    theNotes[a][1] = folderTitle
                }
            }
            theFolders.remove(at: index)
            if subFolderCount != 0 {
                for d in 1...subFolderCount {
                    theFolders.remove(at: d)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("reloadHomeTVWithSearch"), object: self)
        } else {
            theNotes[ind][1] = theFolders[indexPath.row][0] as! String
        }
        if isNotInSearch {
            isNotInSearch = false
        } else {
            print("In Search")
            ind = 0
        }
        NotificationCenter.default.post(name: NSNotification.Name("reloadAllNotesTV"), object: self)
        NotificationCenter.default.post(name: NSNotification.Name("reloadImageViewPage"), object: self)
        NotificationCenter.default.post(name: NSNotification.Name("reloadTextViewerTagLabel"), object: self)
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var MovingNotesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MovingNotesTableView.delegate = self
        MovingNotesTableView.dataSource = self
        MovingNotesTableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
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
extension UIColor {
    func colFromHex(_ hex: String) -> UIColor {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0,
                            alpha: 1)
    }
}
