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
    
    var usersList = Users()
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usersList.userList = globalUsersList
        username = ""
        password = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func goToSignUp(_ sender: Any) {
        performSegue(withIdentifier: "LoginToSignUpSegue", sender: self)
    }
    @IBAction func login(sender: UIButton) {
            
        //Check if the username and password are correct
        if (usernameEntered.text! == "" || passwordEntered.text! == "") {
            alertUser(message: "Please put in all fields")
            return
        }
        for user in globalUsersList {
            if (user.getUsername() == usernameEntered.text! && user.getPassword() == passwordEntered.text!) {
                username = user.getUsername();
                password = user.getPassword();
            }
        }
        if (username != "" && password != "") {
             performSegue(withIdentifier: "LoginToHome", sender: self)
        } else {
            alertUser(message: "Incorrect Username or Password")
        }
        
        view.endEditing(true) //dismiss the keyboard whenever you have multiple fields
    }
    
    func alertUser(message : String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func textFieldReturn(sender: UITextField) {
        sender.resignFirstResponder()
    }

}
