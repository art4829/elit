//
//  Helper.swift
//  elit
//
//  Created by Abigail Tran on 5/5/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

class Helper{
    static var defaults = UserDefaults.standard
    
    static func setUsersList() -> Users{
        let usersList = Users()
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
        return usersList
    }
    
    static func saveUsersList(plistDict : Dictionary<String,String>) -> Void {
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
    }
    
    static func setFavMoviesList() -> FavMoviesList {
        let favMoviesList = FavMoviesList()
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
        return favMoviesList
    }
    
    
    static func setCurrentUser(user : User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: "user")
        }
        defaults.synchronize()
    }
    
    static func getCurrentUser() -> User {
        if let savedPerson = defaults.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                return loadedPerson
            }
        }
        return User()
    }
    
    static func setCurrentFavMovies(favMovies: FavMovies) -> Void {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favMovies) {
            defaults.set(encoded, forKey: "favMovies")
        }
        defaults.synchronize()
    }
    
    static func getCurrentFavMovies() -> FavMovies {
        if let savedFavMovies = defaults.object(forKey: "favMovies") as? Data {
            let decoder = JSONDecoder()
            if let loadedFavMovies = try? decoder.decode(FavMovies.self, from: savedFavMovies) {
                return loadedFavMovies
            }
        }
        return FavMovies()
    }
    
    static func alertUser(controller: UIViewController, message : String, title: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
