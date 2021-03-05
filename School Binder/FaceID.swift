//
//  FaceID.swift
//  School Binder
//
//  Created by Joshua Laurence on 29/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit
import LocalAuthentication
class FaceID: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func bioLogin() {
        let context:LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Open the app") { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "BiometricOpen", sender: self)
                    }
                } else {
                    
                }
            }
        }
    }
    
    @IBOutlet weak var FaceIDJustInCaseLoginButton: UIButton!
    @IBAction func FaceIDJustInCaseLoginButtonAction(_ sender: UIButton) {
        bioLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bioLogin()
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
