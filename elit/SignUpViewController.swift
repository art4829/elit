//
//  SignUpViewController.swift
//  elit
//
//  Created by Abigail Tran on 4/5/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullnameEntered: UITextField!
    @IBOutlet weak var emailEntered: UITextField!
    @IBOutlet weak var usernameEntered: UITextField!
    @IBOutlet weak var passwordEntered: UITextField!
    @IBOutlet weak var confirmPasswordEntered: UITextField!
    
    var usersList = Users()
    var fullname = ""
    var email = ""
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersList.userList = globalUsersList
    }
    
    @IBAction func signup(sender: UIButton)  {
        //Check not empty strings:
        if (fullnameEntered.text! == "" || emailEntered.text! == "" || usernameEntered.text! == "" || passwordEntered.text! == "" || confirmPasswordEntered.text! == "") {
            alertUser(message: "Please enter all required fields!")
            return
        }
        
        //Check username existed
        for user in usersList.userList {
            if (usernameEntered!.text! == user.getUsername()) {
                alertUser(message: "Please choose a different username")
                usernameEntered.text = ""
                return
            }
        }
        
        //Check email format:
        if (!isValidEmail(emailEntered.text!)) {
            alertUser(message: "Invalid email format")
            emailEntered.text = ""
            return
        }
        
        //Check email existed
        for user in usersList.userList {
            if (emailEntered!.text! == user.getEmail()) {
                alertUser(message: "Please choose a different email")
                emailEntered.text = ""
                return
            }
        }
        
        //Check confirmedPassword == password
        if (passwordEntered.text! != confirmPasswordEntered.text!){
            alertUser(message: "Passwords entered are not the same")
            passwordEntered.text = ""
            confirmPasswordEntered.text = ""
            return
        } else {
            fullname = fullnameEntered.text!
            email = emailEntered.text!
            username = usernameEntered.text!
            password = passwordEntered.text!
            
            let u = User(fullName: fullname, email: email, username: username, password: password)
            
            globalUsersList.append(u)
            
            let plistDict: Dictionary<String,Any> = [
                "fullName": fullname,
                "email": email,
                "username": username,
                "password": password
            ]
            
            if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = documentsPathURL.appendingPathComponent("users.plist")

                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path.path))
                    var tempArray = try PropertyListSerialization.propertyList(from: data, format: nil) as! [Dictionary<String, Any>]
                    
                    tempArray.append(plistDict)
                
                    
                    let plistData = try PropertyListSerialization.data(fromPropertyList: tempArray, format: .xml, options: 0)
                   

                    try plistData.write(to: path)
                    
                } catch {
                    print(error)
                }
            }
            
            performSegue(withIdentifier: "SignupToLogin", sender: self)
        }
    }
    
    func alertUser(message : String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
