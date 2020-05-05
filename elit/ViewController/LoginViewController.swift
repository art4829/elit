//
//  LoginViewController.swift
//  elit
//
//  ViewController to monitor and control logins of user.
//  Created by Abhaya Tamrakar and Abigail Tran on 4/5/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameEntered: UITextField!
    @IBOutlet weak var passwordEntered: UITextField!
    
    var usersList : Users!
    var favMoviesList : FavMoviesList!
    var username = ""
    var password = ""
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if (usersList == nil) {
            setUsersList()
        }
        if (favMoviesList == nil) {
            setFavMoviesList()
        }
        username = ""
        password = ""
    }
    
    // set users from plist
    func setUsersList() {
        usersList = Users()
        //Read in users plist
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentsPathURL.appendingPathComponent("users.plist")
            let pathString = path.path
            do {
                if !FileManager.default.fileExists(atPath: pathString) {
                    let bundle = Bundle.main.path(forResource: "users", ofType: "plist")!
                    try FileManager.default.copyItem(atPath: bundle, toPath: pathString)
                }
                
                let data = try Data(contentsOf: URL(fileURLWithPath: pathString))
                let tempArray = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as! [Dictionary<String, Any>]
                
                for dict in tempArray {
                    let fullName = dict["fullName"]! as! String
                    let email = dict["email"]! as! String
                    let username = dict["username"]! as! String
                    let password = dict["password"]! as! String
                    
                    let u = User(fullName: fullName, email: email, username: username, password: password)
                    
                    usersList.userList.append(u)
                }
            } catch {
                print(error)
            }
        }
    }
    
    // Set Favorite Movies for users from plist
    func setFavMoviesList() {
        favMoviesList = FavMoviesList()
        //Read in userFavMovies plist
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentsPathURL.appendingPathComponent("userFavMovies.plist")
            let pathString = path.path
            do {
                if !FileManager.default.fileExists(atPath: pathString) {
                    let bundle = Bundle.main.path(forResource: "userFavMovies", ofType: "plist")!
                    try FileManager.default.copyItem(atPath: bundle, toPath: pathString)
                }
                
                let data = try Data(contentsOf: URL(fileURLWithPath: pathString))
                let tempDict = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as! Dictionary<String, [Dictionary<String, String>]>
                
                
                for (username, favs) in tempDict {
                    let favList = FavMovies()
                    favList.username = username
                    favList.movieList = favs
                    favMoviesList.favMoviesList.append(favList)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func goToSignUp(_ sender: Any) {
        performSegue(withIdentifier: "LoginToSignUpSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LoginToSignUpSegue"){
            let signUpVC = segue.destination as! SignUpViewController
            signUpVC.usersList = usersList
        }
    }
    
    @IBAction func login(sender: UIButton) {
            
        //Check if the username and password are correct
        if (usernameEntered.text! == "" || passwordEntered.text! == "") {
            alertUser(message: "Please put in all fields")
            return
        }
        for user in usersList.userList {
            if (user.getUsername() == usernameEntered.text! && user.getPassword() == passwordEntered.text!) {
                username = user.getUsername();
                password = user.getPassword();
                self.user = user
            }
        }
        if (username != "" && password != "" && user != nil) {
            performSegue(withIdentifier: "LoginToHome", sender: self)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            setCurrentUser(user: user)
            setCurrentFavMovies(user: user)
        } else {
            alertUser(message: "Incorrect Username or Password")
        }
        
        view.endEditing(true) //dismiss the keyboard whenever you have multiple fields
    }
    
    func setCurrentUser(user : User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
        UserDefaults.standard.synchronize()
    }
    
    func setCurrentFavMovies(user : User){
        var currentFavMovies = FavMovies()
        currentFavMovies.username = user.getUsername()
        
        for favMovies in favMoviesList.favMoviesList {
            if favMovies.getUsername() == user.getUsername() {
                currentFavMovies = favMovies
            }
        }
        currentFavMovies.setCurrentFavMovies()
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
