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
    
    var fullname = ""
    var email = ""
    var username = ""
    var password = ""
    
    @IBAction func goToLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "SignupToLoginSegue", sender: self)
    }
    
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
                let temp = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as! [String:Any]

                print("\(temp)")

                fullname = temp["fullname"] as? String ?? "TBD"
                email = temp["email"] as? String ?? "TBD"
                username = temp["username"] as? String ?? "TBD"
                password = temp["password"] as? String ?? "TBD"
                
            } catch {
                print(error)
            }
        }

    }
    @IBAction func signup(sender: UIButton)  {
        //Check if the username has already existed:
        if (username == usernameEntered.text!) {
            //Notify duplicate username
            let alertController = UIAlertController(title: "Error", message: "Duplicate Username", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
             alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            usernameEntered.text = ""
            passwordEntered.text = ""
            confirmPasswordEntered.text = ""
        } else if (passwordEntered.text! != confirmPasswordEntered.text!){
            let alertController = UIAlertController(title: "Error", message: "Passwords entered are not the same", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
             alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            passwordEntered.text = ""
            confirmPasswordEntered.text = ""
        } else {
            fullname = fullnameEntered.text!;
            email = emailEntered.text!;
            username = usernameEntered.text!;
            password = passwordEntered.text!
            let plistDict: Dictionary<String,Any> = [
                "fullname": fullname,
                "email": email,
                "username": username,
                "password": password
            ]
            
            if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                var plistPath = documentsPathURL.appendingPathComponent("user.plist").path
                if !FileManager.default.fileExists(atPath: plistPath) {
                    plistPath = Bundle.main.path(forResource: "user", ofType: "plist")!
                }
                
                do {
                    let plistData = try PropertyListSerialization.data(fromPropertyList: plistDict, format: .xml, options: 0)
                    
                    try plistData.write(to: documentsPathURL.appendingPathComponent("user.plist"))
                    print(plistData);
                } catch {
                    print(error)
                }
                
            }
            performSegue(withIdentifier: "SignupToLoginSegue", sender: self)
        }
    }
        
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
