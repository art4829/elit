//
//  LoginViewController.swift
//  elit
//
//  Created by Abigail Tran on 4/5/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameEntered: UITextField!
    @IBOutlet weak var passwordEntered: UITextField!
    
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var plistPath = documentsPathURL.appendingPathComponent("user.plist").path
            if !FileManager.default.fileExists(atPath: plistPath) {
                plistPath = Bundle.main.path(forResource: "user", ofType: "plist")!
            }
            
            //Retrieve the username and password
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: plistPath))
                
                print(data)
                let temp = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as! [String:Any]
                
                print("\(temp)")
                
                username = temp["username"] as? String ?? "TBD"
                password = temp["password"] as? String ?? "TBD"
                
            } catch {
                print(error)
            }
        }
    }

    
    @IBAction func login(sender: UIButton) {
            
        //Check if the username and password are correct
        if (username == usernameEntered.text! && password == passwordEntered.text!) {
            performSegue(withIdentifier: "LoginToHome", sender: self)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Incorrect Username or Password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
             alertController.addAction(defaultAction)
             self.present(alertController, animated: true, completion: nil)
        }
        
        view.endEditing(true) //dismiss the keyboard whenever you have multiple fields
    }
    
    
    @IBAction func textFieldReturn(sender: UITextField) {
        sender.resignFirstResponder()
    }

}
