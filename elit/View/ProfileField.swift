//
//  ProfileField.swift
//  elit
//
//  Created by Abigail Tran on 5/1/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class ProfileField: UILabel{
    
     override init(frame: CGRect) {
              super.init(frame: frame)
              setup()
          }
      required public init?(coder aDecoder: NSCoder) {
              super.init(coder: aDecoder)
              setup()
          }
    
    func setup(){
        layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 0.5)
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
    
    }
}


extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor;

        self.addSublayer(border)
    }

}
