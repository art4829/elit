//
//  dropDownMenu.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/19/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit

class dropDownMenu: UIButton {
    
    let transparentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder){
         super.init(coder: aDecoder)
    }
    
    func addTansparentView(frame: CGRect){
           let window = UIApplication.shared.windows.first { $0.isKeyWindow }
           transparentView.frame = window?.frame ?? self.view.frame
           self.view.addSubview(transparentView)
           
           // add tableview for the dropdown button
           tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
           self.view.addSubview(tableView)
           
           transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
           tableView.reloadData()
           let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
           transparentView.addGestureRecognizer(tapgesture)
           transparentView.alpha = 0
           UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
               self.transparentView.alpha = 0.5
               self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height + 5, width: frame.width, height: CGFloat(self.dataSource.count * 50))
           }, completion: nil)
           
      }
       
       @objc func removeTransparentView(){
           let frame = dropDownBtn.frame
           UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
               self.transparentView.alpha = 0
               self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
           }, completion: nil)
       }
}
