//
//  ProfileUpdateViewController.swift
//  elit
//
//  Created by Abigail Tran on 5/4/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit

class ProfileUpdateViewController: UIViewController {
    var current : User!
    var usersList : Users!
    var favMovies: FavMovies!
    var favMoviesList: FavMoviesList!
    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (current == nil) {
            if let savedPerson = UserDefaults.standard.object(forKey: "user") as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                    self.current = loadedPerson
                }
            }
        }
        
        //Populate fields with current info
        fullname.text = current.getFullName()
        username.text = current.getUsername()
        password.text = current.getPassword()
        
        //Set up favMovies
        if let savedFavMovies = UserDefaults.standard.object(forKey: "favMovies") as? Data {
            let decoder = JSONDecoder()
            if let loadedFavMovies = try? decoder.decode(FavMovies.self, from: savedFavMovies) {
                self.favMovies = loadedFavMovies
            }
        }
        
        setUsersList()
        
        setFavMoviesList()

    }

    
    @IBAction func saveProfile(_ sender: UIButton) {
        let oldUserName = current.getUsername()
        //Check empty strings:
        if (fullname.text! == "" || username.text! == "" || password.text! == "") {
            alertUser(message: "Please don't leave any field empty!")
            return
        }
        
        //If the user didn't change anything, close the window
        if (fullname.text! == current.getFullName() && username.text! == current.getUsername() && password.text! == current.getPassword()) {
            self.dismiss(animated: true, completion: nil)
        }
        
        //Check username existed (not the current username)
        for oldUser in usersList.userList {
            if (oldUser.getUsername() != oldUserName && username!.text! == oldUser.getUsername()) {
                alertUser(message: "Please choose a different username")
                username.text = ""
                return
            }
        }
        
        
        //Set current user
        current.set(fullName: fullname.text!)
        current.set(username: username.text!)
        current.set(password: password.text!)
        setCurrentUser(user: current)
        
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
            let path2 = documentsPathURL2.appendingPathComponent("users.plist")

            do {
                let data2 = try Data(contentsOf: URL(fileURLWithPath: path2.path))
                var tempArray = try PropertyListSerialization.propertyList(from: data2, format: nil) as! [Dictionary<String, String>]
                
            
                for u in tempArray {
                    if u["username"] == oldUserName {
                        if let index = tempArray.firstIndex(of: u) {
                            let oldUser = tempArray.remove(at: index)
                            let newUser : Dictionary<String,String> = [
                                "fullName": fullname.text!,
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
            favMovies.setCurrentFavMovies()
            
            //Replace the faveMovies in the faveMoviesList
            for oldFavMovies in favMoviesList.favMoviesList {
                if oldFavMovies.getUsername() == oldUserName {
                    oldFavMovies.username = newUserName
                }
            }
            
            //Save the new favMoviesList
            if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = documentsPathURL.appendingPathComponent("userFavMovies.plist")
                print(path.path)

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
    
        
//        self.dismiss(animated: true) {
//          if let parent = self.presentingViewController {
//            let viewProfileVC = parent as! ProfileViewController
//            viewProfileVC.loadView()
//          }
//        }
        performSegue(withIdentifier: "ViewProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ViewProfile"){
            let profileVC = segue.destination as! ProfileViewController
            profileVC.current = current
            profileVC.usersList = usersList
        }
    }
    
    func alertUser(message : String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setCurrentUser(user : User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
        UserDefaults.standard.synchronize()
    }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
