//
//  SlideMenuController.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/14/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//
import Foundation
import UIKit

class CellClass: UITableViewCell {
}

class SlideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var actionbtn: GenreButton!
    @IBOutlet weak var comedyBtn: GenreButton!
    @IBOutlet weak var dramaBtn: GenreButton!
    @IBOutlet weak var animationBtn: GenreButton!
    @IBOutlet weak var romanceBtn: GenreButton!
    @IBOutlet weak var thrillerBtn: GenreButton!
    @IBOutlet weak var scifiBtn: GenreButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    
    
    var languageParam = "&language="
    var ratingParam = ""
    var genreParam = "&with_genres="
    let transparentView = UIView()
    let tableView = UITableView()
    var dataSource = [String]()
    var genreArray = Genres()
    var filterURL = DISCOVER_URL
    
    @IBAction func closeFilter(_ sender: UIButton) {
      
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        rating.rating = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        let url = URL(string: "\(GENREID_URL)api_key=\(API_KEY)")!
        print(url)
        let data = try? Data(contentsOf: url)
        if let json = (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as? [String:Any]{
            if let genres = json["genres"] as? Array<[String:Any]> {
               for genre in genres{
                    let g = Genre(name: genre["name"] as! String, id: genre["id"] as! Int)
                    print(g.getName())
                self.genreArray.genreList.append(g)
                }
            }
        }
    }
    
       // MARK: - IBActions
    @IBAction func dropDownClicked(_ sender: UIButton) {
        dataSource = ["English", "Spanish", "Korean", "Japanese"]
        addTansparentView(frame: dropDownBtn.frame)
    }
    
    @IBAction func actionClicked(_ sender: GenreButton) {
        actionbtn.buttonPressed()
        print("Clicked")
    }
    
    @IBAction func comedyClicked(_ sender: GenreButton) {
        comedyBtn.buttonPressed()
    }
    
    @IBAction func dramaclicked(_ sender: GenreButton) {
        dramaBtn.buttonPressed()
    }
    
    @IBAction func animationClicked(_ sender: GenreButton) {
        animationBtn.buttonPressed()
    }
    
    @IBAction func romanceClicked(_ sender: GenreButton) {
        romanceBtn.buttonPressed()
    }
    
    @IBAction func thrillerClicked(_ sender: GenreButton) {
        thrillerBtn.buttonPressed()
    }
    @IBAction func scifiClicked(_ sender: GenreButton) {
        //: Remember, sci-fi is sciencefiction in tmdb api
        scifiBtn.buttonPressed()
    }
    
    @IBAction func applyFilter(_ sender: UIButton) {
        print("Rating: \(rating.rating)")
        dismiss(animated: true)
        if rating.rating != 0 {
            ratingParam = "&vote_average.gte=\(rating.rating * 2)"
            filterURL = "\(DISCOVER_URL)\(ratingParam)"
        }
        print(filterURL)
        let genreIdList = getGenreIdList()
        if genreIdList.count != 0{
            print("list: \(genreIdList)")
            for (idx, element) in genreIdList.enumerated() {
                print(genreIdList.endIndex)
                    if idx != genreIdList.endIndex - 1 {
                        // handling the last element
                        genreParam = "\(genreParam)\(element)%2C"
                    }else{
                        genreParam = "\(genreParam)\(element)"
                    }
            }
            filterURL=("\(filterURL)\(genreParam)")
        }
        if dropDownBtn.titleLabel?.text != "All Languages"{
            print(LANG_DICT[(dropDownBtn.titleLabel?.text)!]!)
            filterURL=(filterURL + "\(languageParam)\(LANG_DICT[(dropDownBtn.titleLabel?.text)!]!)")
        }
        print(filterURL)
        //Segue way link
        
    }
    
    func getGenreIdList() -> [Int]{
        var genreIdList = [Int]()
        if self.actionbtn.isOn {
            genreIdList.append(genreArray.getId(name: "Action"))
        }
        if self.comedyBtn.isOn {
            genreIdList.append(genreArray.getId(name: "Comedy"))
        }
        if self.dramaBtn.isOn {
            genreIdList.append(genreArray.getId(name: "Drama"))
        }
        if self.animationBtn.isOn {
            genreIdList.append(genreArray.getId(name: "Animation"))
        }
        if self.romanceBtn.isOn {
            genreIdList.append(genreArray.getId(name: "Romance"))
        }
        if self.thrillerBtn.isOn {
            genreIdList.append(genreArray.getId(name: "Thriller"))
        }
        if self.scifiBtn.isOn {
           genreIdList.append(genreArray.getId(name: "Science Fiction"))
       }
        return genreIdList
    }
    
    @IBAction func clearClicked(_ sender: UIButton) {
        rating.rating = 0
        dropDownBtn.setTitle("All Languages", for: .normal)
        for btn in [self.actionbtn, self.comedyBtn, self.dramaBtn, self.animationBtn, self.romanceBtn, self.thrillerBtn, self.scifiBtn]{
            btn?.reset()
        }
    }
    
  
    // MARK: - DropDownMenu Config
     func addTansparentView(frame: CGRect){
         let window = UIApplication.shared.windows.first { $0.isKeyWindow }
         transparentView.frame = window?.frame ?? self.view.frame
         self.view.addSubview(transparentView)
         
         // add tableview for the dropdown button
         tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
         self.view.addSubview(tableView)
         
         transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
         tableView.reloadData()
         let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
         transparentView.addGestureRecognizer(tapgesture)
         transparentView.alpha = 0
         UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
             self.transparentView.alpha = 0.3
             self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: CGFloat(self.dataSource.count * 30))
         }, completion: nil)
    }
     
     @objc func removeTransparentView(){
         let frame = dropDownBtn.frame
         UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
             self.transparentView.alpha = 0
             self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
         }, completion: nil)
     }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = UIFont(name: ELIT_FONT, size: 14)
        cell.backgroundColor = SOYBEAN.withAlphaComponent(0.4)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownBtn.setTitle(dataSource[indexPath.row], for: .normal)
  
        removeTransparentView()
    }

   
}
