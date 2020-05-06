//
//  FavoriteMoviesTableVC.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 4/27/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//

import UIKit

class FavoritesTableController: UITableViewController {

    let defaults = UserDefaults.standard
    var favMovies: FavMovies!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = ECLIPSE.withAlphaComponent(0.9)
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
        self.tableView.reloadData();
    }
    
    func setUpView() {
        self.favMovies = Helper.getCurrentFavMovies()
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
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = LIGHT_ECLIPSE
        }
        cell.tintColor = UIColor.white
        return cell
    }
    
    @IBAction func startEditing(_ sender: UIBarButtonItem) {
        isEditing = !isEditing
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favMovies.movieList.remove(at: indexPath.row)
            Helper.setCurrentFavMovies(favMovies: favMovies)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = favMovies.movieList[fromIndexPath.row]
        favMovies.movieList.remove(at: fromIndexPath.row)
        favMovies.movieList.insert(itemToMove, at: to.row)
        Helper.setCurrentFavMovies(favMovies: favMovies)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
