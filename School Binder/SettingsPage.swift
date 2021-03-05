//
//  SettingsPage.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
import MobileCoreServices
var settingsPreferances = [[Any]]()
class SettingsPageAccessibility: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var Fonts = ["Futura", "Optima", "Didot", "Times", "Avenir Next"]
    var FullFonts = [["Futura", "Futura-Bold", "Futura-MediumItalic"],["Optima-Regular", "Optima-Bold", "Optima-Italic"],["Didot", "Didot-Bold", "Didot-Italic"],["Times-Roman", "Times-Bold", "Times-Italic"],["AvenirNext-Regular", "AvenirNext-Bold", "AvenirNext-MediumItalic"]]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Fonts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowSize = pickerView.rowSize(forComponent: component)
        let width = rowSize.width
        let height = rowSize.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.text = Fonts[row]
        label.font = UIFont(name: Fonts[row], size: 20)
        label.textColor = .label
        label.backgroundColor = .clear
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        fontArray = FullFonts[row]
        UILabel.appearance().font = UIFont(name: Fonts[row], size: CGFloat())
        AccessibilitySampleText.font = UIFont(name: Fonts[row], size: size)
        AccessibilitySampleText.text = UILabel.appearance().font.fontName
    }
    
    var size = CGFloat(16.0)
    
    @IBAction func AccessibilityFontSizeSliderAction(_ sender: UISlider) {
//        size = CGFloat(Float(sender.value))
//        fontArray[3] = String(Float(sender.value))
//        AccessibilitySampleText.font = UIFont(name: fontArray[0], size: size)
    }
    
    @IBOutlet weak var AccessibilityFontPickerVIew: UIPickerView!
    @IBOutlet weak var AccessibilityFontSizeSlider: UISlider!
    @IBOutlet weak var AccessibilitySampleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AccessibilityFontPickerVIew.delegate = self
        AccessibilityFontPickerVIew.dataSource = self
        
//        let row = Fonts.firstIndex(of: fontArray[0])!
//
//        AccessibilityFontPickerVIew.selectRow(row, inComponent: 1, animated: false)
//        AccessibilityFontSizeSlider.value = Float(fontArray[3])!
    }
    
}

