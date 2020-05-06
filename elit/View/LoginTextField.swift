//
//  LoginTextField.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 4/8/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class LoginTextField: UITextField{
    
     override init(frame: CGRect) {
              super.init(frame: frame)
              setup()
          }
      required public init?(coder aDecoder: NSCoder) {
              super.init(coder: aDecoder)
              setup()
          }
    
    func setup(){
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        leftViewMode = .always
        
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 5.0
        layer.shadowRadius = 0.0
    }
}
