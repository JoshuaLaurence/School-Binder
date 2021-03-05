//
//  ImageViewerPage.swift
//  School Binder
//
//  Created by Joshua Laurence on 21/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
import PDFKit
import VisionKit
import SwiftUI
import Vision
var zoomedImageDismissed = false
var dismissedDueToConversion = false
var goingHome = false
class ImageViewerPage: UIViewController, UITextFieldDelegate, UIDocumentBrowserViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, VNDocumentCameraViewControllerDelegate, UINavigationControllerDelegate {
    
    var pageIndex = Int()
    var pages = [[Any]]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewerCVC", for: indexPath) as! ImageViewerCVCell
        Cell.ImageViewerCVCellShadowView.layer.zPosition = 0
        Cell.ImageViewerCVCellImageView.layer.zPosition = 1
        Cell.ImageViewerCVCellImageView.layer.cornerRadius = 8
        Cell.ImageViewerCVCellShadowView.layer.cornerRadius = 8
        Cell.ImageViewerCVCellImageView.image = global.convertBase64StringToImage(imageBase64String: pages[indexPath.row][2] as! String)
        return Cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pageIndex = indexPath.row
        ImageViewerDeleteButton.setTitle(String("Delete Pg" + String(pageIndex)), for: .normal)
        ImageViewerImageView.image = global.convertBase64StringToImage(imageBase64String: pages[indexPath.row][2] as! String)
    }
    public var documentData: Data?
    
    @IBOutlet weak var ImageViewerPageCollectionView: UICollectionView!

    var global = GlobalFunctions()
    var editingIndex = 0
    var struggle = String()
    
    
    @IBOutlet weak var ImageViewerOccasionalDismissButton: UIButton!
    @IBAction func ImageViewerOccasionalDismissButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var ImageViewerToTextButton: UIBarButtonItem!
    var imageText = String()
    @IBAction func ImageViewerToTextButtonAction(_ sender: UIBarButtonItem) {
        var text = String()
        let al = UIAlertController(title: "Text", message: text, preferredStyle: .alert)
        al.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
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
            self.imageText = text
            NotificationCenter.default.post(name: NSNotification.Name("imageTextHandling"), object: self)
        }
        
        request.recognitionLevel = .accurate
        let requests = [request]
        let image = ImageViewerImageView.image?.cgImage
        DispatchQueue.global(qos: .userInitiated).async {
            guard let img = image else {
                fatalError("Missing image to scan")
            }

            let handler = VNImageRequestHandler(cgImage: img, options: [:])
            try? handler.perform(requests)
        }
    }
    
    @objc func handlingImageText() {
        print("Handling...")
        let al = UIAlertController(title: "Converted To Text", message: "Would you like to save the text as a seperate note, replace the current image with the text or discard?", preferredStyle: .alert)
        let tag = self.ImageViewerTagsLabel.text?.dropFirst()
        print(tag)
        al.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            theNotes.append([self.ImageViewerTitleTxtField.text!, String(tag!), self.imageText, self.struggle, false, Int64(0)])
            self.imageText = String()
            ind = 0
        }))
        al.addAction(UIAlertAction(title: "Replace", style: .destructive, handler: { (action) in
            theNotes.remove(at: ind)
            theNotes.insert([self.ImageViewerTitleTxtField.text!, String(tag!), self.imageText, self.struggle, false, Int64(0)], at: ind)
            self.imageText = String()
            dismissedDueToConversion = true
            ind = 0
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "InsideFolder") as! InsideFolderPage
            self.navigationController?.popViewController(animated: true)
        }))
        al.addAction(UIAlertAction(title: "Discard", style: .cancel, handler: { (action) in
            self.imageText = String()
        }))
        DispatchQueue.main.async {
            self.present(al, animated: true, completion: nil)
        }
    }
    func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBOutlet weak var ImageViewerMoveButton: UIButton!
    @IBAction func ImageViewMovButtonAction(_ sender: UIButton) {
        global.pow()
        isNotInSearch = true
    }
    
    @IBAction func ImageViewerDeleteButtonAction(_ sender: UIButton) {
        global.pow()
        if pages.isEmpty {
            let now = Date()
            let noteDate = Calendar.current.date(byAdding: .day, value: 7, to: now)
            temporarilyDeleted.append([theNotes[ind],[noteDate!]])
            theNotes.remove(at: ind)
            self.dismiss(animated: true, completion: nil)
        } else {
            let al = UIAlertController(title: "Are you sure you want to delete page \(pageIndex + 1)", message: "This page will be deleted perminatley", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            al.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                if (self.pages.count - 1) == 1 {
                    self.pages.removeAll()
                    theNotes.remove(at: ind + self.pageIndex)
                    theNotes[ind][5] = Int64(0)
                    self.ImageViewerImageView.image = self.global.convertBase64StringToImage(imageBase64String: theNotes[ind][2] as! String)
                    self.fetchPages()
                    self.ImageViewerDeleteButton.setTitle("Trash", for: .normal)
                } else {
                    self.pages.remove(at: self.pageIndex)
                    theNotes.remove(at: ind + self.pageIndex)
                    if self.pageIndex == 0 {
                        self.ImageViewerImageView.image = self.global.convertBase64StringToImage(imageBase64String: self.pages[self.pageIndex][2] as! String)
                        let selectedIndex = self.ImageViewerPageCollectionView.indexPathsForSelectedItems?.first?.item
                        self.ImageViewerPageCollectionView.reloadData()
                        self.ImageViewerPageCollectionView.selectItem(at: IndexPath(item: Int(selectedIndex! + 1), section: 0), animated: true, scrollPosition: .left)
                    } else {
                        self.ImageViewerImageView.image = self.global.convertBase64StringToImage(imageBase64String: self.pages[self.pageIndex - 1][2] as! String)
                        let selectedIndex = self.ImageViewerPageCollectionView.indexPathsForSelectedItems?.first?.item
                        self.ImageViewerPageCollectionView.reloadData()
                        self.ImageViewerPageCollectionView.selectItem(at: IndexPath(item: Int(selectedIndex! - 1), section: 0), animated: true, scrollPosition: .left)
                    }
                }
            }))
            present(al, animated: true, completion: nil)
        }
        ImageViewerEditButton.setTitle("Edit", for: .normal)
        ImageViewerTitleTxtField.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.ImageViewerDeleteButton.bounds = CGRect(x: 202, y: 820, width: 0, height: 42)
            self.ImageViewerMoveButton.bounds = CGRect(x: 310, y: 771, width: 0, height: 37)
            self.ImageViewerAddPagesButton.transform = .identity
        }) { (success) in
            self.ImageViewerDeleteButton.isHidden = true
            self.ImageViewerDeleteButton.isEnabled = false
            self.ImageViewerMoveButton.isHidden = true
            self.ImageViewerMoveButton.isEnabled = false
        }
        editingIndex += 1
    }
    @IBAction func ImageViewerAddPagesButtonAction(_ sender: UIButton) {
        global.pow()
        let al = UIAlertController(title: "Add Pages", message: "", preferredStyle: .actionSheet)
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
            self.ImageViewerPageCollectionView.reloadData()
            self.ImageViewerPageCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
            self.ImageViewerDeleteButton.setTitle("Delete", for: .normal)
        }))
        al.addAction(UIAlertAction(title: "Image From Photo Library", style: .default, handler: { (action) in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = true
            self.present(image, animated: true) {
                
            }
        }))
        al.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(al, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let img = self.global.convertImageToBase64String(img: image)
            if pages.isEmpty {
                theNotes[ind][5] = Int64(1)
                theNotes.insert([ImageViewerTitleTxtField.text!, ImageViewerTagsLabel.text!, img, struggle, true, Int64(2)], at: ind + 1)
            } else {
                let index = Int(pages.last![5] as! Int64)
                theNotes.insert([ImageViewerTitleTxtField.text!, ImageViewerTagsLabel.text!, img, struggle, true, Int64(index + 1)], at: ind + index)
            }
            DispatchQueue.main.async {
                self.ImageViewerPageCollectionView.reloadData()
                self.ImageViewerPageCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
            }
        } else {
            
        }
        fetchPages()
        self.dismiss(animated: true, completion: nil)
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        if scan.pageCount == 1 {
            if pages.isEmpty {
                theNotes[ind][5] = Int64(1)
                let textImg = self.global.convertImageToBase64String(img: scan.imageOfPage(at: 0))
                theNotes.insert([ImageViewerTitleTxtField.text!, ImageViewerTagsLabel.text!, textImg, struggle, true, Int64(2)], at: ind + 1)
            } else {
                let index = Int(pages.last![5] as! Int64)
                let img = scan.imageOfPage(at: 0)
                let textImg2 = self.global.convertImageToBase64String(img: img)
                theNotes.insert([ImageViewerTitleTxtField.text!, ImageViewerTagsLabel.text!, textImg2, struggle, true, Int64(2)], at: Int(ind + index))
            }
        }
        else if scan.pageCount > 1 {
            if pages.isEmpty {
                theNotes[ind][5] = Int64(1)
                let textImg = self.global.convertImageToBase64String(img: scan.imageOfPage(at: 0))
                for i in 0..<scan.pageCount {
                    theNotes.insert([ImageViewerTitleTxtField.text!, ImageViewerTagsLabel.text!, textImg, struggle, true, Int64(2 + i)], at: ind + 1 + i)
                }
            } else {
                let index = Int(pages.last![5] as! Int64) + 1
                for i in 0 ..< scan.pageCount {
                    let img = scan.imageOfPage(at: i)
                    let textImg2 = self.global.convertImageToBase64String(img: img)
                    theNotes.insert([ImageViewerTitleTxtField.text!, ImageViewerTagsLabel.text!, textImg2, struggle, true, Int64(index + i)], at: Int(ind + (index - 1) + i))
                }
            }
        }
        fetchPages()
        ImageViewerPageCollectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var ImageViewerAddPagesButton: UIButton!
    @IBOutlet weak var ImageViewerDeleteButton: UIButton!
    @IBAction func ImageViewerExportButtonAction(_ sender: UIButton) {
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
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 30)]
            let titleAttributedString = NSAttributedString(string: theNotes[ind][0] as! String, attributes: titleAttributes)
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
            
            let difficultyAttributedString = NSAttributedString(string: rating, attributes: [NSAttributedString.Key.font: UIFont(name: "Futura", size: 18)])
            difficultyAttributedString.draw(in: CGRect(x: 20, y: 100, width: 545, height: 60))
            
            let theImage = ImageViewerImageView.image
            theImage?.draw(in: CGRect(x: 50, y: 100, width: 495, height: 695))
            
            if pages.isEmpty != true {
                for a in 1..<pages.count {
                    let theImage = pages[a][2] as! UIImage
                    theImage.draw(in: CGRect(x: 0, y: 0, width: 595, height: 842))
                }
            }
        })
        let PDF = PDFDocument(data: data)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(pdfExtension)
        PDF?.write(to: url)
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }

    @IBOutlet weak var ImageViewerExportButton: UIButton!
    @IBAction func ImageViewerStruggleSegContAction(_ sender: UISegmentedControl) {
        global.pow()
        switch sender.selectedSegmentIndex {
        case 0:
            struggle = "unrated"
            if (theNotes[ind][3] as! String).contains("/") {
                struggle = "unrated/pinned"
            }
            break
        case 1:
            struggle = "green"
            if (theNotes[ind][3] as! String).contains("/") {
                struggle = "green/pinned"
            }
            break
        case 2:
            struggle = "orange"
            if (theNotes[ind][3] as! String).contains("/") {
                struggle = "orange/pinned"
            }
            break
        case 3:
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
    @IBOutlet weak var ImageViewerStruggleSegCont: UISegmentedControl!
    @IBAction func ImageViewerEditButtonAction(_ sender: UIButton) {
        global.pow()
        if editingIndex % 2 == 0 {
            ImageViewerEditButton.setTitle("Done", for: .normal)
            ImageViewerTitleTxtField.isUserInteractionEnabled = true
            ImageViewerTitleTxtField.clearButtonMode = .always
            ImageViewerAddPagesButton.isHidden = false
            ImageViewerAddPagesButton.isEnabled = true
            ImageViewerMoveButton.isHidden = false
            ImageViewerMoveButton.isEnabled = true
            ImageViewerDeleteButton.isEnabled = true
            ImageViewerDeleteButton.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.ImageViewerAddPagesButton.transform = CGAffineTransform(translationX: -98, y: 0)
                self.ImageViewerDeleteButton.bounds = CGRect(x: 161, y: 820, width: 92, height: 42)
                self.ImageViewerMoveButton.bounds = CGRect(x: 226, y: 771, width: 168, height: 37)
            }, completion: nil)
            editingIndex += 1
        } else {
            ImageViewerEditButton.setTitle("Edit", for: .normal)
            ImageViewerTitleTxtField.isUserInteractionEnabled = false
            ImageViewerTitleTxtField.clearButtonMode = .never
            UIView.animate(withDuration: 0.3, animations: {
                self.ImageViewerDeleteButton.bounds = CGRect(x: 202, y: 820, width: 0, height: 42)
                self.ImageViewerMoveButton.bounds = CGRect(x: 310, y: 771, width: 0, height: 37)
                self.ImageViewerAddPagesButton.transform = .identity
            }) { (success) in
                self.ImageViewerDeleteButton.isHidden = true
                self.ImageViewerDeleteButton.isEnabled = false
                self.ImageViewerMoveButton.isHidden = true
                self.ImageViewerMoveButton.isEnabled = false
            }
            editingIndex += 1
        }
    }
    func saveAllPages() {
        for a in 0..<pages.count {
            let tag = String((ImageViewerTagsLabel.text?.dropFirst())!)
            theNotes[ind + a] = [ImageViewerTitleTxtField.text!, tag, pages[a][2] as! String, struggle, true, Int64(a + 1)]
        }
    }
    @IBOutlet weak var ImageViewerEditButton: UIButton!
    func fetchPages() {
        pages = [[Any]]()
        if theNotes[ind][5] as! Int64 == Int64(0) {
            ImageViewerDeleteButton.setTitle("Trash", for: .normal)
            ImageViewerPageCollectionView.isHidden = true
            ImageViewerPageCollectionView.isUserInteractionEnabled = false
            print("Singular Page")
        } else {
            ImageViewerDeleteButton.setTitle("Delete", for: .normal)
            ImageViewerPageCollectionView.isHidden = false
            ImageViewerPageCollectionView.isUserInteractionEnabled = true
            pages.append(theNotes[ind])
            let leftOver = Int(theNotes.count) - ind
            for a in 1..<leftOver {
                if theNotes[ind + a][5] as! Int64 == Int64(a + 1) {
                    pages.append(theNotes[ind + a])
                } else {
                    break
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        fetchPages()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.ImageViewerTitleTxtField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.ImageViewerTitleTxtField.endEditing(true)
        return false
    }
    @IBOutlet weak var ImageViewBackgroundDimmingView: UIView!
    var zoomedSegue = false
    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        print("Tapped")
        zoomedSegue = true
        ImageViewBackgroundDimmingView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.ImageViewerImageView.layer.transform = CATransform3DMakeScale(1.15, 1.15, 1.15)
            self.ImageViewBackgroundDimmingView.backgroundColor = .black
            self.navigationController?.navigationBar.alpha = 0
        }) { (_) in
            self.performSegue(withIdentifier: "zoomImage", sender: self)
        }
    }
    @IBOutlet weak var ImageViewerTitleTxtField: UITextField!
    @IBOutlet weak var ImageViewerTagsLabel: UILabel!
    @IBOutlet weak var ImageViewerImageView: UIImageView!
    @objc func reloadImageViewTag() {
        DispatchQueue.main.async {
            print(theNotes[ind][1] as! String)
            print("Now index \(ind)")
            self.ImageViewerTagsLabel.text = "🗂" + String(theNotes[ind][1] as! String)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPages()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadImageViewTag), name: NSNotification.Name(rawValue: "reloadImageViewPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlingImageText), name: NSNotification.Name("imageTextHandling"), object: nil)
//        ImageViewerTagsLabel.font = UIFont(name: fontArray[0], size: 20)
//        ImageViewerTitleTxtField.font = UIFont(name: fontArray[0], size: 35)
        ImageViewBackgroundDimmingView.layer.zPosition = 1
        ImageViewerImageView.layer.zPosition = 2
        ImageViewerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        ImageViewerImageView.layer.cornerRadius = 16
        ImageViewerExportButton.setTitleColor((settingsPreferances[1][1] as! UIColor), for: .normal)
        ImageViewerEditButton.setTitleColor((settingsPreferances[1][1] as! UIColor), for: .normal)
        ImageViewerOccasionalDismissButton.setTitleColor((settingsPreferances[1][1] as! UIColor), for: .normal)
        ImageViewerOccasionalDismissButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        if settingsPreferances[1][1] as! UIColor == UIColor.label {
            ImageViewerAddPagesButton.setTitleColor(.systemBackground, for: .normal)
            ImageViewerMoveButton.setTitleColor(.systemBackground, for: .normal)
        } else {
            ImageViewerAddPagesButton.setTitleColor(.white, for: .normal)
            ImageViewerMoveButton.setTitleColor(.white, for: .normal)
        }
        ImageViewerAddPagesButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        ImageViewerMoveButton.backgroundColor = (settingsPreferances[1][1] as! UIColor)
        ImageViewerToTextButton.tintColor = (settingsPreferances[1][1] as! UIColor)
        ImageViewerPageCollectionView.delegate = self
        ImageViewerPageCollectionView.dataSource = self
        ImageViewerPageCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        ImageViewerTitleTxtField.delegate = self
        var rating = theNotes[ind][3] as! String
        if (theNotes[ind][3] as! String).contains("/") {
            rating = (theNotes[ind][3] as! String).components(separatedBy: "/")[0]
        }
        if rating == "unrated" {
            ImageViewerStruggleSegCont.selectedSegmentIndex = 0
        } else if rating == "green" {
            ImageViewerStruggleSegCont.selectedSegmentIndex = 1
        } else if rating == "orange" {
            ImageViewerStruggleSegCont.selectedSegmentIndex = 2
        } else if rating == "red" {
            ImageViewerStruggleSegCont.selectedSegmentIndex = 3
        }
        struggle = theNotes[ind][3] as! String
        ImageViewerAddPagesButton.layer.cornerRadius = 8
        ImageViewerTitleTxtField.text = (theNotes[ind][0] as! String)
        ImageViewerTagsLabel.text = "🗂" + String(theNotes[ind][1] as! String)
        
        ImageViewerTitleTxtField.isUserInteractionEnabled = false
        ImageViewerTitleTxtField.clearButtonMode = .never
        
        ImageViewerImageView.image = global.convertBase64StringToImage(imageBase64String: theNotes[ind][2] as! String)
        ImageViewerDeleteButton.isHidden = true
        ImageViewerDeleteButton.isEnabled = false
        ImageViewerMoveButton.isHidden = true
        ImageViewerMoveButton.isEnabled = false
        ImageViewerImageView.isUserInteractionEnabled = true
        ImageViewerDeleteButton.layer.cornerRadius = 16
        ImageViewerMoveButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if zoomedSegue {
            let zoomedImageController = segue.destination as! ZoomedInImagePage
            zoomedImageController.zoomingImage = ImageViewerImageView.image!
            zoomedSegue = false
        } else {
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zoomedImageDismissed == false {
            print("false")
            ImageViewBackgroundDimmingView.isUserInteractionEnabled = false
            ImageViewBackgroundDimmingView.isHidden = true
        }
        if zoomedImageDismissed {
            print("true")
            UIView.animate(withDuration: 0.3, animations: {
                self.ImageViewerImageView.layer.transform = CATransform3DIdentity
                self.ImageViewBackgroundDimmingView.backgroundColor = .clear
                self.navigationController?.navigationBar.alpha = 1
            }) { (_) in
                self.ImageViewBackgroundDimmingView.isHidden = true
                self.ImageViewBackgroundDimmingView.isUserInteractionEnabled = false
            }
            zoomedImageDismissed = false
        }
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            let imgData = global.convertImageToBase64String(img: ImageViewerImageView.image!)
            if pages.isEmpty && dismissedDueToConversion != true {
                print("Saving...")
                let tag = String((ImageViewerTagsLabel.text?.dropFirst())!)
                theNotes[ind] = [ImageViewerTitleTxtField.text!, tag, imgData, struggle, true, Int64(0)]
            } else if dismissedDueToConversion != true && pages.isEmpty != true {
                saveAllPages()
            }
            ind = 0
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ImageViewerTitleTxtField.isUserInteractionEnabled = false
        let imgData = global.convertImageToBase64String(img: ImageViewerImageView.image!)
        if pages.isEmpty && (isBeingDismissed) && dismissedDueToConversion != true {
            print("Saving...")
            let tag = String((ImageViewerTagsLabel.text?.dropFirst())!)
            theNotes[ind] = [ImageViewerTitleTxtField.text!, tag, imgData, struggle, true, Int64(0)]
            ind = 0
        } else if pages.isEmpty != true && (isBeingDismissed) && dismissedDueToConversion != true {
            saveAllPages()
            ind = 0
        }
        if ImageViewerEditButton.titleLabel!.text == "Done" {
            ImageViewerEditButton.setTitle("Edit", for: .normal)
            ImageViewerTitleTxtField.clearButtonMode = .never
            ImageViewerTitleTxtField.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                self.ImageViewerAddPagesButton.transform = .identity
                self.ImageViewerDeleteButton.bounds = CGRect(x: 202, y: 820, width: 0, height: 42)
                self.ImageViewerMoveButton.bounds = CGRect(x: 310, y: 771, width: 0, height: 37)
            }) { (success) in
                self.ImageViewerDeleteButton.isHidden = true
                self.ImageViewerDeleteButton.isEnabled = false
                self.ImageViewerMoveButton.isHidden = true
                self.ImageViewerMoveButton.isEnabled = false
            }
            editingIndex += 1
        }
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                if fileURL.pathExtension == "pdf" {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
        } catch  { print(error) }
        zoomedImageDismissed = true
        previouslyDimissed = true
        dismissedDueToConversion = false
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
