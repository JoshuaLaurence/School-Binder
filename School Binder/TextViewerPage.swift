//
//  TextViewerPage.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
import PDFKit

var fontArray = ["Futura", "Futura-Bold", "Futura-MediumItalic", "15.0"]

class TextViewerPage: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var global = GlobalFunctions()
    var struggle = String()
    var editingIndex = 0
    
    @IBOutlet weak var TextViewerMoveButton: UIButton!
    @IBAction func TextViewerMoveButtonAction(_ sender: UIButton) {
        global.pow()
        isNotInSearch = true
    }
    
    @IBOutlet weak var TextViewerOccasionalDismissButton: UIButton!
    @IBAction func TextViewerOccasionalDismissButtonAction(_ sender: UIButton) {
        global.pow()
        NotificationCenter.default.post(name: NSNotification.Name("reloadAllNotesTV"), object: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TextViewerDeleteButtonAction(_ sender: UIButton) {
        global.pow()
        let now = Date()
        let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
        temporarilyDeleted.append([theNotes[ind],[noteDate!]])
        theNotes.remove(at: ind)
        ind = 0
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var TextViewerDeleteButton: UIButton!
    @IBAction func TextViewerStruggleSegContAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            global.pow()
            struggle = "unrated"
            if (theNotes[ind][3] as! String).contains("/") {
                struggle = "unrated/pinned"
            }
            break
        case 1:
            global.pow()
            struggle = "green"
            if (theNotes[ind][3] as! String).contains("/") {
                struggle = "green/pinned"
            }
            break
        case 2:
            global.pow()
            struggle = "orange"
            if (theNotes[ind][3] as! String).contains("/") {
                struggle = "orange/pinned"
            }
            break
        case 3:
            global.pow()
            struggle = "red"
            if (theNotes[ind][3] as! String).contains("/") {
                struggle = "red/pinned"
            }
            break
        default:
            struggle = "unrated"
            if (theNotes[ind][3] as! String).contains("/") {
                struggle = "unrated/pinned"
            }
            break
        }
    }
    @IBOutlet weak var TextViewerStruggleSegCont: UISegmentedControl!
    @IBAction func TextViewerEditButtonAction(_ sender: UIButton) {
        global.pow()
        if editingIndex % 2 == 0 {
            TextViewerEditButton.setTitle("Done", for: .normal)
            TextViewerTitleTxtField.isUserInteractionEnabled = true
            TextViewerTitleTxtField.clearButtonMode = .always
            TextViewerDeleteButton.isHidden = false
            TextViewerDeleteButton.isEnabled = true
            TextViewerMoveButton.isHidden = false
            TextViewerMoveButton.isEnabled = true
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.TextViewerDeleteButton.bounds = CGRect(x: 161, y: 820, width: 92, height: 42)
                self.TextViewerMoveButton.bounds = CGRect(x: 106, y: 775, width: 168, height: 37)
            }, completion: nil)
            editingIndex += 1
        } else {
            TextViewerEditButton.setTitle("Edit", for: .normal)
            TextViewerTitleTxtField.isUserInteractionEnabled = true
            TextViewerTitleTxtField.clearButtonMode = .never
            UIView.animate(withDuration: 0.3, animations: {
                self.TextViewerDeleteButton.bounds = CGRect(x: 202, y: 820, width: 0, height: 42)
                self.TextViewerMoveButton.bounds = CGRect(x: 202, y: 775, width: 0, height: 37)
            }) { (success) in
                self.TextViewerDeleteButton.isHidden = true
                self.TextViewerDeleteButton.isEnabled = false
                self.TextViewerMoveButton.isHidden = true
                self.TextViewerMoveButton.isEnabled = false
            }
            editingIndex += 1
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.TextViewerTitleTxtField.endEditing(true)
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.TextViewerTxtView.frame = CGRect(x: self.TextViewerTxtView.frame.origin.x, y: self.TextViewerTxtView.frame.origin.y, width: self.TextViewerTxtView.frame.width, height: 330)
        }, completion: nil)
        TextViewerTxtView.isScrollEnabled = true
    }
    func retrieveOtherLetters(key: String, currentIndex: Int, textArray: [String]) -> Bool {
        var tempArray = [String]()
        var anotherKeyPresent = Bool()
        for b in currentIndex + 1..<textArray.count {
            tempArray.append(textArray[b])
        }
        if tempArray.filter({ $0 == key }).count != 0 {
            anotherKeyPresent = true
        } else {
            anotherKeyPresent = false
        }
        return anotherKeyPresent
    }
    func handleAttributedText(PDFing: Bool, startingString: String) -> NSAttributedString {
        if startingString.contains("*") || startingString.contains("/") || startingString.contains("_") || startingString.contains("=") || startingString.contains("~") {
            var splitText = Array(startingString.map({ String($0) }))
            var boldAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.label]
            var italicAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.label]
            var underlineAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.label] as [NSAttributedString.Key : Any]
            var strikethroughAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
            var highlightAttribute = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.backgroundColor: (settingsPreferances[1][1] as! UIColor).withAlphaComponent(0.3)]
            var regularAtttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.label]
            if PDFing {
                boldAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.black]
                italicAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.black]
                underlineAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key : Any]
                strikethroughAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
                highlightAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.backgroundColor: (settingsPreferances[1][1] as! UIColor).withAlphaComponent(0.3)]
                regularAtttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.black]
            }
            let keyAttribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
            let numberOfBoldLoops = floor(Double(splitText.filter({$0 == "*"}).count / 2))
            let numberOfItalicLoops = floor(Double(splitText.filter({$0 == "/"}).count / 2))
            let numberOfUnderlineLoops = floor(Double(splitText.filter({$0 == "_"}).count / 2))
            let numberOfHighlightLoops = floor(Double(splitText.filter({$0 == "~"}).count / 2))
            let numberOfStrikethroughLoops = floor(Double(splitText.filter({$0 == "="}).count / 2))
            var inBetweenKeys = false
            var key = String()
            var contentString = NSMutableAttributedString()
            if numberOfBoldLoops != 0 || numberOfItalicLoops != 0 || numberOfUnderlineLoops != 0 || numberOfStrikethroughLoops != 0 || numberOfHighlightLoops != 0 {
                for a in 0..<splitText.count {
                    if (splitText[a] == "*" && inBetweenKeys == true) || (splitText[a] == "/" && inBetweenKeys == true) || (splitText[a] == "_" && inBetweenKeys == true) || (splitText[a] == "=" && inBetweenKeys == true) || (splitText[a] == "~" && inBetweenKeys == true) {
                        contentString.append(NSAttributedString(string: splitText[a], attributes: keyAttribute as [NSAttributedString.Key : Any]))
                        inBetweenKeys = false
                        key = String()
                    } else if (splitText[a] == "*" && inBetweenKeys == false) || (splitText[a] == "/" && inBetweenKeys == false) || (splitText[a] == "_" && inBetweenKeys == false) || (splitText[a] == "=" && inBetweenKeys == false) || (splitText[a] == "~" && inBetweenKeys == false){
                        key = splitText[a]
                        if retrieveOtherLetters(key: key, currentIndex: a, textArray: splitText) == true {
                            inBetweenKeys = true
                            contentString.append(NSAttributedString(string: splitText[a], attributes: keyAttribute as [NSAttributedString.Key : Any]))
                        } else {
                            contentString.append(NSAttributedString(string: splitText[a], attributes: regularAtttribute as [NSAttributedString.Key : Any]))
                        }
                    }  else if splitText[a] != "*" && splitText[a] != "/" && splitText[a] != "_" && splitText[a] != "=" && splitText[a] != "~" && inBetweenKeys == true {
                        if key == "*" {
                            contentString.append(NSAttributedString(string: splitText[a], attributes: boldAttribute as [NSAttributedString.Key : Any]))
                        } else if key == "/" {
                            contentString.append(NSAttributedString(string: splitText[a], attributes: italicAttribute as [NSAttributedString.Key : Any]))
                        } else if key == "_" {
                            contentString.append(NSAttributedString(string: splitText[a], attributes: underlineAttribute as [NSAttributedString.Key : Any]))
                        } else if key == "=" {
                            contentString.append(NSAttributedString(string: splitText[a], attributes: strikethroughAttribute as [NSAttributedString.Key : Any]))
                        } else if key == "~" {
                            contentString.append(NSAttributedString(string: splitText[a], attributes: highlightAttribute as [NSAttributedString.Key : Any]))
                        }
                    } else if splitText[a] != "*" && splitText[a] != "/" && splitText[a] != "_" && splitText[a] != "=" && splitText[a] != "~" && inBetweenKeys == false {
                        contentString.append(NSAttributedString(string: splitText[a], attributes: regularAtttribute as [NSAttributedString.Key : Any]))
                    }
                }
            } else {
                for c in 0..<splitText.count {
                    contentString.append(NSAttributedString(string: splitText[c], attributes: regularAtttribute as [NSAttributedString.Key : Any]))
                }
            }
            return contentString
        } else {
            var normalString = NSAttributedString()
            if PDFing {
                normalString = NSAttributedString(string: startingString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.black])
            } else {
                normalString = NSAttributedString(string: startingString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.label])
            }
            return normalString
        }
        return NSAttributedString()
    }
    func textViewDidChange(_ textView: UITextView) {
        var cursorPosition = Int()
        if let selectedRange = TextViewerTxtView.selectedTextRange {
            cursorPosition = TextViewerTxtView.offset(from: TextViewerTxtView.beginningOfDocument, to: selectedRange.start)
        }
        let scrollPosition = TextViewerTxtView.contentOffset.y
        print(scrollPosition)
        
        TextViewerTxtView.isScrollEnabled = false
        TextViewerTxtView.attributedText = handleAttributedText(PDFing: false, startingString: TextViewerTxtView.text)
        
        if let newPosition = TextViewerTxtView.position(from: TextViewerTxtView.beginningOfDocument, offset: cursorPosition) {
            TextViewerTxtView.selectedTextRange = TextViewerTxtView.textRange(from: newPosition, to: newPosition)
        }
        
        print(TextViewerTxtView.contentOffset.y)
        TextViewerTxtView.contentOffset.y = scrollPosition
        print(scrollPosition)
        print(TextViewerTxtView.contentOffset.y)
        
        TextViewerTxtView.isScrollEnabled = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.TextViewerTxtView.frame = CGRect(x: self.TextViewerTxtView.frame.origin.x, y: self.TextViewerTxtView.frame.origin.y, width: self.TextViewerTxtView.frame.width, height: 551)
        }, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.TextViewerTitleTxtField.endEditing(true)
        self.TextViewerTxtView.endEditing(true)
    }
    @IBOutlet weak var TextViewerEditButton: UIButton!
    @IBAction func TextViewerBackButtonAction(_ sender: UIButton) {
        global.pow()
        print("Back")
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var TextViewerTitleTxtField: UITextField!
    @IBOutlet weak var TextViewerExportButton: UIButton!
    @IBAction func TextViewerExportButtonAction(_ sender: UIButton) {
        global.pow()
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [
            kCGPDFContextTitle: "A Note",
            kCGPDFContextAuthor: "Joshua Laurence"
          ]
        format.documentInfo = metaData as [String: Any]
        let pageRect = CGRect(x: 20, y: 0, width: 545, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let pdfExtension = String((theNotes[ind][0] as! String) + ".pdf")
        let data = renderer.pdfData(actions: { (context) in
            context.beginPage()
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: fontArray[1], size: 30)]
            let titleAttributedString = NSAttributedString(string: theNotes[ind][0] as! String, attributes: titleAttributes as [NSAttributedString.Key : Any])
            titleAttributedString.draw(in: CGRect(x: 20, y: 0, width: 545, height: 100))
            
            var rating = String()
            if theNotes[ind][3] as! String == "unrated" || theNotes[ind][3] as! String == "unrated/pinned" {
                rating = "Difficulty Level: 0"
            } else if theNotes[ind][3] as! String == "green" || theNotes[ind][3] as! String == "green/pinned" {
                rating = "Difficulty Level: 1"
            } else if theNotes[ind][3] as! String == "orange" || theNotes[ind][3] as! String == "orange/pinned" {
                rating = "Difficulty Level: 2"
            } else if theNotes[ind][3] as! String == "red" || theNotes[ind][3] as! String == "red/pinned" {
                rating = "Difficulty Level: 3"
            }
            
            let difficulty = NSAttributedString(string: rating, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)])
            difficulty.draw(in: CGRect(x: 20, y: 100, width: 545, height: 60))
            
            var content = NSAttributedString()
            content = handleAttributedText(PDFing: true, startingString: TextViewerTxtView.text)
            content.draw(in: CGRect(x: 20, y: 175, width: 545, height: 600))
        })
        let PDF = PDFDocument(data: data)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(pdfExtension)
        PDF?.write(to: url)
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    @IBOutlet weak var TextViewerTagsLabel: UILabel!
    @IBOutlet weak var TextViewerTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextViewerMoveButton.layer.cornerRadius = 16
        
        TextViewerEditButton.setTitleColor((settingsPreferances[1][1] as! UIColor), for: .normal)
        TextViewerExportButton.setTitleColor((settingsPreferances[1][1] as! UIColor), for: .normal)
        TextViewerOccasionalDismissButton.setTitleColor((settingsPreferances[1][1] as! UIColor), for: .normal)
        TextViewerOccasionalDismissButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        TextViewerMoveButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        TextViewerTitleTxtField.delegate = self
        TextViewerTxtView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTextViewerTagLabel), name: NSNotification.Name("reloadTextViewerTagLabel"), object: nil)
        
        var rating = theNotes[ind][3] as! String
        if (theNotes[ind][3] as! String).contains("/") {
            rating = (theNotes[ind][3] as! String).components(separatedBy: "/")[0]
        }
        if rating == "unrated" {
            TextViewerStruggleSegCont.selectedSegmentIndex = 0
        } else if rating == "green" {
            TextViewerStruggleSegCont.selectedSegmentIndex = 1
        } else if rating == "orange" {
            TextViewerStruggleSegCont.selectedSegmentIndex = 2
        } else if rating == "red" {
            TextViewerStruggleSegCont.selectedSegmentIndex = 3
        }
        struggle = theNotes[ind][3] as! String
        
        TextViewerTitleTxtField.isUserInteractionEnabled = false
        TextViewerTitleTxtField.text = (theNotes[ind][0] as! String)
        
        TextViewerTxtView.attributedText = NSAttributedString(string: (theNotes[ind][2] as! String), attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.label])
        TextViewerTxtView.isScrollEnabled = false
        TextViewerTxtView.attributedText = handleAttributedText(PDFing: false, startingString: theNotes[ind][2] as! String)
        TextViewerTxtView.isScrollEnabled = true
        
