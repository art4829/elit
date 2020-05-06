//
//  ProfileViewController.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 5/1/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var password: LoginTextField!
    @IBOutlet weak var username: LoginTextField!
    
    let defaults = UserDefaults.standard
    var current : User!
    var usersList : Users!
    var favMovies: FavMovies!
    var favMoviesList: FavMoviesList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        password.delegate = self
        username.delegate = self
        setupView()
    }
    
    //When user hit enter key, the keyboard should go away
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
    
    func setupView() {
        //Set uup current user
        self.current = Helper.getCurrentUser()
        
        //Set up favMovies
        self.favMovies = Helper.getCurrentFavMovies()

        if current == nil {
            fullName.text! = ""
            username.text! = ""
            password.text! = ""
        } else {
            fullName.text! = current.getFullName()
            username.placeholder = current.getUsername()
            password.placeholder = current.getPassword()
        }
        if (usersList == nil) {
            usersList = Helper.setUsersList()
        }
        if (favMoviesList == nil) {
            favMoviesList = Helper.setFavMoviesList()
        }
    }
    
    @IBAction func updateProfile(_ sender: UIButton) {
        //Check empty strings:
        if (username.text == "") {
            username.text = current.getUsername()
        }
        if (password.text == "") {
            password.text = current.getPassword()
        }
        
        //If the user didn't change anything, do nothing
        if (username.text == current.getUsername() && password.text! == current.getPassword()) {
            return
        }
        
        let oldUserName = current.getUsername()
        //Check username existed (not the current username)
        for oldUser in usersList.userList {
            if (oldUser.getUsername() != oldUserName && username!.text! == oldUser.getUsername()) {
                Helper.alertUser(controller: self, message: CHOOSE_DIFFERENT_USERNAME, title: "Error")
                username.text = current.getUsername()
                password.text = current.getPassword()
                return
            }
        }
        
        //Set current user
        current.set(username: username.text!)
        current.set(password: password.text!)
        Helper.setCurrentUser(user: current)
        
        //new username
        let newUserName = current.getUsername()
        
        //Replace the old user in the userList with the new user
        for oldUser in usersList.userList {
            if (oldUser.getUsername() == oldUserName) {
                if let index = usersList.userList.firstIndex(of: oldUser) {
                    usersList.userList.remove(at: index)
                }
                usersList.userList.append(current)
            }
        }
        
        //Save the new user
        if let documentsPathURL2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path2 = documentsPathURL2.appendingPathComponent(USERS_PLIST + ".plist")

            do {
                let data2 = try Data(contentsOf: URL(fileURLWithPath: path2.path))
                var tempArray = try PropertyListSerialization.propertyList(from: data2, format: nil) as! [Dictionary<String, String>]
                
            
                for u in tempArray {
                    if u["username"] == oldUserName {
                        if let index = tempArray.firstIndex(of: u) {
                            let oldUser = tempArray.remove(at: index)
                            let newUser : Dictionary<String,String> = [
                                "fullName": oldUser["fullName"]!,
                                "email": oldUser["email"]!,
                                "username": username.text!,
                                "password": password.text!
                            ]
                            tempArray.append(newUser)
                        }
                    }
                }
                let plistData2 = try PropertyListSerialization.data(fromPropertyList: tempArray, format: .xml, options: 0)
                

                 try plistData2.write(to: path2)
                
            } catch {
                print(error)
            }
        }
        
        //If the username change:
        if (newUserName != oldUserName) {
            //Update the current faveMovies
            favMovies.username = newUserName
            Helper.setCurrentFavMovies(favMovies: favMovies)
            
            //Replace the faveMovies in the faveMoviesList
            for oldFavMovies in favMoviesList.favMoviesList {
                if oldFavMovies.getUsername() == oldUserName {
                    oldFavMovies.username = newUserName
                }
            }
            
            //Save the new favMoviesList
            if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = documentsPathURL.appendingPathComponent(FAV_MOVIES_PLIST + ".plist")

                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path.path))
                    var tempDict = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as! Dictionary<String, [Dictionary<String, String>]>
                    tempDict.removeValue(forKey: oldUserName)
                    tempDict[newUserName] = favMovies.movieList
                
                    let plistData = try PropertyListSerialization.data(fromPropertyList: tempDict, format: .xml, options: 0)

                    try plistData.write(to: path)
                    
                } catch {
                    print(error)
                }
            }
        }
        
        Helper.alertUser(controller: self, message: USER_UDPATED, title: "Updated!")
        self.setupView()
    }
    
    @IBAction func logout(_ sender: LoginButton) {
        
        var plistDict: Dictionary<String,[Dictionary<String, String>]> = [:]
        
        let loadedFavMovies = Helper.getCurrentFavMovies()
        plistDict[current.getUsername()] = loadedFavMovies.movieList
        
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentsPathURL.appendingPathComponent(FAV_MOVIES_PLIST + ".plist")

            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path.path))
                var tempDict = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as! Dictionary<String, [Dictionary<String, String>]>
                
                tempDict[current.getUsername()] = plistDict[current.getUsername()]
            
                
                let plistData = try PropertyListSerialization.data(fromPropertyList: tempDict, format: .xml, options: 0)
               

                try plistData.write(to: path)
                
            } catch {
                print(error)
            }
        }
        defaults.set(false, forKey: IS_LOGIN)
        performSegue(withIdentifier: "LogoutSegue", sender: self)
    }
}
