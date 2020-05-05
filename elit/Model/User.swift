//
//  User.swift
//  elit
//
//  Created by Abigail Tran on 4/11/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject, Encodable, Decodable {
    private var username: String = ""
    private var password: String = ""
    private var fullName: String = ""
    private var email: String = ""
    
    init(fullName: String, email: String, username: String, password: String) {
        super.init()
        self.set(fullName: fullName)
        self.set(email: email)
        self.set(password: password)
        self.set(username: username)
    }
    
    convenience override init() {
        self.init(fullName: "", email: "", username: "", password: "")
    }
    
    //Getters and Setters
    func getFullName() -> String {
        fullName
    }
    
    func set(fullName: String) {
        self.fullName = fullName;
    }
    
    func getEmail() -> String {
        email
    }
    
    func set(email: String) {
        self.email = email;
    }
    
    func getUsername() -> String {
        username
    }
    
    func set(username: String) {
        self.username = username;
    }
    
    func getPassword() -> String {
        password
    }
    
    func set(password: String) {
        self.password = password;
    }
}