class SettingsPage: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var accentColoursString = ["Blue", "Cyan", "Green", "Yellow", "Orange", "Red", "Purple", "Pink", "Monochrome"]
    var accentColoursColours = [UIColor(named: "customBlue"), UIColor(named: "customCyan"), UIColor(named: "customGreen"), UIColor(named: "customYellow"), UIColor(named: "customOrange"), UIColor(named: "customRed"), UIColor(named: "customPurple"), UIColor(named: "customPink"), UIColor.label]
    
    var erased = false
    var imported = false
    
    @IBOutlet weak var SettingsPageAccentColourPickerView: UIPickerView!
    @IBOutlet weak var SettingsPageAccentColourPickerViewLabel: UILabel!
    
    @IBOutlet var SettingsPageLabelsToBeChanged: [UILabel]!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accentColoursString.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accentColoursString[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowSize = pickerView.rowSize(forComponent: component)
        let width = rowSize.width
        let height = rowSize.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.text = accentColoursString[row]
        label.textColor = .systemBackground
        label.backgroundColor = accentColoursColours[row]
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SettingsPageAccentColourPickerViewLabel.text = accentColoursString[row]
        settingsPreferances[1] = [accentColoursString[row], accentColoursColours[row]]
        print(settingsPreferances[1])
    }
    
    
    var global = GlobalFunctions()
    var transition = SlidingMenuTransition()
    
    @IBAction func TempSave(_ sender: UIButton) {
        global.pow()
        global.saveNotesData()
        global.saveFolderData()
        settingsPreferances[1][1] = (settingsPreferances[1][1] as! UIColor).data()
        UserDefaults.standard.set(settingsPreferances, forKey: "settingsPreferences3")
        settingsPreferances[1][1] = global.color(withData: (settingsPreferances[1][1] as! Data))!
    }
    
    @IBOutlet weak var SettingsFaceIDSwitch: UISwitch!
    @IBAction func SettingsFaceIDSwitchAction(_ sender: UISwitch) {
        global.pow()
        if sender.isOn {
            settingsPreferances[0][0] = "on"
        } else {
            settingsPreferances[0][0] = "off"
        }
    }
    
    func setUpFile() -> [String: [String: [String:Any]]] {
        var contents = [String: [String: [String:Any]]]()
        contents.updateValue([:], forKey: "Folders")
        for a in 0..<theFolders.count {
            let folderString = String("Folder " + String(a))
            contents["Folders"]?.updateValue([:], forKey: folderString)
            contents["Folders"]![folderString]?.updateValue(String(theFolders[a][0] as! String), forKey: "Title")
            contents["Folders"]![folderString]?.updateValue(String(theFolders[a][1] as! String), forKey: "Type")
            contents["Folders"]![folderString]?.updateValue(String((theFolders[a][2] as! UIColor).dataString()), forKey: "Color")
            contents["Folders"]![folderString]?.updateValue(Int(theFolders[a][3] as! Int64), forKey: "IntIndicator")
            contents["Folders"]![folderString]?.updateValue((theFolders[a][4] as! Bool), forKey: "HiddenBool")
        }
        contents.updateValue([:], forKey: "Notes")
        for b in 0..<theNotes.count {
            let noteString = String("Note " + String(b))
            contents["Notes"]?.updateValue([:], forKey: noteString)
            contents["Notes"]![noteString]?.updateValue(String(theNotes[b][0] as! String), forKey: "Title")
            contents["Notes"]![noteString]?.updateValue(String(theNotes[b][1] as! String), forKey: "Tag")
            contents["Notes"]![noteString]?.updateValue(String(theNotes[b][2] as! String), forKey: "Contents")
            contents["Notes"]![noteString]?.updateValue(String(theNotes[b][3] as! String), forKey: "StruggleRating")
            contents["Notes"]![noteString]?.updateValue(Int(theNotes[b][5] as! Int64), forKey: "PageNumber")
            contents["Notes"]![noteString]?.updateValue((theNotes[b][4] as! Bool), forKey: "IsText")
        }
        contents.updateValue([:], forKey: "Trash")
        for c in 0..<temporarilyDeleted.count {
            let trashString = String("Trash Note " + String(c))
            contents["Trash"]?.updateValue([:], forKey: trashString)
            contents["Trash"]![trashString]?.updateValue(String(temporarilyDeleted[c][0][0] as! String), forKey: "Title")
            contents["Trash"]![trashString]?.updateValue(String(temporarilyDeleted[c][0][1] as! String), forKey: "Tag")
            contents["Trash"]![trashString]?.updateValue(String(temporarilyDeleted[c][0][2] as! String), forKey: "Contents")
            contents["Trash"]![trashString]?.updateValue(String(temporarilyDeleted[c][0][3] as! String), forKey: "StruggleRating")
            contents["Trash"]![trashString]?.updateValue(Int(temporarilyDeleted[c][0][5] as! Int64), forKey: "PageNumber")
            contents["Trash"]![trashString]?.updateValue((temporarilyDeleted[c][0][4] as! Bool), forKey: "IsText")
            print(temporarilyDeleted[c][1][0])
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let dateString = df.string(from: temporarilyDeleted[c][1][0] as! Date)
            print(dateString)
            contents["Trash"]![trashString]?.updateValue(dateString, forKey: "DeletionDate")
        }
        return contents
    }
    
    @IBOutlet weak var SettingsClearAllDataButton: UIButton!
    @IBAction func SettingsClearAllDataButtonAction(_ sender: UIButton) {
        let al = UIAlertController(title: "Clear All Data", message: "Once this actions is performed it CANNOT BE UN-DONE. Unless notes are backed up, ALL NOTES & FOLDERS WILL BE LOST", preferredStyle: .actionSheet)
        al.addAction(UIAlertAction(title: "Erase", style: .destructive, handler: { (action) in
            theFolders.removeAll()
            theNotes.removeAll()
            temporarilyDeleted.removeAll()
            NotificationCenter.default.post(name: NSNotification.Name("reloadHomeTV"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("reloadStrugglingTV"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("reloadAllNotesTV"), object: self)
            self.erased = true
            self.successAlert(titleString: "Successfully Erased", messageString: "All Notes and Folders were successfully erased")
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(al, animated: true, completion: nil)
    }
    
    @IBOutlet weak var SettingsExportButtonActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SettingsExportButton: UIButton!
    @IBAction func SettingsExportButtonAction(_ sender: UIButton) {
        SettingsExportButtonActivityIndicator.startAnimating()
        let backupFile = "Backup.rnb"
        var content = [String: [String: [String:Any]]]()
        content = setUpFile()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("Document")
            let fileURL = dir.appendingPathComponent(backupFile)
            do {
                print("Writing")
                try JSONSerialization.data(withJSONObject: content).write(to: fileURL)
                let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                SettingsExportButtonActivityIndicator.stopAnimating()
                self.present(activityVC, animated: true, completion: nil)
            }
            catch { print("We are having a problem, it being \(error)") }
        }
    }
    
    @IBOutlet weak var SettingsImportButton: UIButton!
    @IBAction func SettingsImportButtonAction(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.Joshua-Laurence.School-Binder.RNB"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .automatic
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var SettingsHapticFeedbackButton: UISwitch!
    @IBAction func SettingsHapticFeedbackButtonAction(_ sender: UISwitch) {
        if sender.isOn {
            let pow = UIImpactFeedbackGenerator(style: .medium)
            pow.prepare()
            pow.impactOccurred()
            settingsPreferances[3][0] = "on"
        } else {
            settingsPreferances[3][0] = "off"
        }
    }
    
    @IBOutlet weak var SettingsSaveToPhotosSwitch2: UISwitch!
    @IBAction func SettingsSaveToPhotosSwitchAction2(_ sender: UISwitch) {
        global.pow()
        if sender.isOn {
            settingsPreferances[2][0] = "on"
        } else {
            settingsPreferances[2][0] = "off"
        }
    }
    
    let menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Menu") as! MenuPage
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if erased || imported {
            
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("changeHomeButtonColours"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("changeTrashButtonColours"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("changeDifficultyButtonColours"), object: self)
        }
        NotificationCenter.default.post(name: NSNotification.Name("changeMenuImageColours"), object: self)
        NotificationCenter.default.post(name: NSNotification.Name("changeSearchButtonColours"), object: self)
        erased = false
        imported = false
        UINavigationBar.appearance().tintColor = (settingsPreferances[1][1] as! UIColor)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsExportButtonActivityIndicator.hidesWhenStopped = true
        SettingsExportButtonActivityIndicator.color = .white
        SettingsExportButtonActivityIndicator.tintColor = .white
        SettingsExportButton.layer.cornerRadius = 12
        SettingsImportButton.layer.cornerRadius = 12
        SettingsClearAllDataButton.layer.cornerRadius = 12
        SettingsPageAccentColourPickerView.delegate = self
        SettingsPageAccentColourPickerView.dataSource = self
        if settingsPreferances[0][0] as! String == "on" {
            SettingsFaceIDSwitch.setOn(true, animated: false)
        } else {
            SettingsFaceIDSwitch.setOn(false, animated: false)
        }
        
        if settingsPreferances[2][0] as! String == "on" {
            SettingsSaveToPhotosSwitch2.setOn(true, animated: true)
        } else {
            SettingsSaveToPhotosSwitch2.setOn(false, animated: true)
        }
        if settingsPreferances[3][0] as! String == "on" {
            SettingsHapticFeedbackButton.setOn(true, animated: true)
        } else {
            SettingsHapticFeedbackButton.setOn(false, animated: true)
        }
        SettingsPageAccentColourPickerViewLabel.text = (settingsPreferances[1][0] as! String)
        let index = accentColoursString.firstIndex(of: settingsPreferances[1][0] as! String)!
        SettingsPageAccentColourPickerView.selectRow(index, inComponent: 0, animated: true)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
extension SettingsPage: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

extension SettingsPage: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let selectedPath = urls.first
        print(selectedPath)
        let dir =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let theFilePath = dir.appendingPathComponent(selectedPath!.lastPathComponent)
        print(theFilePath.path)
        var contents = Data()
        do {
            clearTempFolder()
            try FileManager.default.copyItem(at: selectedPath!, to: theFilePath)
            contents = try! Data(contentsOf: theFilePath, options: .mappedIfSafe)
            let contentsDict = try! JSONSerialization.jsonObject(with: contents, options: .mutableLeaves) as! [String: [String: [String: Any]]]
            let notes = contentsDict["Notes"]!
            let folders = contentsDict["Folders"]!
            let trash = contentsDict["Trash"]!
            alertForImporting(notes: notes, folders: folders, trash: trash)
            imported = true
        } catch {
            print("Error \(error)")
        }
    }
    
    func clearTempFolder() {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        print(documents!.path)
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: documents!.path)
            print(filePaths)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: documents!.path + "/" + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func alertForImporting(notes: [String: [String:Any]], folders: [String: [String:Any]], trash: [String: [String:Any]]) {
        let al = UIAlertController(title: "Import File", message: "Would you like to merge the notes in this with your current notes?, Replace your existing notes with the ones in this file?, or Cancel the operation?", preferredStyle: .alert)
        al.addAction(UIAlertAction(title: "Merge Notes", style: .default, handler: { (action) in
            self.handleStringFromFile(notes: notes, folders: folders, trash: trash, replace: false)
            NotificationCenter.default.post(name: NSNotification.Name("reloadHomeTV"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("reloadStrugglingTV"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("reloadAllNotesTV"), object: self)
            self.successAlert(titleString: "Successfully Imported", messageString: "The Notes and Folders from this file were successfully Imported")
        }))
        al.addAction(UIAlertAction(title: "Replace Notes", style: .destructive, handler: { (action) in
            self.handleStringFromFile(notes: notes, folders: folders, trash: trash, replace: true)
            NotificationCenter.default.post(name: NSNotification.Name("reloadHomeTV"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("reloadStrugglingTV"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("reloadAllNotesTV"), object: self)
            self.successAlert(titleString: "Successfully Imported", messageString: "The Notes and Folders from this file were successfully Imported")
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(al, animated: true, completion: nil)
        
    }
    
    func successAlert(titleString: String, messageString: String) {
        let al2 = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        al2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(al2, animated: true, completion: nil)
        }
    }
    
    func handleStringFromFile(notes: [String: [String:Any]], folders: [String: [String:Any]], trash: [String: [String:Any]], replace: Bool) {
        if replace {
            theFolders.removeAll()
            theNotes.removeAll()
            temporarilyDeleted.removeAll()
        }
        for a in 0..<folders.count {
            let folderString = String("Folder " + String(a))
            let title = folders[folderString]!["Title"] as! String
            let type = folders[folderString]!["Type"] as! String
            let color = global.colorString(withCodedString: String(folders[folderString]!["Color"] as! String))!
            let intIndicator = Int64(folders[folderString]!["IntIndicator"] as! Int)
            let hiddenBool = folders[folderString]!["HiddenBool"] as! Bool
            let contains = theFolders.contains { $0[0] as! String == title && $0[1] as! String == type && $0[2] as! UIColor == color && $0[3] as! Int64 == intIndicator && $0[4] as? Bool == hiddenBool}
            if contains == false {
                theFolders.append([title, type, color, intIndicator, hiddenBool])
            }
        }
        for b in 0..<notes.count {
            let noteString = String("Note " + String(b))
            let title = notes[noteString]!["Title"] as! String
            let tag = notes[noteString]!["Tag"] as! String
            let contents = notes[noteString]!["Contents"] as! String
            let struggleRating = notes[noteString]!["StruggleRating"] as! String
            let pageNumber = Int64(notes[noteString]!["PageNumber"] as! Int)
            let isText = notes[noteString]!["IsText"] as! Bool
            let contains = theFolders.contains { $0[0] as! String == title && $0[1] as! String == tag && $0[2] as! String == contents && $0[3] as! String == struggleRating && $0[5] as! Int64 == pageNumber && $0[4] as! Bool == isText}
            if contains == false {
                theNotes.append([title, tag, contents, struggleRating, isText, pageNumber])
            }
        }
        for c in 0..<trash.count {
            let trashString = String("Trash Note " + String(c))
            let title = trash[trashString]!["Title"] as! String
            let tag = trash[trashString]!["Tag"] as! String
            let contents = trash[trashString]!["Contents"] as! String
            let struggleRating = trash[trashString]!["StruggleRating"] as! String
            let pageNumber = Int64(trash[trashString]!["PageNumber"] as! Int)
            let isText = trash[trashString]!["IsText"] as! Bool
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let deletionDate = df.date(from: trash[trashString]!["DeletionDate"] as! String)
            let contains = temporarilyDeleted.contains { $0[0][0] as! String == title && $0[0][1] as! String == tag && $0[0][2] as! String == contents && $0[0][3] as! String == struggleRating && $0[0][5] as! Int64 == pageNumber && $0[0][4] as! Bool == isText && $0[1][0] as? Date == deletionDate}
            if contains == false {
                temporarilyDeleted.append([[title, tag, contents, struggleRating, isText, pageNumber], [deletionDate!]])
            }
        }
    }
    
}

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}

extension UILabel{
    @objc var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont.systemFont(ofSize: self.font.pointSize) }
    }
}
