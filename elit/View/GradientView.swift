//
//  gradient.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 4/7/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {

    // the gradient start colour
    @IBInspectable var firstColor: UIColor = ECLIPSE {
        didSet {
            updateView()
        }
    }

    // the gradient end colour
    @IBInspectable var secondColor: UIColor = SOYBEAN {
        didSet {
            updateView()
        }
    }

    // override layerclass to use gradientlayer
    override class var layerClass: AnyClass {
        get {
            CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor, UIColor(red:0.44, green:0.42, blue:0.44, alpha:1.00).cgColor]

        layer.locations = [0.60, 1]

        layer.startPoint = CGPoint(x: 0, y: 0)

        layer.endPoint = CGPoint(x: 0.70, y: 1)
        layer.position = center
        layer.compositingFilter = "darkenBlendMode"
    }
    
    
}
