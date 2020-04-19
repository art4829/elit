//
//  Signin_SignupButton.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/8/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LoginButton: UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    // the button color
    @IBInspectable var firstColor: UIColor = UIColor.white {
       didSet {
           setupButton()
       }
    }
        
    func setupButton(){
        setShadow()
        backgroundColor      = firstColor
        titleLabel?.font     = UIFont(name: elitFont, size: 18)
        layer.cornerRadius   = 20
    }
    
    private func setShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset  = CGSize(width: 0.0, height: 4)
        layer.shadowRadius  = 4
       }
    
}

