//
//  Genre.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/19/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

class Genre: NSObject {
    private var name: String = ""
    private var id: Int = 0
    
    init(name: String, id: Int) {
        super.init()
        self.set(name: name)
        self.set(id: id)
        
    }

    func getName() -> String {
       name
    }
    func set(name: String) {
       self.name = name;
    }
    func getId() -> Int {
        id
     }
    func set(id: Int) {
        self.id = id;
    }
}
