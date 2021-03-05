//
//  InsideFolderPage.swift
//  School Binder
//
//  Created by Joshua Laurence on 29/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
import VisionKit
import Vision
import PDFKit

class InsideFolderSubFolderCell: UICollectionViewCell {
    
    @IBOutlet weak var InsideFolderSubFolderCellView: UIView!
    @IBOutlet weak var InsideFolderSubFolderCellTitle: UILabel!
}

class InsideFolderSectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var InsideFolderSectionHeaderViewMainLabel: UILabel!
}

class InsideFolderPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, VNDocumentCameraViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var InsideFolderPageAddButtonLabel: UILabel!
    var goingToFoldersIndexs = [Int]()
    var goingToFolders = false
    var subFolders = [String]()
    var innerFolderString = String()
    var insideFolderNotes = [[Any]]()
    var insideFolderFiltered = [[Any]]()
    @IBOutlet weak var InsideFolderPageTitle: UILabel!
    @IBOutlet weak var InsideFolderSmallerPageTitle: UILabel!
    
    @IBOutlet weak var InsideFolderSortButton: UIButton!
    @IBAction func InsideFolderSortButtonAction(_ sender: UIButton) {
    }
    var isImageForTextfield = false
    @objc func enablingAddNoteAlertTextfield(_ sender: UITextField) {
        var resp : UIResponder! = sender
        while !(resp is UIAlertController) { resp = resp.next }
        let al = resp as! UIAlertController
        var already = false
        for a in 0..<theNotes.count {
            if (theNotes[a][0] as! String == sender.text && theNotes[a][4] as! Bool == isImageForTextfield) || sender.text == "" {
                already = true
                break
            }
        }
        if already == true {
            al.actions[0].isEnabled = false
        } else {
            al.actions[0].isEnabled = true
        }
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
            if theFolders[a][0] as! String == actualTitle || sender.text == "" {
                already = true
                break
            }
        }
        if already == true {
            al.actions[0].isEnabled = false
        } else {
            al.actions[0].isEnabled = true
        }
    }
    @IBOutlet weak var InsideFolderSubFolderButtonLabel: UILabel!
    @IBOutlet weak var InsideFolderSubFolderButton: UIButton!
    @IBAction func InsideFolderSubFolderButtonAction(_ sender: UIButton) {
        self.global.pow()
        let al = UIAlertController(title: "Add a topic", message: "", preferredStyle: .alert)
        al.addTextField { (textfield) in
            textfield.addTarget(self, action: #selector(self.enablingAddSubviewAlertButton), for: .editingChanged)
            textfield.placeholder = "Title for '\(self.InsideFolderPageTitle.text)' subfolder"
        }
        al.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let index = theFolders.firstIndex(where: {$0[0] as! String == self.InsideFolderPageTitle.text})!
            let title = al.textFields?[0].text
            let actualTitle = String(theFolders[index][0] as! String + "/" + title!)
            if index + 1 == theFolders.count {
                theFolders.append([actualTitle, "subFolder", UIColor.clear, Int64(1), false])
                self.subFolders.insert(actualTitle, at: 0)
            } else {
                if theFolders[index][4] as! Bool == false {
                    theFolders.insert([actualTitle, "subFolder", UIColor.clear, Int64(1), false], at: index + 1)
                    self.subFolders.insert(actualTitle, at: 0)
                } else  {
                    theFolders.insert([actualTitle, "subFolder", UIColor.clear, Int64(1), true], at: index + 1)
                    self.subFolders.insert(actualTitle, at: 0)
                }
            }
            DispatchQueue.main.async {
                self.insideFolderFiltered.removeAll()
                self.insideFolderNotes = self.global.DataFetch(arrayIn: self.insideFolderNotes, arrayWhole: theNotes)
                self.insideFolderFiltered = self.insideFolderNotes.filter {
                    $0[1] as! String == self.innerFolderString
                }
                self.InsideFolderPageCollectionView.reloadData()
            }
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(al, animated: true, completion: nil)
    }
    
    @IBOutlet weak var InsideFolderTrashButton: UIButton!
    @IBAction func InsideFolderTrashButtonAction(_ sender: UIButton) {
        var indexArray = [IndexPath]()
        for a in 0..<selectedIndexs.filter({$0 == true}).count {
            global.pow()
            print(a)
            var pages = Int64()
            var index = selectedIndexs.firstIndex(of: true)!
            if index == insideFolderFiltered.count {
                index = index - 1
            }
            indexArray.append(IndexPath(item: index, section: 0))
            if insideFolderFiltered[index][5] as! Int64 == 0 {
                let index2 = theNotes.firstIndex(where: {$0[0] as! String == insideFolderFiltered[index][0] as! String && $0[1] as! String == insideFolderFiltered[index][1] as! String && $0[2] as! String == insideFolderFiltered[index][2] as! String && $0[3] as! String == insideFolderFiltered[index][3] as! String && $0[4] as! Bool == insideFolderFiltered[index][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[index2], [noteDate!]])
                theNotes.remove(at: index2)
            } else {
                pages = insideFolderFiltered[index][5] as! Int64
                let index2 = theNotes.firstIndex(where: {$0[0] as! String == insideFolderFiltered[index][0] as! String && $0[1] as! String == insideFolderFiltered[index][1] as! String && $0[2] as! String == insideFolderFiltered[index][2] as! String && $0[3] as! String == insideFolderFiltered[index][3] as! String && $0[4] as! Bool == insideFolderFiltered[index][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[index2], [noteDate!]])
                theNotes.remove(at: index2)
                for b in 2...pages {
                    let index3 = theNotes.firstIndex(where: {$0[0] as! String == insideFolderFiltered[index][0] as! String && $0[1] as! String == insideFolderFiltered[index][1] as! String && $0[2] as! String == insideFolderFiltered[index][2] as! String && $0[3] as! String == insideFolderFiltered[index][3] as! String && $0[4] as! Bool == insideFolderFiltered[index][4] as! Bool && $0[5] as! Int64 == Int64(b)})!
                    temporarilyDeleted.append([theNotes[index3], [noteDate!]])
                    theNotes.remove(at: index2)
                }
            }
            selectedIndexs[index] = false
            insideFolderFiltered.remove(at: index)
        }
        InsideFolderEditButton.setTitle("Edit", for: .normal)
        UIView.animate(withDuration: 0.3, animations: {
            self.InsideFolderMoveButton.bounds = CGRect(x: 157, y: 830, width: 0, height: 42)
            self.InsideFolderTrashButton.bounds = CGRect(x: 257, y: 830, width: 0, height: 42)
        }) { (success) in
            self.InsideFolderMoveButton.isHidden = true
            self.InsideFolderMoveButton.isEnabled = false
            self.InsideFolderTrashButton.isHidden = true
            self.InsideFolderTrashButton.isEnabled = false
        }
        InsideFolderPageCollectionView.deleteItems(at: indexArray)
        collectionViewEditing = false
        InsideFolderPageCollectionView.allowsMultipleSelection = collectionViewEditing
        insideFolderNotes.removeAll()
        insideFolderNotes = global.DataFetch(arrayIn: insideFolderNotes, arrayWhole: theNotes)
        insideFolderFiltered = insideFolderNotes.filter {
            $0[1] as! String == innerFolderString
        }
        InsideFolderPageCollectionView.reloadData()
    }
    
    @IBOutlet weak var InsideFolderMoveButton: UIButton!
    @IBAction func InsideFolderMoveButtonAction(_ sender: UIButton) {
        var indexArray = [IndexPath]()
        for a in 0..<selectedIndexs.filter({$0 == true}).count {
            global.pow()
            print(a)
            var pages = Int64()
            let index = selectedIndexs.firstIndex(of: true)!
            indexArray.append(IndexPath(item: index, section: 0))
            if insideFolderFiltered[index][5] as! Int64 == 0 {
                let index2 = theNotes.firstIndex(where: {$0[0] as! String == insideFolderFiltered[index][0] as! String && $0[1] as! String == insideFolderFiltered[index][1] as! String && $0[2] as! String == insideFolderFiltered[index][2] as! String && $0[3] as! String == insideFolderFiltered[index][3] as! String && $0[4] as! Bool == insideFolderFiltered[index][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                goingToFoldersIndexs.append(index2)
            } else {
                pages = insideFolderFiltered[index][5] as! Int64
                let index2 = theNotes.firstIndex(where: {$0[0] as! String == insideFolderFiltered[index][0] as! String && $0[1] as! String == insideFolderFiltered[index][1] as! String && $0[2] as! String == insideFolderFiltered[index][2] as! String && $0[3] as! String == insideFolderFiltered[index][3] as! String && $0[4] as! Bool == insideFolderFiltered[index][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                goingToFoldersIndexs.append(index2)
                for b in 2...pages {
                    let index3 = index2 + (Int(b) - 1)
                    goingToFoldersIndexs.append(index3)
                }
            }
            selectedIndexs[index] = false
        }
        goingToFolders = true
        performSegue(withIdentifier: "insideFolderMovingNotesSegue", sender: self)
    }
    
    
    
    @IBOutlet weak var InsideFolderEditButton: UIButton!
    var collectionViewEditing = false
    @IBAction func InsideFolderEditButtonAction(_ sender: UIButton) {
        if InsideFolderEditButton.titleLabel!.text == "Edit" {
            InsideFolderEditButton.setTitle("Done", for: .normal)
            collectionViewEditing = true
            InsideFolderMoveButton.isHidden = false
            InsideFolderMoveButton.isEnabled = true
            InsideFolderMoveButton.alpha = 0.4
            InsideFolderMoveButton.backgroundColor = .secondaryLabel
            InsideFolderMoveButton.setTitle("Move", for: .normal)
            InsideFolderTrashButton.isHidden = false
            InsideFolderTrashButton.isEnabled = true
            InsideFolderTrashButton.alpha = 0.4
            InsideFolderTrashButton.backgroundColor = .secondaryLabel
            InsideFolderTrashButton.setTitle("Trash", for: .normal)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.InsideFolderMoveButton.bounds = CGRect(x: 120, y: 830, width: 74, height: 42)
                self.InsideFolderTrashButton.bounds = CGRect(x: 220, y: 830, width: 74, height: 42)
            }, completion: nil)
            
            InsideFolderPageCollectionView.allowsMultipleSelection = collectionViewEditing
        } else {
            InsideFolderEditButton.setTitle("Edit", for: .normal)
            collectionViewEditing = false
            UIView.animate(withDuration: 0.3, animations: {
                self.InsideFolderMoveButton.bounds = CGRect(x: 157, y: 830, width: 0, height: 42)
                self.InsideFolderTrashButton.bounds = CGRect(x: 257, y: 830, width: 0, height: 42)
            }) { (success) in
                self.InsideFolderMoveButton.isHidden = true
                self.InsideFolderMoveButton.isEnabled = false
                self.InsideFolderTrashButton.isHidden = true
                self.InsideFolderTrashButton.isEnabled = false
            }
            InsideFolderPageCollectionView.allowsMultipleSelection = collectionViewEditing
            for a in 0..<insideFolderFiltered.count  {
                self.selectedIndexs[a] = false
            }
            InsideFolderPageCollectionView.reloadData()
            print(selectedIndexs)
        }
    }
    
    @IBOutlet weak var InsideFolderPageAddNote: UIButton!
    @IBAction func InsideFolderPageAddNoteAction(_ sender: UIButton) {
        global.pow()
        let al = UIAlertController(title: "Create A Note", message: "", preferredStyle: .actionSheet)
        al.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: { (action) in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.camera
            image.allowsEditing = true
            self.present(image, animated: true) {
                
            }
        }))
        al.addAction(UIAlertAction(title: "Scan Documents", style: .default, handler: { (action) in
            let vc = VNDocumentCameraViewController()
            vc.delegate = self
            self.present(vc, animated: true)
            self.InsideFolderPageCollectionView.reloadData()
        }))
        al.addAction(UIAlertAction(title: "Image From Photo Library", style: .default, handler: { (action) in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = true
            self.present(image, animated: true) {
                
            }
        }))
        al.addAction(UIAlertAction(title: "Make A Text Note", style: .default, handler: { (action) in
            let al2 = UIAlertController(title: "Add Text Note", message: "", preferredStyle: .alert)
            al2.addTextField { (textfield) in
                textfield.addTarget(self, action: #selector(self.enablingAddNoteAlertTextfield), for: .editingChanged)
                self.isImageForTextfield = false
                textfield.placeholder = "Title"
            }
            al2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            al2.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                let tit = al2.textFields![0].text
                let tag = String(self.innerFolderString)
                theNotes.append([tit!, tag, "This is an empty text field... For now...", "unrated", false, Int64(0)])
                self.insideFolderNotes.removeAll()
                self.insideFolderNotes = self.global.DataFetch(arrayIn: self.insideFolderNotes, arrayWhole: theNotes)
                self.insideFolderFiltered = self.insideFolderNotes.filter {
                    $0[1] as! String == self.innerFolderString
                }
                ind = Int(theNotes.count - 1)
                self.checkMainButtonsActive()
                self.selectedIndexs.append(false)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "TxtSegueFolder", sender: self)
                }
            }))
            DispatchQueue.main.async {
                self.present(al2, animated: true, completion: nil)
            }
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(al, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let al2 = UIAlertController(title: "Add Image", message: "", preferredStyle: .alert)
            al2.addTextField { (textfield) in
                textfield.addTarget(self, action: #selector(self.enablingAddNoteAlertTextfield), for: .editingChanged)
                self.isImageForTextfield = true
                textfield.placeholder = "Title"
            }
            al2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            al2.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                let img = self.global.convertImageToBase64String(img: image)
                let tit = al2.textFields![0].text
                let tag = String(self.innerFolderString)
                theNotes.append([tit!, tag, img, "unrated", true, Int64(0)])
                self.insideFolderNotes.removeAll()
                self.insideFolderNotes = self.global.DataFetch(arrayIn: self.insideFolderNotes, arrayWhole: theNotes)
                self.insideFolderFiltered = self.insideFolderNotes.filter {
                    $0[1] as! String == self.innerFolderString
                }
                self.checkMainButtonsActive()
                self.selectedIndexs.append(false)
                DispatchQueue.main.async {
                    self.InsideFolderPageCollectionView.reloadData()
                }
            }))
            DispatchQueue.main.async {
                self.present(al2, animated: true, completion: nil)
            }
        } else {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        print("Found \(scan.pageCount)")
        var tit = String()
        var tag = String()
        let al2 = UIAlertController(title: "Add Documents", message: "", preferredStyle: .alert)
        al2.addTextField { (textfield) in
            textfield.addTarget(self, action: #selector(self.enablingAddNoteAlertTextfield), for: .editingChanged)
            self.isImageForTextfield = true
            textfield.placeholder = "Title"
        }
        al2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        al2.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            tit = al2.textFields![0].text!
            tag = String(self.innerFolderString)
            if scan.pageCount == 1 {
                let textImg = self.global.convertImageToBase64String(img: scan.imageOfPage(at: 0))
                theNotes.append([tit, tag, textImg, "unrated", true, Int64(0)])
            }
            else if scan.pageCount > 1 {
                for i in 0 ..< scan.pageCount {
                    let img = scan.imageOfPage(at: i)
                    let textImg2 = self.global.convertImageToBase64String(img: img)
                    let pgNum = i + 1
                    theNotes.append([tit, tag, textImg2, "unrated", true, Int64(pgNum)])
                }
            }
            self.insideFolderNotes.removeAll()
            self.insideFolderNotes = self.global.DataFetch(arrayIn: self.insideFolderNotes, arrayWhole: theNotes)
            self.insideFolderFiltered = self.insideFolderNotes.filter {
                $0[1] as! String == self.innerFolderString
            }
            self.checkMainButtonsActive()
            self.selectedIndexs.append(false)
            DispatchQueue.main.async {
                self.InsideFolderPageCollectionView.reloadData()
            }
        }))
        DispatchQueue.main.async {
            self.present(al2, animated: true, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    var global = GlobalFunctions()
    var numberOfSectionInt = Int()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sections = 1
        if subFolders.isEmpty == true {
            sections = 1
            numberOfSectionInt = 0
        } else {
            sections = 2
            numberOfSectionInt = 1
        }
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = Int()
        if subFolders.isEmpty && insideFolderFiltered.isEmpty {
            collectionView.setEmptyConditions(title: "No Notes or Topics", message: "You can add notes using the plus in the top right corner, or you can add topics by going back to the home page and swiping left on a main folder", width: collectionView.frame.width, height: collectionView.frame.height, center: collectionView.center, iconImageTitle: "book.closed")
            items = 0
        } else {
            collectionView.restoreFromEmpty()
            if section == numberOfSectionInt {
    //            if insideFolderFiltered.isEmpty && subFolders.isEmpty {
    //                collectionView.setEmptyConditions(title: "You have no notes in this Folder :(", message: "Try adding one with the add button in the top left hand corner", width: collectionView.bounds.width, height: self.view.bounds.height, center: self.view.center)
    //            } else {
    //                collectionView.restoreFromEmpty()
    //            }
                items = insideFolderFiltered.count
            } else {
                items = subFolders.count
            }
        }
        return items
    }
    var selectedIndexs = [Bool]()
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! InsideFolderSectionHeaderView
        if collectionView.numberOfSections > 1 {
            sectionHeader.frame.size = CGSize(width: self.view.frame.width, height: 50)
            if indexPath.section == 0 {
                sectionHeader.InsideFolderSectionHeaderViewMainLabel.text = "Topics"
            } else {
                sectionHeader.InsideFolderSectionHeaderViewMainLabel.text = "Notes"
            }
        }
        return sectionHeader
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize()
        if collectionView.numberOfSections > 1 {
            if insideFolderFiltered.isEmpty && section == 1 {
                size = CGSize(width: self.view.frame.width, height: 0)
            } else {
                size = CGSize(width: self.view.frame.width, height: 50)
            }
        } else {
            size = CGSize(width: self.view.frame.width, height: 0)
        }
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        global.pow()
        if indexPath.section == numberOfSectionInt {
            if collectionViewEditing {
                selectedIndexs[indexPath.row] = true
                if selectedIndexs.filter({$0 == true}).count == 1 {
                    InsideFolderMoveButton.alpha = 1
                    InsideFolderMoveButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
                    InsideFolderTrashButton.alpha = 1
                    InsideFolderTrashButton.backgroundColor = .red
                }
                var title = "Move " + String(selectedIndexs.filter{$0 == true}.count)
                InsideFolderMoveButton.setTitle(title, for: .normal)
                title = "Trash " + String(selectedIndexs.filter{$0 == true}.count)
                InsideFolderTrashButton.setTitle(title, for: .normal)
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
                if insideFolderFiltered[indexPath.row][5] as! Int64 == 0 {
                    
                } else {
                    insideFolderFiltered[indexPath.row][5] = Int64(1)
                }
                ind = theNotes.firstIndex(where: {$0[0] as! String == insideFolderFiltered[indexPath.row][0] as! String && $0[1] as! String == insideFolderFiltered[indexPath.row][1] as! String && $0[2] as! String == insideFolderFiltered[indexPath.row][2] as! String && $0[3] as! String == insideFolderFiltered[indexPath.row][3] as! String && $0[4] as! Bool == insideFolderFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == insideFolderFiltered[indexPath.row][5] as! Int64})!
                if theNotes[ind][4] as! Bool == true {
                    performSegue(withIdentifier: "ImgSegueFolder", sender: self)
                } else {
                    performSegue(withIdentifier: "TxtSegueFolder", sender: self)
                }
            }
        } else {
            let selfVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "InsideFolder") as! InsideFolderPage
            selfVC.innerFolderString = subFolders[indexPath.row]
            selfVC.subFolders = [String]()
            self.navigationController?.pushViewController(selfVC, animated: true)
        }
    }
    
    var movingIndexs = [0, 0, false] as [Any]
    var movingNotesFromSubFolders = Bool()
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        var index = Int()
        if indexPath.section == numberOfSectionInt {
            index = theNotes.firstIndex(where: {$0[0] as! String == self.insideFolderFiltered[indexPath.row][0] as! String && $0[1] as! String == self.insideFolderFiltered[indexPath.row][1] as! String && $0[2] as! String == self.insideFolderFiltered[indexPath.row][2] as! String && $0[3] as! String == self.insideFolderFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.insideFolderFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
        }
        let delete = UIAction(title: "Trash", image: UIImage(systemName: "trash")) { action in
            var pages = 0
            if self.insideFolderFiltered[indexPath.row][5] as! Int64 == 0 {
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[index], [noteDate!]])
                theNotes.remove(at: index)
            } else {
                pages = Int(self.insideFolderFiltered[indexPath.row][5] as! Int64)
                let index2 = theNotes.firstIndex(where: {$0[0] as! String == self.insideFolderFiltered[indexPath.row][0] as! String && $0[1] as! String == self.insideFolderFiltered[indexPath.row][1] as! String && $0[2] as! String == self.insideFolderFiltered[indexPath.row][2] as! String && $0[3] as! String == self.insideFolderFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.insideFolderFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                let now = Date()
                let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
                temporarilyDeleted.append([theNotes[index2], [noteDate!]])
                theNotes.remove(at: index2)
                for b in 2...pages {
                    let index3 = theNotes.firstIndex(where: {$0[0] as! String == self.insideFolderFiltered[indexPath.row][0] as! String && $0[1] as! String == self.insideFolderFiltered[indexPath.row][1] as! String && $0[2] as! String == self.insideFolderFiltered[indexPath.row][2] as! String && $0[3] as! String == self.insideFolderFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.insideFolderFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(b)})!
                    temporarilyDeleted.append([theNotes[index3], [noteDate!]])
                    theNotes.remove(at: index2)
                }
            }
            self.insideFolderNotes.removeAll()
            self.insideFolderNotes = self.global.DataFetch(arrayIn: self.insideFolderNotes, arrayWhole: theNotes)
            self.insideFolderFiltered = self.insideFolderNotes.filter {
                $0[1] as! String == self.innerFolderString
            }
            collectionView.deleteItems(at: [indexPath])
            collectionView.reloadData()
        }
        let convertToText = UIAction(title: "Convert To Text", image: UIImage(systemName: "textbox")) { action in
            var text = String()
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    fatalError("Received invalid observations")
                }

                for observation in observations {
                    guard let bestCandidate = observation.topCandidates(1).first else {
                        print("No candidate")
                        continue
                    }
                    text = text + bestCandidate.string + "\n"
                }
            }
            
            request.recognitionLevel = .accurate
            let requests = [request]
            let image = (self.global.convertBase64StringToImage(imageBase64String: theNotes[index][2] as! String)).cgImage
            DispatchQueue.global(qos: .userInitiated).async {
                guard let img = image else {
                    fatalError("Missing image to scan")
                }

                let handler = VNImageRequestHandler(cgImage: img, options: [:])
                try? handler.perform(requests)
            }
            
            let al = UIAlertController(title: "Converted To Text", message: "Would you like to save the text as a seperate note, replace the current image with the text or discard?", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                theNotes.append([(theNotes[index][1] as! String), (theNotes[index][1] as! String), text, (theNotes[index][3] as! String), false, Int64(0)])
                dismissedDueToConversion = true
                ind = 0
                self.insideFolderNotes.removeAll()
                self.insideFolderNotes = self.global.DataFetch(arrayIn: self.insideFolderNotes, arrayWhole: theNotes)
                self.insideFolderFiltered = self.insideFolderNotes.filter {
                    $0[1] as! String == self.innerFolderString
                }
                collectionView.reloadData()
            }))
            al.addAction(UIAlertAction(title: "Replace", style: .destructive, handler: { (action) in
                theNotes[index] = [(theNotes[index][1] as! String), (theNotes[index][1] as! String), text, (theNotes[index][3] as! String), false, Int64(0)]
                dismissedDueToConversion = true
                ind = 0
                self.insideFolderNotes.removeAll()
                self.insideFolderNotes = self.global.DataFetch(arrayIn: self.insideFolderNotes, arrayWhole: theNotes)
                self.insideFolderFiltered = self.insideFolderNotes.filter {
                    $0[1] as! String == self.innerFolderString
                }
                collectionView.reloadData()
            }))
            al.addAction(UIAlertAction(title: "Discard", style: .cancel, handler: nil))
            DispatchQueue.main.async {
                self.present(al, animated: true, completion: nil)
            }
        }
        let move = UIAction(title: "Move", image: UIImage(systemName: "move.3d")) { action in
            var pages = Int()
            if self.insideFolderFiltered[indexPath.row][5] as! Int64 == 0 {
                let index2 = theNotes.firstIndex(where: {$0[0] as! String == self.insideFolderFiltered[indexPath.row][0] as! String && $0[1] as! String == self.insideFolderFiltered[indexPath.row][1] as! String && $0[2] as! String == self.insideFolderFiltered[indexPath.row][2] as! String && $0[3] as! String == self.insideFolderFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.insideFolderFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(0)})!
                self.goingToFoldersIndexs.append(index2)
            } else {
                pages = Int(self.insideFolderFiltered[index][5] as! Int64)
                let index2 = theNotes.firstIndex(where: {$0[0] as! String == self.insideFolderFiltered[indexPath.row][0] as! String && $0[1] as! String == self.insideFolderFiltered[indexPath.row][1] as! String && $0[2] as! String == self.insideFolderFiltered[indexPath.row][2] as! String && $0[3] as! String == self.insideFolderFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.insideFolderFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(1)})!
                self.goingToFoldersIndexs.append(index2)
                for b in 2...pages {
                    let index3 = theNotes.firstIndex(where: {$0[0] as! String == self.insideFolderFiltered[indexPath.row][0] as! String && $0[1] as! String == self.insideFolderFiltered[indexPath.row][1] as! String && $0[2] as! String == self.insideFolderFiltered[indexPath.row][2] as! String && $0[3] as! String == self.insideFolderFiltered[indexPath.row][3] as! String && $0[4] as! Bool == self.insideFolderFiltered[indexPath.row][4] as! Bool && $0[5] as! Int64 == Int64(b)})!
                    self.goingToFoldersIndexs.append(index3)
                }
            }
            self.goingToFolders = true
            self.performSegue(withIdentifier: "insideFolderMovingNotesSegue", sender: self)
        }
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [self] action in
            let format = UIGraphicsPDFRendererFormat()
            let metaData = [
                kCGPDFContextTitle: "A Note",
                kCGPDFContextAuthor: "Joshua Laurence"
              ]
            format.documentInfo = metaData as [String: Any]
            let pageRect = CGRect(x: 20, y: 0, width: 545, height: 842)
            let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
            let pdfExtension = String((theNotes[index][0] as! String) + ".pdf")
            let data = renderer.pdfData(actions: { (context) in
                context.beginPage()
                let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 30)]
                let titleAttributedString = NSAttributedString(string: theNotes[index][0] as! String, attributes: titleAttributes)
                titleAttributedString.draw(in: CGRect(x: 20, y: 0, width: 545, height: 100))
                
                var rating = String()
                if theNotes[index][3] as! String == "unrated" || theNotes[index][3] as! String == "unrated/pinned" {
                    rating = "Difficulty Level: 0"
                } else if theNotes[index][3] as! String == "green" || theNotes[index][3] as! String == "green/pinned" {
                    rating = "Difficulty Level: 1"
                } else if theNotes[index][3] as! String == "orange" || theNotes[index][3] as! String == "orange/pinned" {
                    rating = "Difficulty Level: 2"
                } else if theNotes[index][3] as! String == "red" || theNotes[index][3] as! String == "red/pinned" {
                    rating = "Difficulty Level: 3"
                }
                
                let difficultyAttributedString = NSAttributedString(string: rating, attributes: [NSAttributedString.Key.font: UIFont(name: "Futura", size: 18)])
                difficultyAttributedString.draw(in: CGRect(x: 20, y: 100, width: 545, height: 60))
                
                if theNotes[index][4] as! Bool == false {
                    var content = NSAttributedString()
                    content = TextViewerPage().handleAttributedText(PDFing: true, startingString: theNotes[ind][2] as! String)
                    content.draw(in: CGRect(x: 20, y: 175, width: 545, height: 600))
                } else {
                    let theImage = self.global.convertBase64StringToImage(imageBase64String: theNotes[index][2] as! String)
                    theImage.draw(in: CGRect(x: 50, y: 100, width: 495, height: 695))
                    
                    if theNotes[index][5] as! Int64 == 0 {
                        
                    } else {
                        var pages = [[Any]]()
                        for a in 1..<Int(insideFolderFiltered[indexPath.row][5] as! Int64) {
                            if theNotes[index + a][5] as! Int64 == 0 {
                               break
                            } else {
                                pages.append(theNotes[index + a])
                            }
                        }
                        if pages.isEmpty != true {
                            for a in 0..<pages.count {
                                let theImage = pages[a][2] as! UIImage
                                theImage.draw(in: CGRect(x: 0, y: 0, width: 595, height: 842))
                            }
                        }
                    }
                }
            })
            let PDF = PDFDocument(data: data)
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(pdfExtension)
            PDF?.write(to: url)
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
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
                self.movingIndexs[0] = Int(index)
                self.movingIndexs[1] = 0
                self.movingIndexs[2] = Bool(true)
                self.movingNotesFromSubFolders = true
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "movingNotesInBulk", sender: self)
                }
                self.checkMainButtonsActive()
            }))
            al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                for a in 0..<theNotes.count {
                    if theNotes[a][1] as! String == theFolders[index][0] as! String {
                        theNotes.remove(at: a)
                    }
                }
                theFolders.remove(at: index)
                self.subFolders.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
                collectionView.reloadData()
            }))
            if theNotes.filter({$0[1] as! String == theFolders[index][0] as! String}).count == 0 && theNotes.filter({ ($0[1] as! String).contains(theFolders[index][0] as! String)}).count == 0 {
                theFolders.remove(at: index)
                self.subFolders.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
                collectionView.reloadData()
            }
            self.present(al, animated: true, completion: nil)
        }
        let editSub = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { action in
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
                self.subFolders[indexPath.row] = newFolderName
            }))
            al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(al, animated: true, completion: nil)
        }
        var menu = UIMenu()
        if indexPath.section == numberOfSectionInt {
            if theNotes[index][4] as! Bool == false {
                menu = UIMenu(title: "", children: [delete, move, share, convertToText])
            } else {
                menu = UIMenu(title: "", children: [delete, move, share])
            }
        } else {
            menu = UIMenu(title: "", children: [deleteSub, editSub])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return menu
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        if indexPath.section == numberOfSectionInt {
            size = CGSize(width: 118, height: 150)
        } else {
            size = CGSize(width: 180, height: 55)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == numberOfSectionInt {
            if collectionViewEditing {
                selectedIndexs[indexPath.row] = false
                if selectedIndexs.filter({$0 == true}).count == 0 {
                    InsideFolderMoveButton.alpha = 0.4
                    InsideFolderMoveButton.backgroundColor = .secondaryLabel
                    InsideFolderMoveButton.setTitle("Move", for: .normal)
                    InsideFolderTrashButton.alpha = 0.4
                    InsideFolderTrashButton.backgroundColor = .secondaryLabel
                    InsideFolderTrashButton.setTitle("Trash", for: .normal)
                } else {
                    var title = "Move " + String(selectedIndexs.filter{$0 == true}.count)
                    InsideFolderMoveButton.setTitle(title, for: .normal)
                    title = "Trash " + String(selectedIndexs.filter{$0 == true}.count)
                    InsideFolderTrashButton.setTitle(title, for: .normal)
                }
            }
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnableCell = UICollectionViewCell()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        if indexPath.section == numberOfSectionInt {
            collectionView.contentSize = CGSize(width: 118, height: 150)
            let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteInFolderCVC", for: indexPath) as! InsideFolderCVCell
            Cell.InsideFolderTitle.text = (insideFolderFiltered[indexPath.row][0] as! String)
            Cell.InsideFolderCheckMark.layer.zPosition = 11
            Cell.InsideFolderCheckMarkBackgroundView.layer.zPosition = 10
            Cell.InsideFolderSelectionView.layer.zPosition = 9
            Cell.InsideFolderImageView.layer.cornerRadius = 12
            Cell.layer.cornerRadius = 15
            Cell.layer.masksToBounds = true
            Cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            Cell.InsideFolderImageView.isHidden = true
            Cell.InsideFolderImageView.isHidden = true
            Cell.InsideFolderImageView.layer.masksToBounds = true
            Cell.InsideFolderTxtNoteContentLabel.layer.cornerRadius = 15
            Cell.InsideFolderTxtNoteContentLabel.layer.masksToBounds = true
            Cell.InsideFolderShadowView.layer.zPosition = 0
            Cell.InsideFolderImageView.layer.zPosition = 1
            Cell.InsideFolderTxtNoteContentLabel.layer.zPosition = 1
            Cell.InsideFolderPageNumberShadowView.layer.zPosition = 2
            Cell.InsideFolderStruggleIconShadowView.layer.zPosition = 2
            Cell.InsideFolderPageNumber.layer.zPosition = 4
            Cell.InsideFolderDifficultyBackgroundView.layer.zPosition = 3
            Cell.InsideFolderDifficultyImageView.layer.zPosition = 4
            Cell.InsideFolderShadowView.clipsToBounds = false
            Cell.InsideFolderShadowView.layer.cornerRadius = 12
            Cell.InsideFolderShadowView.isHidden = true
            Cell.InsideFolderShadowView.layer.shadowColor = UIColor.tertiaryLabel.cgColor
            Cell.InsideFolderShadowView.layer.shadowOpacity = 1
            Cell.InsideFolderShadowView.layer.shadowOffset = CGSize.zero
            Cell.InsideFolderShadowView.layer.shadowRadius = 12
            Cell.InsideFolderShadowView.layer.shadowPath = UIBezierPath(roundedRect: Cell.InsideFolderShadowView.bounds, cornerRadius: 12).cgPath
            
            Cell.InsideFolderPageNumberShadowView.clipsToBounds = false
            Cell.InsideFolderPageNumberShadowView.layer.cornerRadius = 11
            Cell.InsideFolderPageNumberShadowView.isHidden = false
            Cell.InsideFolderPageNumberShadowView.layer.shadowColor = UIColor.black.cgColor
            Cell.InsideFolderPageNumberShadowView.layer.shadowOpacity = 1
            Cell.InsideFolderPageNumberShadowView.layer.shadowOffset = CGSize.zero
            Cell.InsideFolderPageNumberShadowView.layer.shadowRadius = 3
            Cell.InsideFolderPageNumberShadowView.layer.shadowPath = UIBezierPath(roundedRect: Cell.InsideFolderPageNumberShadowView.bounds, cornerRadius: 11).cgPath
            
            Cell.InsideFolderStruggleIconShadowView.clipsToBounds = false
            Cell.InsideFolderStruggleIconShadowView.layer.cornerRadius = 16
            Cell.InsideFolderStruggleIconShadowView.isHidden = false
            Cell.InsideFolderStruggleIconShadowView.layer.shadowColor = UIColor.black.cgColor
            Cell.InsideFolderStruggleIconShadowView.layer.shadowOpacity = 0.35
            Cell.InsideFolderStruggleIconShadowView.layer.shadowOffset = CGSize.zero
            Cell.InsideFolderStruggleIconShadowView.layer.shadowRadius = 3
            Cell.InsideFolderStruggleIconShadowView.layer.shadowPath = UIBezierPath(roundedRect: Cell.InsideFolderStruggleIconShadowView.bounds, cornerRadius: 16).cgPath
            
            if insideFolderFiltered[indexPath.row][4] as! Bool == true {
                let image = global.convertBase64StringToImage(imageBase64String: insideFolderFiltered[indexPath.row][2] as! String)
                Cell.InsideFolderImageView.layer.masksToBounds = true
                Cell.InsideFolderImageView.isHidden = false
                Cell.InsideFolderTxtNoteContentLabel.isHidden = true
                Cell.InsideFolderImageView.image = image
            } else {
                Cell.InsideFolderImageView.isHidden = true
                Cell.InsideFolderTxtNoteContentLabel.isHidden = false
                Cell.InsideFolderTxtNoteContentLabel.layer.cornerRadius = 12
                Cell.InsideFolderTxtNoteContentLabel.layer.masksToBounds = true
                Cell.InsideFolderTxtNoteContentLabel.text = String(insideFolderFiltered[indexPath.row][2] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            var rating = insideFolderFiltered[indexPath.row][3] as! String
            if (insideFolderFiltered[indexPath.row][3] as! String).contains("/") {
                rating = (insideFolderFiltered[indexPath.row][3] as! String).components(separatedBy: "/")[0]
            }
            Cell.InsideFolderTxtNoteContentLabel.backgroundColor = .systemGray5

            if rating == "unrated" {
                Cell.InsideFolderDifficultyImageView.image = UIImage(systemName: "0.circle.fill")
            } else if rating == "green" {
                Cell.InsideFolderDifficultyImageView.image = UIImage(systemName: "1.circle.fill")
            } else if rating == "orange" {
                Cell.InsideFolderDifficultyImageView.image = UIImage(systemName: "2.circle.fill")
            } else if rating == "red" {
                Cell.InsideFolderDifficultyImageView.image = UIImage(systemName: "3.circle.fill")
            }
            
            Cell.InsideFolderPageNumber.layer.masksToBounds = true
            Cell.InsideFolderPageNumber.layer.cornerRadius = 11
            if insideFolderFiltered[indexPath.row][5] as! Int64 == 0 {
                Cell.InsideFolderPageNumberShadowView.isHidden = true
                Cell.InsideFolderPageNumber.text = ""
                Cell.InsideFolderPageNumber.isHidden = true
            } else if insideFolderFiltered[indexPath.row][5] as! Int64 > 0 {
                Cell.InsideFolderPageNumberShadowView.isHidden = false
                Cell.InsideFolderPageNumber.isHidden = false
                Cell.InsideFolderPageNumber.text =  String(insideFolderFiltered[indexPath.row][5] as! Int64)
            }
            returnableCell = Cell
        } else {
            let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subFolderCell", for: indexPath) as! InsideFolderSubFolderCell
            collectionView.contentSize = CGSize(width: 236, height: 55)
            Cell.InsideFolderSubFolderCellTitle.text = (subFolders[indexPath.row]).components(separatedBy: "/")[1]
            Cell.InsideFolderSubFolderCellView.layer.cornerRadius = 16
            Cell.InsideFolderSubFolderCellView.layer.masksToBounds = true
            returnableCell = Cell
        }
        return returnableCell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insideFolderNotes.removeAll()
        insideFolderNotes = global.DataFetch(arrayIn: insideFolderNotes, arrayWhole: theNotes)
        insideFolderFiltered = insideFolderNotes.filter {
            $0[1] as! String == innerFolderString
        }
        InsideFolderPageCollectionView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if collectionViewEditing {
            InsideFolderEditButton.setTitle("Edit", for: .normal)
            collectionViewEditing = false
            UIView.animate(withDuration: 0.3, animations: {
                self.InsideFolderMoveButton.bounds = CGRect(x: 157, y: 830, width: 0, height: 42)
                self.InsideFolderTrashButton.bounds = CGRect(x: 257, y: 830, width: 0, height: 42)
            }) { (success) in
                self.InsideFolderMoveButton.isHidden = true
                self.InsideFolderMoveButton.isEnabled = false
                self.InsideFolderMoveButton.setTitle("Move", for: .normal)
                self.InsideFolderTrashButton.isHidden = true
                self.InsideFolderTrashButton.isEnabled = false
                self.InsideFolderTrashButton.setTitle("Trash", for: .normal)
            }
            InsideFolderPageCollectionView.allowsMultipleSelection = collectionViewEditing
            for a in 0..<insideFolderFiltered.count  {
                self.selectedIndexs[a] = false
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        InsideFolderPageCollectionView.reloadData()
    }
    
    @objc func movingNotes() {
        InsideFolderEditButton.setTitle("Edit", for: .normal)
        collectionViewEditing = false
        UIView.animate(withDuration: 0.3, animations: {
            self.InsideFolderMoveButton.bounds = CGRect(x: 157, y: 830, width: 0, height: 42)
            self.InsideFolderTrashButton.bounds = CGRect(x: 257, y: 830, width: 0, height: 42)
        }) { (success) in
            self.InsideFolderMoveButton.isHidden = true
            self.InsideFolderMoveButton.isEnabled = false
            self.InsideFolderMoveButton.setTitle("Move", for: .normal)
            self.InsideFolderTrashButton.isHidden = true
            self.InsideFolderTrashButton.isEnabled = false
            self.InsideFolderTrashButton.setTitle("Trash", for: .normal)
        }
        InsideFolderPageCollectionView.allowsMultipleSelection = collectionViewEditing
        for a in 0..<insideFolderFiltered.count  {
            self.selectedIndexs[a] = false
        }
        insideFolderNotes.removeAll()
        insideFolderNotes = global.DataFetch(arrayIn: insideFolderNotes, arrayWhole: theNotes)
        insideFolderFiltered = insideFolderNotes.filter {
            $0[1] as! String == innerFolderString
        }
        InsideFolderPageCollectionView.reloadData()
    }

    func checkMainButtonsActive() {
        if insideFolderFiltered.isEmpty != true  {
            InsideFolderEditButton.isEnabled = true
            InsideFolderSortButton.isEnabled = true
            InsideFolderEditButton.alpha = 1
            InsideFolderSortButton.alpha = 1
            InsideFolderEditButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
            InsideFolderSortButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        } else {
            InsideFolderEditButton.isEnabled = false
            InsideFolderSortButton.isEnabled = false
            InsideFolderEditButton.alpha = 0.4
            InsideFolderSortButton.alpha = 0.4
            InsideFolderEditButton.backgroundColor = .secondaryLabel
            InsideFolderSortButton.backgroundColor = .secondaryLabel
        }
        
        if InsideFolderSmallerPageTitle.text != "" {
            InsideFolderSubFolderButton.isHidden = true
            InsideFolderSubFolderButton.isEnabled = false
            InsideFolderSubFolderButtonLabel.isHidden = true
        } else {
            InsideFolderSubFolderButton.isHidden = false
            InsideFolderSubFolderButton.isEnabled = true
            InsideFolderSubFolderButtonLabel.isHidden = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    @IBOutlet weak var InsideFolderPageCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //InsideFolderPageCollectionView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(zoomingIntoItems)))
        NotificationCenter.default.addObserver(self, selector: #selector(movingNotes), name: NSNotification.Name("insideFolderMovingNotes"), object: nil)
        InsideFolderMoveButton.isHidden = true
        InsideFolderMoveButton.isEnabled = false
        InsideFolderTrashButton.isHidden = true
        InsideFolderTrashButton.isEnabled = false
        InsideFolderPageAddNote.tintColor = (settingsPreferances[1][1] as! UIColor)
        InsideFolderPageAddButtonLabel.textColor = (settingsPreferances[1][1] as! UIColor)
        InsideFolderMoveButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        InsideFolderSortButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        InsideFolderEditButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        InsideFolderSubFolderButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        InsideFolderSubFolderButtonLabel.textColor = (settingsPreferances[1][1] as! UIColor)
        InsideFolderMoveButton.layer.cornerRadius = 16
        InsideFolderSortButton.layer.cornerRadius = 16
        InsideFolderSortButton.setTitleColor(UIColor.systemBackground, for: .normal)
        InsideFolderEditButton.setTitleColor(UIColor.systemBackground, for: .normal)
        InsideFolderEditButton.layer.cornerRadius = 16
        InsideFolderTrashButton.layer.cornerRadius = 16
        InsideFolderPageCollectionView.allowsMultipleSelection = collectionViewEditing
        InsideFolderPageCollectionView.delegate = self
        InsideFolderPageCollectionView.dataSource = self
        InsideFolderPageCollectionView.isScrollEnabled = true
        let layout = InsideFolderPageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        
        InsideFolderPageCollectionView.collectionViewLayout = layout
        
        insideFolderNotes.removeAll()
        insideFolderNotes = global.DataFetch(arrayIn: insideFolderNotes, arrayWhole: theNotes)
        insideFolderFiltered = insideFolderNotes.filter {
            $0[1] as! String == innerFolderString
        }
        self.title = innerFolderString
        for a in 0..<insideFolderFiltered.count  {
            selectedIndexs.append(false)
        }
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        if innerFolderString.contains("/") {
            InsideFolderSmallerPageTitle.text = innerFolderString.components(separatedBy: "/")[0] + "/"
            InsideFolderPageTitle.text = innerFolderString.components(separatedBy: "/")[1]
        } else {
            InsideFolderSmallerPageTitle.text = ""
            InsideFolderPageTitle.text = innerFolderString
        }
        
        if InsideFolderSmallerPageTitle.text != "" {
            InsideFolderPageTitle.frame.origin = CGPoint(x: 20, y: 104)
        } else {
            InsideFolderPageTitle.frame.origin = CGPoint(x: 20, y: 94)
        }
        
        checkMainButtonsActive()
        // Do any additional setup after loading the view.
    }
    var selectedCell = UICollectionViewCell()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if goingToFolders {
            let vc = segue.destination as! MovingNotesPage
            vc.multiple = true
            vc.indexsForChange = goingToFoldersIndexs
            goingToFolders = false
        }
    }

}
extension UICollectionView {

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
    }
    func restoreFromEmpty() {
        self.backgroundView = nil
    }
}
