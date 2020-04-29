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

    
    //MARK: - Configurations
    func configureStackContainer() {
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
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
    

    var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetup()
    }
    
    func viewLoadSetup(){
        // setup view did load here
        if filterViewController != nil && filterViewController?.appliedFilter == true {
            nowPlaying = filterViewController.nowPlaying
            filterURL = filterViewController.filterURL
            randomPages = [Int]()
        }
        if nowPlaying == true {
            defaults.set(0, forKey: "rating")
            defaults.set([], forKey: "genreList")
            defaults.set("All Languages", forKey: "language")
        }
        if favMovies == nil {
            favMovies = FavMovies()
            favMovies.movieList = UserDefaults.standard.object(forKey: "parks") as? [String] ?? [String]()
        }
        //  print("FILTER URL: ", filterURL)
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
    //       furl = furl.replacingOccurrences(of: replace_text, with: "page=\(randPageNum)")
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
//                print(randPageNum)
                furl = furl.replacingCharacters(in: strIndex..<endIndex, with: "\(randPageNum)")
            }
          
           // for every url, make request and add data to the card model and return it
           url = URL(string: furl)!
           data = try? Data(contentsOf: url)
           if let json = (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as? [String:Any]{
//             print(url)
             if let mv = json["results"] as? Array<[String:Any]> {
                for m in mv {
                   if !(m["poster_path"] is NSNull){
                        let movie = MovieCardModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), text: m["title"] as! String, image: "https://image.tmdb.org/t/p/w500/" + (m["poster_path"] as! String))
                        moviesData.append(movie)
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
