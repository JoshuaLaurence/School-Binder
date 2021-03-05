//
//  OnBoarding.swift
//  School Binder
//
//  Created by Joshua Laurence on 01/08/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class OnBoardingCell: UITableViewCell {
    var title = String()
    var info = String()
    var OnBoardingSecondaryViewLeft: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    var OnBoardingSecondaryViewRight: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = .red
       return view
    }()
    var OnBoardingMainView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = .systemBackground
       return view
    }()
    var OnBoardingTitleLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.backgroundColor = .clear
       label.font = UIFont(name: "Futura", size: 20)
       return label
    }()
    var OnBoardingInfoLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.backgroundColor = .clear
       label.font = UIFont(name: "Futura", size: 16)
       return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        OnBoardingMainView.backgroundColor = .secondarySystemBackground
        OnBoardingMainView.addSubview(OnBoardingTitleLabel)
        OnBoardingMainView.addSubview(OnBoardingInfoLabel)
        OnBoardingMainView.layer.zPosition = 1
        self.addSubview(OnBoardingMainView)
        
        OnBoardingSecondaryViewLeft.layer.zPosition = 0
        OnBoardingSecondaryViewRight.layer.zPosition = 0
        
        self.addSubview(OnBoardingSecondaryViewLeft)
        self.addSubview(OnBoardingSecondaryViewRight)
        
        OnBoardingSecondaryViewLeft.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        OnBoardingSecondaryViewLeft.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        OnBoardingSecondaryViewLeft.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        OnBoardingSecondaryViewLeft.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        OnBoardingSecondaryViewRight.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        OnBoardingSecondaryViewRight.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        OnBoardingSecondaryViewRight.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        OnBoardingSecondaryViewRight.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        OnBoardingMainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        OnBoardingMainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        OnBoardingMainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        OnBoardingMainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        OnBoardingTitleLabel.topAnchor.constraint(equalTo: self.OnBoardingMainView.topAnchor).isActive = true
        OnBoardingTitleLabel.leftAnchor.constraint(equalTo: self.OnBoardingMainView.leftAnchor, constant: 8).isActive = true
        OnBoardingTitleLabel.rightAnchor.constraint(equalTo: self.OnBoardingMainView.rightAnchor, constant: 8).isActive = true
        OnBoardingTitleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        OnBoardingInfoLabel.topAnchor.constraint(equalTo: self.OnBoardingTitleLabel.bottomAnchor).isActive = true
        OnBoardingInfoLabel.bottomAnchor.constraint(equalTo: self.OnBoardingMainView.bottomAnchor).isActive = true
        OnBoardingInfoLabel.leftAnchor.constraint(equalTo: self.OnBoardingMainView.leftAnchor, constant: 8).isActive = true
        OnBoardingInfoLabel.rightAnchor.constraint(equalTo: self.OnBoardingMainView.rightAnchor, constant: 8).isActive = true
        OnBoardingInfoLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        OnBoardingTitleLabel.text = title
        OnBoardingInfoLabel.text = info
    }
    
    func swipeAnimation() {
        UIView.animate(withDuration: 0.7, delay: 1, options: .curveEaseOut, animations: {
            self.OnBoardingMainView.transform = CGAffineTransform(translationX: 40, y: 0)
            self.OnBoardingMainView.layer.cornerRadius = 10
        }) { (success) in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.OnBoardingMainView.transform = .identity
                self.OnBoardingMainView.layer.cornerRadius = 0
            }) { (success) in
                UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
                    self.OnBoardingMainView.transform = CGAffineTransform(translationX: -40, y: 0)
                    self.OnBoardingMainView.layer.cornerRadius = 10
                }) { (success) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                        self.OnBoardingMainView.transform = .identity
                        self.OnBoardingMainView.layer.cornerRadius = 0
                    }) { (success) in
                        
                    }
                }
            }
        }
    }
    func restore() {
        self.OnBoardingMainView.transform = .identity
        self.OnBoardingMainView.layer.cornerRadius = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OnBoarding: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var pageControl = UIPageControl()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tempData.count)
        return tempData.count
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offSetY = targetContentOffset.pointee.x
        pageControl.currentPage = Int(offSetY / 414)
        if offSetY == 828 {
            for a in 0..<6 {
                if a == 1 || a == 3 || a == 5 {
                    let visibleCell = animatedTableView.visibleCells[a] as! OnBoardingCell
                    visibleCell.swipeAnimation()
                }
            }
        } else {
            for a in 0..<6 {
                let visibleCell = animatedTableView.visibleCells[a] as! OnBoardingCell
                visibleCell.restore()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "onBoardingCell", for: indexPath) as! OnBoardingCell
        Cell.title = tempData[indexPath.row][0]
        Cell.info = tempData[indexPath.row][1]
        Cell.layoutSubviews()
        print("Title \(Cell.OnBoardingTitleLabel.text)")
        print("Title \(Cell.OnBoardingInfoLabel.text)")
        return Cell
    }
    var tempData = [["Folder 1","The folder your 1st note is in"], ["Folder 2","The folder your 2nd note is in"], ["Folder 3","The folder your 3rd note is in"], ["Sub Folder of 3", "The folder your 4th note is in"], ["Folder 4", "The folder your 5th note is in"], ["Folder 5", "The folder your 6th note is in"]]
    var animatedTableView = UITableView(frame: CGRect(x: 25, y: 25, width: 350, height: 350))
    
    @IBOutlet weak var OnBoardingScrollView: UIScrollView!
    let details = [["Welcome, and Thanks", "Thank you for downloading and choosing to use my app. Unlike many other notes apps of similar functionality, this is made by an independent developer, so NO IN APP PURCHASES or ADS (I know right!). Lets continue with the instructions", "checkmark.seal.fill"],
        ["The Basic Structure", "This app uses a bi-folder system. This means you will have SUBJECTS (or main folders), and TOPICS (or sub folders). This makes categorising and organising your notes a breeze!", "books.vertical.fill"],
        ["Each folder has swipe gestures", "Swiping left/right on folders will reveal them. Its not only folders that have hidden swipe abilities, It works on sub-folders",""],
        ["Configure and Personalise","Tap the three lines in the top right hand corner to open THE MENU. At the bottom of the menu you will see a COG. This will take you to the settings page where you can configure the app to suit your experience, even CHOOSE A COLOUR that suits you.","gearshape.2.fill"],
        ["Lets Go", "This is the only time you will get to see the app instructions. You can scroll back if you would like, and refresh yourself. But when your ready, click the button and GET STARTED", "hand.thumbsup"]]
    override func viewDidLoad() {
        super.viewDidLoad()
//        let size = UILabel.appearance().font.pointSize
//        UILabel.appearance().font = UIFont(name: "Futura", size: CGFloat(Float(Float(size) + Float(settingsPreferances[4][0] as! String)!)))
        OnBoardingScrollView.showsHorizontalScrollIndicator = false
        OnBoardingScrollView.delegate = self
        animatedTableView.backgroundColor = .secondarySystemBackground
        animatedTableView.layer.cornerRadius = 8
        animatedTableView.register(OnBoardingCell.self, forCellReuseIdentifier: "onBoardingCell")
        animatedTableView.rowHeight = 65
        animatedTableView.estimatedRowHeight = 65
        animatedTableView.delegate = self
        animatedTableView.dataSource = self
        animatedTableView.isUserInteractionEnabled = false
        animatedTableView.reloadData()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = details.count
        pageControl.pageIndicatorTintColor = .secondaryLabel
        pageControl.currentPageIndicatorTintColor = .label
        self.view.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -35).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        configure()
        // Do any additional setup after loading the view.
    }
    func configure() {
        OnBoardingScrollView.contentSize = CGSize(width: OnBoardingScrollView.frame.size.width * 5, height: OnBoardingScrollView.frame.size.height)
        OnBoardingScrollView.isPagingEnabled = true
        for x in 0..<5 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * OnBoardingScrollView.frame.size.width, y: 0, width: OnBoardingScrollView.frame.size.width, height: OnBoardingScrollView.frame.size.height))
            OnBoardingScrollView.addSubview(pageView)
            let mainImage = UIImageView(frame: CGRect(x: 25, y: 25, width: 350, height: 350))
            mainImage.tintColor = .purple
            let mainTitle = UILabel(frame: CGRect(x: 10, y: mainImage.frame.size.height + 10 + 10 + 40, width: 394, height: 80))
            let secondaryTitle = UILabel(frame: CGRect(x: 10, y: mainImage.frame.size.height + 10 + mainTitle.frame.size.height + 10, width: 394, height: 300))
            let enterAppButton = UIButton(frame: CGRect(x: 107, y: pageView.frame.height - 10 - 60, width: 200, height: 60))
            enterAppButton.backgroundColor = .label
            enterAppButton.setTitleColor(.systemBackground, for: .normal)
            enterAppButton.setTitle("Go", for: .normal)
            enterAppButton.layer.cornerRadius = 10
            enterAppButton.titleLabel!.font = UIFont(name: "Futura", size: 20)
            enterAppButton.addTarget(self, action: #selector(letsGoToTheApp), for: .touchUpInside)
            secondaryTitle.minimumScaleFactor = 0.7
            if x == 2 {
                pageView.addSubview(animatedTableView)
                animatedTableView.reloadData()
            } else if x == (details.count - 1) {
                pageView.addSubview(enterAppButton)
                if details[x][2].isEmpty {
                    mainImage.image = UIImage()
                } else {
                    mainImage.contentMode = .scaleAspectFit
                    mainImage.image = UIImage(systemName: details[x][2])
                    mainImage.layer.cornerRadius = 20
                }
                pageView.addSubview(mainImage)
            } else {
                if details[x][2].isEmpty {
                    mainImage.image = UIImage()
                } else {
                    mainImage.contentMode = .scaleAspectFit
                    mainImage.image = UIImage(systemName: details[x][2])
                    mainImage.layer.cornerRadius = 20
                }
                pageView.addSubview(mainImage)
            }
            
            mainTitle.textAlignment = .center
            mainTitle.textColor = .label
            mainTitle.font = UIFont(name: "Futura", size: 35)
            mainTitle.numberOfLines = 2
            mainTitle.minimumScaleFactor = 0.5
            mainTitle.adjustsFontSizeToFitWidth = true
            mainTitle.text = details[x][0]
            pageView.addSubview(mainTitle)
            
            secondaryTitle.textAlignment = .center
            secondaryTitle.textColor = .secondaryLabel
            secondaryTitle.font = UIFont(name: "Futura", size: 17)
            secondaryTitle.numberOfLines = 0
            secondaryTitle.text = details[x][1]
            pageView.addSubview(secondaryTitle)
        }
    }
    @objc func letsGoToTheApp(_ sender: UIButton!) {
        GlobalFunctions().pow()
        self.performSegue(withIdentifier: "toApp", sender: self)
    }
}
