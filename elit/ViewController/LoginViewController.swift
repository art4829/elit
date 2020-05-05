//
//  LoginViewController.swift
//  elit
//
//  ViewController to monitor and control logins of user.
//  Created by Abhaya Tamrakar and Abigail Tran on 4/5/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameEntered: UITextField!
    @IBOutlet weak var passwordEntered: UITextField!
    
    let defaults = UserDefaults.standard
    var user : User!
    var usersList : Users!
    var favMoviesList : FavMoviesList!
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //If there is a new user signing up
        if CheckInternet.Connection() == false{
            let alert = UIAlertController(title: "Alert", message: "You are not connected to the Internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {(action:UIAlertAction!) in
               exit(0)
            }))
            DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            }
        }
        
        //Initial set up
        if (usersList == nil) {
            usersList = Helper.setUsersList()
        }
        if (favMoviesList == nil) {
            favMoviesList = Helper.setFavMoviesList()
        }
        username = ""
        password = ""
        usernameEntered.delegate = self
        passwordEntered.delegate = self
    }
    
    //If the user press return / hit enter key, the keyboard will dissapear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }

    @IBAction func goToSignUp(_ sender: Any) {
        performSegue(withIdentifier: "LoginToSignUpSegue", sender: self)
    }
    //Prepare the data for SignupViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LoginToSignUpSegue"){
            let signUpVC = segue.destination as! SignUpViewController
            signUpVC.usersList = usersList
        }
    }
    
    @IBAction func login(sender: UIButton) {
        //Check if the username and password are empty
        if (usernameEntered.text! == "" || passwordEntered.text! == "") {
            Helper.alertUser(controller: self, message: "Please put in all fields", title: "Error")
            return
        }
        //Check is the login information are correct
        for user in usersList.userList {
            if (user.getUsername() == usernameEntered.text! && user.getPassword() == passwordEntered.text!) {
                username = user.getUsername();
                password = user.getPassword();
                self.user = user
            }
        }
        if (username != "" && password != "" && user != nil) {
            performSegue(withIdentifier: "LoginToHome", sender: self)
            defaults.set(true, forKey: "isLoggedIn")
            Helper.setCurrentUser(user: user)
            setCurrentFavMoviesForUser(user: user)
        } else {
            Helper.alertUser(controller: self, message: "Incorrect Username or Password", title: "Error")
        }
        
        view.endEditing(true) //dismiss the keyboard whenever you have multiple fields
    }
    
    func setCurrentFavMoviesForUser(user : User){
        var currentFavMovies = FavMovies()
        currentFavMovies.username = user.getUsername()
        
        for favMovies in favMoviesList.favMoviesList {
            if favMovies.getUsername() == user.getUsername() {
                currentFavMovies = favMovies
            }
        }
        Helper.setCurrentFavMovies(favMovies: currentFavMovies)
    }
    
    @IBAction func textFieldReturn(sender: UITextField) {
        sender.resignFirstResponder()
    }

}

//Hide the keyboard when users tap anywhere else
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
