//
//  shakingTextField.swift
//  School Binder
//
//  Created by Joshua Laurence on 29/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class shakingTextField: UITextField {
    
    //MARK: Custom Textfield Shake
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }

}
