//
//  GenreButton.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/19/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit
@IBDesignable
class GenreButton: UIButton {
    
    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton(){
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.size.height/2
        backgroundColor = ECLIPSE
        setTitleColor(UIColor.white, for: .normal)
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOpacity = 2
        layer.shadowOffset  = CGSize(width: 1.0, height: 4)
        layer.shadowRadius  = 4
            
    }
    
    func buttonPressed(){
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool){
        isOn = bool
        let color = bool ? SOYBEAN : .clear
        let titleColor = bool ? ECLIPSE : .white
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
    
    func reset(){
        initButton()
        isOn = false
    }
    
}
