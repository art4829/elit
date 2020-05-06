//
//  SignUpViewController.swift
//  elit
//
//  ViewController for signing up a new user
//  Created by Abigail Tran and Abhaya Tamrakar on 4/5/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullnameEntered: UITextField!
    @IBOutlet weak var emailEntered: UITextField!
    @IBOutlet weak var usernameEntered: UITextField!
    @IBOutlet weak var passwordEntered: UITextField!
    @IBOutlet weak var confirmPasswordEntered: UITextField!
    
    var usersList : Users!
    var fullname = ""
    var email = ""
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (usersList == nil) {
            usersList = Helper.setUsersList()
        }
        self.hideKeyboardWhenTappedAround()
        fullnameEntered.delegate = self
        emailEntered.delegate = self
        usernameEntered.delegate = self
        passwordEntered.delegate = self
        confirmPasswordEntered.delegate = self
    }
    
    //If the user press return / hit enter key, the keyboard will dissapear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
  
    @IBAction func signup(sender: UIButton)  {
        //Check not empty strings:
        if (fullnameEntered.text! == "" || emailEntered.text! == "" || usernameEntered.text! == "" || passwordEntered.text! == "" || confirmPasswordEntered.text! == "") {
            
            Helper.alertUser(controller: self, message: PUT_ALL_FIELDS, title: "Error")
            return
        }
        
        //Check if the username existed
        for user in usersList.userList {
            if (usernameEntered!.text! == user.getUsername()) {
                Helper.alertUser(controller: self, message: CHOOSE_DIFFERENT_USERNAME, title: "Error")
                usernameEntered.text = ""
                return
            }
        }
        
        //Check the email format:
        if (!isValidEmail(emailEntered.text!)) {
            Helper.alertUser(controller: self, message: INVALID_EMAIL, title: "Error")
            emailEntered.text = ""
            return
        }
        
        //Check if the email existed
        for user in usersList.userList {
            if (emailEntered!.text! == user.getEmail()) {
                Helper.alertUser(controller: self, message: CHOOSE_DIFFERENT_EMAIL, title: "Error")
                emailEntered.text = ""
                return
            }
        }
        
        //Check confirmedPassword == password
        if (passwordEntered.text! != confirmPasswordEntered.text!){
            Helper.alertUser(controller: self, message: CONFIRM_PASSWORD, title: "Error")
            passwordEntered.text = ""
            confirmPasswordEntered.text = ""
            return
        } else {
            fullname = fullnameEntered.text!
            email = emailEntered.text!
            username = usernameEntered.text!
            password = passwordEntered.text!
            
            let u = User(fullName: fullname, email: email, username: username, password: password)
            
            usersList.userList.append(u)
            
            let plistDict: Dictionary<String,String> = [
                "fullName": fullname,
                "email": email,
                "username": username,
                "password": password
            ]
            
            Helper.saveUsersList(plistDict: plistDict)
            
            performSegue(withIdentifier: "SignupToLoginSegue", sender: self)
        }
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "SignupToLoginSegue", sender: self)
    }
    //Prepare the data for Signup-to-Login segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SignupToLoginSegue"){
            let loginVC = segue.destination as! LoginViewController
            loginVC.usersList = usersList
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
