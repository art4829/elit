//
//  ProfileViewController.swift
//  elit
//
//  Created by Abigail Tran on 5/1/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UILabel!
    
    var current : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedPerson = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                self.current = loadedPerson
            }
        }
        if current == nil {
            fullName.text! = ""
            username.text! = ""
            password.text! = ""
        } else {
            fullName.text! = current.getFullName()
            username.text! = current.getUsername()
            password.text! = current.getPassword()
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
    

    @IBAction func logout(_ sender: LoginButton) {
        
        var plistDict: Dictionary<String,[Dictionary<String, String>]> = [:]
        
        if let savedFavMovies = UserDefaults.standard.object(forKey: "favMovies") as? Data {
            let decoder = JSONDecoder()
            if let loadedFavMovies = try? decoder.decode(FavMovies.self, from: savedFavMovies) {
                plistDict[current.getUsername()] = loadedFavMovies.movieList
            }
        }
        
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentsPathURL.appendingPathComponent("userFavMovies.plist")

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
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        performSegue(withIdentifier: "LogoutSegue", sender: self)
    }
}
