//
//  MenuPage.swift
//  School Binder
//
//  Created by Joshua Laurence on 31/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
var menuItemPreviouslySelected = String()
enum MenuType: Int {
    case home
    case struggling
    case trash
}


class MenuPage: UITableViewController {
    
    var didTapMenuType : ((MenuType) -> Void)?
    
    @IBOutlet weak var MenuPageHomeImage: UIImageView!
    @IBOutlet weak var MenuPageSearchImage: UIImageView!
    @IBOutlet weak var MenuPageStrugglingImage: UIImageView!
    @IBOutlet weak var MenuPageTrashImage: UIImageView!
    @IBOutlet weak var MenuPageSettingsButtonOutlet: UIButton!
    @IBAction func MenuPageSettingsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Menu>Settings", sender: self)
    }
    @IBOutlet weak var MenuPageSettingsButtonView: UIView!
    var views = ["Home", "All", "Struggling"]
    @objc func dismissing() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissing), name: NSNotification.Name(rawValue: "dismissMenu"), object: nil)
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 35)
        title.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        let underlinedText = NSAttributedString(string: "  Menu", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        title.attributedText = underlinedText
        tableView.tableHeaderView = title
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        MenuPageSettingsButtonView.translatesAutoresizingMaskIntoConstraints = false
        MenuPageSettingsButtonView.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor).isActive = true
        MenuPageSettingsButtonView.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor).isActive = true
        MenuPageSettingsButtonView.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        MenuPageSettingsButtonView.widthAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.widthAnchor).isActive = true
        MenuPageSettingsButtonView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        NotificationCenter.default.addObserver(self, selector: #selector(accentColorChangeMenu), name: NSNotification.Name("changeMenuImageColours"), object: nil)
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.25)
        }
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .clear
        }
    }
    var nextVCTitle = String()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalFunctions().pow()
        let menuType = MenuType(rawValue: indexPath.row)!
        self.didTapMenuType?(menuType)
        dismiss(animated: true) {
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MenuPageTrashImage.tintColor = (settingsPreferances[1][1] as! UIColor)
        MenuPageStrugglingImage.tintColor = (settingsPreferances[1][1] as! UIColor)
        MenuPageHomeImage.tintColor = (settingsPreferances[1][1] as! UIColor)
        MenuPageSettingsButtonOutlet.tintColor = (settingsPreferances[1][1] as! UIColor)
    }
    @objc func accentColorChangeMenu() {
        MenuPageTrashImage.tintColor = (settingsPreferances[1][1] as! UIColor)
        MenuPageStrugglingImage.tintColor = (settingsPreferances[1][1] as! UIColor)
        MenuPageHomeImage.tintColor = (settingsPreferances[1][1] as! UIColor)
        MenuPageSettingsButtonOutlet.tintColor = (settingsPreferances[1][1] as! UIColor)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func handleGesture(_ gesture:UISwipeGestureRecognizer) -> Void {
        self.dismiss(animated: true, completion: nil)
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
