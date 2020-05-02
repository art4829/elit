//
//  FirstViewController.swift
//  elit
//
//  Created by XCodeClub on 2020-04-02.
//  Copyright © 2020 Abhaya Tamrakar and Abigail Tran. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    //MARK: - Properties
    var viewModelData = [MovieCardModel]()

    var randomPages = [Int]()
    var replace_text = "page=1"
    var stackContainer : StackContainerView!
    var filterURL = ""
    var search_url = NOW_PLAYING_URL
    var favMovies : FavMovies!
    var total_pages = 1
    var nowPlaying = true
    var defaults = UserDefaults.standard
    
    var filterViewController : SlideMenuController!

    var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetup()
    }
    
    //MARK: - Configurations
    func configureStackContainer() {
//        self.view.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(Double(self.view.bounds.height)*0.15)).isActive = true
        stackContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -CGFloat(Double(self.view.bounds.height)*0.22)).isActive = true
        stackContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: CGFloat(Double(self.view.bounds.width)*0.1)).isActive = true
        stackContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -CGFloat(Double(self.view.bounds.width)*0.1)).isActive = true
    }
    func configureNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
    }
    
    //MARK: - Handlers
    @objc func resetTapped() {
        stackContainer.reloadData()
    }

    let transition = SlideInTransition()

    @IBAction func didTapFilter(_ sender: UIButton) {
        //Not sure if this has to be "guard"
//        guard let filterViewController = storyboard?.instantiateViewController(identifier: "SlideMenuController") else {return}
        filterViewController = storyboard?.instantiateViewController(identifier: "SlideMenuController")

        filterViewController.modalPresentationStyle = .overCurrentContext
        filterViewController.transitioningDelegate = self
        present(filterViewController, animated: true)
    }
    

    
    
    func viewLoadSetup(){
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
        
        // setup view did load here
        if filterViewController != nil {
            if filterViewController?.appliedFilter == true {
                nowPlaying = filterViewController.nowPlaying
                filterURL = filterViewController.filterURL
                randomPages = [Int]()
            } else {
                //Do not apply filter or reload the cards
                return
            }
        }
        if nowPlaying == true {
            defaults.set(0, forKey: "rating")
            defaults.set([], forKey: "genreList")
            defaults.set("All Languages", forKey: "language")
        }


        if nowPlaying == false {
        // if not filtered, present inital movies data, else get the filters cardmodel array
            search_url = filterURL
        }
        self.viewModelData = getMovies(filterURL: search_url)
        self.stackContainer = StackContainerView()
        self.view.addSubview(self.stackContainer)
        self.configureStackContainer()
        self.stackContainer.translatesAutoresizingMaskIntoConstraints = false
        self.configureNavigationBarButtonItem()
        self.stackContainer.dataSource = self
    }
    
    
    
    func getMovies(filterURL: String) -> [MovieCardModel]{
        print(filterURL)
           var moviesData = [MovieCardModel]()
           var furl = filterURL
           var url = URL(string: furl)!
           var data = try? Data(contentsOf: url)
           var randPageNum = 0
           
           // get the total pages number
           if let json = (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as? [String:Any]{
               self.total_pages = json["total_pages"] as! Int
               while true{
                randPageNum = Int.random(in: 1 ..< self.total_pages + 1)
                   if !randomPages.contains(randPageNum){
                       break
                   }
               }
               randomPages.append(randPageNum)
           }
 
            if nowPlaying {
                while true{
                    let a = furl.last
                    if a == "="{
                        break
                    }
                furl = String(furl.dropLast())
                }
                furl.append("\(randPageNum)")
            }else{
                let strIndex = furl.index(furl.startIndex, offsetBy: 154)
                let endIndex = furl.index(furl.startIndex, offsetBy: 155)

                furl = furl.replacingCharacters(in: strIndex..<endIndex, with: "\(randPageNum)")
            }
          
           // for every url, make request and add data to the card model and return it
           url = URL(string: furl)!
           data = try? Data(contentsOf: url)
           if let json = (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as? [String:Any]{

             if let mv = json["results"] as? Array<[String:Any]> {
                for m in mv {
                   if !(m["poster_path"] is NSNull){
                    let rating = "\(m["vote_average"] ?? "")"
                    let movie = MovieCardModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), text: m["title"] as! String, image: "https://image.tmdb.org/t/p/w780/" + (m["poster_path"] as! String), vote_average: rating )
                        moviesData.append(movie)
                    print(m["poster_path"] as! String)
                   }
                }
             }
           }
           return moviesData
       }
}

extension MoviesViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        viewDidLoad()
        return transition
    }
  }



extension MoviesViewController : SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.favMovies = favMovies
        card.dataSource = viewModelData[index]
        self.viewModelData.remove(at: index)
        if (index == numberOfCardsToShow() - 2){
//            print("YESSSSSS")
            if nowPlaying == false {
               search_url = filterURL
            }
            let movies = getMovies(filterURL: search_url)
            for movie in movies{
                self.viewModelData.append(movie)
            }
            self.stackContainer.dataSource = self
        }
       
        return card
    }
    
    func emptyView() -> UIView? {
        print("end")
        return nil
    }
    

}
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
}
