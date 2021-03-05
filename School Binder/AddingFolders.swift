//
//  AddingFolders.swift
//  School Binder
//
//  Created by Joshua Laurence on 29/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
class AddingFolders: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    var home = HomePage()
    var folderColourTitles = ["Blue", "Gray", "Green","Indigo", "Orange", "Pink", "Purple", "Red", "Teal", "Yellow"]
    var folderColourColours = [UIColor.systemBlue, UIColor.systemGray2, UIColor.systemGreen, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemPink, UIColor.systemPurple, UIColor.systemRed, UIColor.systemTeal, UIColor.systemYellow]
    @IBOutlet weak var AddingFolderShakyTitleTxtField: shakingTextField!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderColourTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColourCVC", for: indexPath) as! ColoursCVCell
        Cell.ColourCVCellButton.setTitle(folderColourTitles[indexPath.row], for: .normal)
        Cell.ColourCVCellButton.tag = indexPath.row
        Cell.ColourCVCellButton.addTarget(self, action: #selector(addMainFolder), for: .touchUpInside)
        Cell.backgroundColor = folderColourColours[indexPath.row]
        Cell.layer.cornerRadius = 91
        return Cell
    }
    @IBOutlet weak var AddingFoldersEnterTitleLabel: UILabel!
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.AddingFoldersEnterTitleLabel.isHidden = true
        return true
    }
    
    @objc func addMainFolder(sender: UIButton!) {
        var already = Bool()
        for a in 0..<theFolders.count {
            if (theFolders[a][0] as! String) == AddingFolderShakyTitleTxtField.text {
                already = true
                break
            }
        }
        if AddingFolderShakyTitleTxtField.text == "" {
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.error)
            }
            AddingFolderShakyTitleTxtField.shake()
            AddingFoldersEnterTitleLabel.isHidden = false
        } else if already == true {
            if settingsPreferances[3][0] as! String == "on" {
                let pow = UINotificationFeedbackGenerator()
                pow.notificationOccurred(.error)
            }
            AddingFolderShakyTitleTxtField.shake()
            AddingFoldersEnterTitleLabel.text = "Folder already exists"
            AddingFoldersEnterTitleLabel.isHidden = false
        } else {
            GlobalFunctions().pow()
            if folderEditing[1] as! Bool == true {
                theFolders[folderEditing[0] as! Int] = [AddingFolderShakyTitleTxtField.text!, "mainFolder", folderColourColours[sender.tag], Int64(0), false]
                folderEditing[0] = 0
                folderEditing[1] = false
                for a in 0..<theNotes.count {
                    if theNotes[a][1] as! String == folderEditing[2] as! String {
                        theNotes[a][1] = AddingFolderShakyTitleTxtField.text!
                    }
                }
                folderEditing[2] = ""
            } else {
                theFolders.append([AddingFolderShakyTitleTxtField.text!, "mainFolder", folderColourColours[sender.tag], Int64(0), false])
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeTV"), object: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.AddingFolderShakyTitleTxtField.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.AddingFolderShakyTitleTxtField.endEditing(true)
    }

    @IBOutlet weak var AddingFolderCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if folderEditing[1] as! Bool == true {
            AddingFolderShakyTitleTxtField.text = (theFolders[folderEditing[0] as! Int][0] as! String)
        }
        AddingFolderCollectionView.delegate = self
        AddingFolderCollectionView.dataSource = self
        AddingFolderShakyTitleTxtField.delegate = self
        AddingFoldersEnterTitleLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if folderEditing[1] as! Bool == true {
            AddingFolderShakyTitleTxtField.text = (theFolders[folderEditing[0] as! Int][0] as! String)
        }
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
