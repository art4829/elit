//
//  FirstViewController.swift
//  elit
//
//  Created by XCodeClub on 2020-04-02.
//  Copyright © 2020 Abhaya Tamrakar and Abigail Tran. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    var movies = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(api_key)")!
        print(url)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                print(error.localizedDescription)
             } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              
              self.movies = dataDictionary["results"] as! [[String:Any]]     // instantiates variable movies as results then casts as dictionary
              
              print(dataDictionary)
              print(" \n Number of Dictionaries/Hashes: ", dataDictionary.count, "\n")
                  
              
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
             }
          }
          task.resume()
        
        // Do any additional setup after loading the view.
    }


}

