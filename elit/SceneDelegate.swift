//
//  SceneDelegate.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 2020-04-02.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//

import UIKit



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController!
    var globalUsersList : [User] = []
    var globalUserFavMovies : [FavMovies] = []
    let defaults = UserDefaults.standard
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        //Read in users plist
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentsPathURL.appendingPathComponent(USERS_PLIST + ".plist")
            let pathString = path.path
            do {
                if !FileManager.default.fileExists(atPath: pathString) {
                    let bundle = Bundle.main.path(forResource: USERS_PLIST, ofType: "plist")!
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
                    
                    globalUsersList.append(u)
                }
            } catch {
                print(error)
            }
        }
        
        //Read in userFavMovies plist
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = documentsPathURL.appendingPathComponent(FAV_MOVIES_PLIST + ".plist")
            let pathString = path.path
            do {
                if !FileManager.default.fileExists(atPath: pathString) {
                    let bundle = Bundle.main.path(forResource: FAV_MOVIES_PLIST, ofType: "plist")!
                    try FileManager.default.copyItem(atPath: bundle, toPath: pathString)
                }
                
                let data = try Data(contentsOf: URL(fileURLWithPath: pathString))
                let tempDict = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as! Dictionary<String, [Dictionary<String, String>]>
                
                
                for (username, favs) in tempDict {
                    let favList = FavMovies()
                    favList.username = username
                    favList.movieList = favs
                    globalUserFavMovies.append(favList)
                }
            } catch {
                print(error)
            }
        }
      
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        let loginViewController = window?.rootViewController as? LoginViewController
        
        let userList = Users()
        userList.userList = globalUsersList
        let favMoviesList = FavMoviesList()
        favMoviesList.favMoviesList = globalUserFavMovies
        
        loginViewController!.usersList = userList
        loginViewController!.favMoviesList = favMoviesList
        
        //If user has already logged in
        if isLoggedIn() && CheckInternet.Connection(){
            //Set the root view to be the home page
            self.window?.rootViewController = tabBarController
            
            //Get the current user
            //From the current user, get and set the current favMovies
            let currentUser = Helper.getCurrentUser()
            setCurrentFavMovies(user: currentUser, favMoviesList: favMoviesList)
        }
        
        let profileVC = tabBarController?.viewControllers![1] as? ProfileViewController
        profileVC!.usersList = userList
        profileVC!.favMoviesList = favMoviesList
    
    }

    func setCurrentFavMovies(user : User, favMoviesList : FavMoviesList){
        var currentFavMovies = FavMovies()
        currentFavMovies.username = user.getUsername()
        
        for favMovies in favMoviesList.favMoviesList {
            if favMovies.getUsername() == user.getUsername() {
                currentFavMovies = favMovies
            }
        }
        Helper.setCurrentFavMovies(favMovies: currentFavMovies)
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return defaults.bool(forKey: IS_LOGIN)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