//        handleAttributedText(key: "_", attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.thick.rawValue])
//        handleAttributedText(key: "/", attributes: [NSAttributedString.Key.font : UIFont(name: "Futura-MediumItalic", size: CGFloat(Float(fontArray[3] as! String)!))! as Any])
        
        
        TextViewerTagsLabel.text = "🗂" + String(theNotes[ind][1] as! String)
        TextViewerDeleteButton.isHidden = true
        TextViewerDeleteButton.isEnabled = false
        TextViewerDeleteButton.layer.cornerRadius = 16
        // Do any additional setup after loading the view.
    }
    @objc func reloadTextViewerTagLabel() {
        DispatchQueue.main.async {
            self.TextViewerTagsLabel.text = (theNotes[ind][1] as! String)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Disappearing...")
        print("Parenting...")
        if TextViewerEditButton.titleLabel!.text == "Done" {
            TextViewerEditButton.setTitle("Edit", for: .normal)
            TextViewerTitleTxtField.isUserInteractionEnabled = true
            TextViewerTitleTxtField.clearButtonMode = .never
            UIView.animate(withDuration: 0.3, animations: {
                self.TextViewerDeleteButton.bounds = CGRect(x: 202, y: 820, width: 0, height: 42)
                self.TextViewerMoveButton.bounds = CGRect(x: 214, y: 775, width: 0, height: 37)
            }) { (success) in
                self.TextViewerDeleteButton.isHidden = true
                self.TextViewerDeleteButton.isEnabled = false
                self.TextViewerMoveButton.isHidden = true
                self.TextViewerMoveButton.isEnabled = false
            }
            editingIndex += 1
        }
        let tag = String((TextViewerTagsLabel.text?.dropFirst())!)
        theNotes[ind] = [TextViewerTitleTxtField.text!, tag, TextViewerTxtView.text!, struggle, false, Int64(0)]
        ind = 0
        previouslyDimissed = true
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
