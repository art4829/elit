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
    
    var loginVC : LoginViewController!
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
        performSegue(withIdentifier: "LogoutSegue", sender: self)
               UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
