//
//  gradient.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/7/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {

    // the gradient start colour
    @IBInspectable var firstColor: UIColor = eclipse {
        didSet {
            updateView()
        }
    }

    // the gradient end colour
    @IBInspectable var secondColor: UIColor = soybean {
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

//        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.29, b: 0.57, c: -0.57, d: 0.41, tx: 0.36, ty: 0.59))
//
//        layer.compositingFilter = "darkenBlendMode"

//        layer.bounds = self.view.bounds.insetBy(dx: -0.5*self.view.bounds.size.width, dy: -0.5*view.bounds.size.height)
//
//        layer.position = self.view.center
    }
}
