//
//  FavoriteMoviesTableVC.swift
//  elit
//
//  Created by Abigail Tran on 4/27/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import UIKit

class FavoriteMoviesTableVC: UITableViewController {

    var favMovies: FavMovies!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up favMovies
        if let savedFavMovies = UserDefaults.standard.object(forKey: "favMovies") as? Data {
            let decoder = JSONDecoder()
            if let loadedFavMovies = try? decoder.decode(FavMovies.self, from: savedFavMovies) {
                self.favMovies = loadedFavMovies
            }
        }
        if favMovies == nil {
            favMovies = FavMovies()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let savedFavMovies = UserDefaults.standard.object(forKey: "favMovies") as? Data {
            let decoder = JSONDecoder()
            if let loadedFavMovies = try? decoder.decode(FavMovies.self, from: savedFavMovies) {
                self.favMovies = loadedFavMovies
            }
        }
        if favMovies == nil {
            favMovies = FavMovies()
        }
        self.tableView.reloadData();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favMovies.movieList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)

            // Configure the cell...
        cell.textLabel?.text = favMovies.movieList[indexPath.row]["title"]
        var detailText = "No Rating"
        if (favMovies.movieList[indexPath.row]["rating"]!  != "") {
             detailText = "Rating: " + favMovies.movieList[indexPath.row]["rating"]!
        }
        cell.detailTextLabel?.text = detailText
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
