//
//  MoviesViewController.swift
//  elit
//
//  Created by Abhaya Tamrakar and Abigail Tran on 2020-04-02.
//  Copyright © 2020 Abhaya Tamrakar and Abigail Tran. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    //MARK: - Properties
    var viewModelData = [MovieCardModel]()

    var randomPages = [Int]()
    var stackContainer : StackContainerView!
    var filterURL = ""
    var search_url = NOW_PLAYING_URL
    var favMovies : FavMovies!
    var total_pages = 1
    var nowPlaying = true
    var defaults = UserDefaults.standard
    var descriptionData = [MovieCardModel]()
    var filterViewController : SlideMenuController!

    var movies = [[String: Any]]()
    
    var transparentView = UIView()
    var whiteBG =  UIView()
    @IBOutlet weak var MovieNameLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var MovieGenresLabel: UILabel!
    @IBOutlet weak var GenreLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var MovieDescriptionText: UITextView!
    
    @IBOutlet weak var descriptionBG: UIView!
    
    @objc func showDescription(){
        var currentStack : [UIView] = []
        var currentCard : MovieCardModel

        for view in self.view.subviews {
          if view.restorationIdentifier == "StackContainerView" {
              currentStack = view.subviews
          }
        }
        //The currentStack has 3 items. The currentCard is the last item in the list
        currentCard = (currentStack[2] as! SwipeCardView).dataSource!
        print(currentCard.getTitle())

        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)

        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        let screenSize = UIScreen.main.bounds.size
        descriptionView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        descriptionView.frame = CGRect(x: screenSize.width * 0.075, y: screenSize.height, width: screenSize.width * 0.85, height: screenSize.height * 0.75)
        descriptionView.layer.cornerRadius = 20
        self.view.addSubview(descriptionView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeDescription))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(removeDescription))
        descriptionView.addGestureRecognizer(tapGesture)
        transparentView.addGestureRecognizer(tapGesture2)

        transparentView.alpha = 0

        descriptionBG.layer.cornerRadius = 30
        descriptionBG.backgroundColor = SOYBEAN.withAlphaComponent(0.3)

        MovieNameLabel.text = currentCard.getTitle()
        MovieDescriptionText.text = currentCard.getDescription()
        MovieDescriptionText.isUserInteractionEnabled = false
        MovieGenresLabel.text = currentCard.getGenre()

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
          self.descriptionView.isHidden = false
          self.transparentView.alpha = 0.7
          self.descriptionView.frame = CGRect(x: screenSize.width * 0.075, y: screenSize.height - (screenSize.height * 0.9), width: screenSize.width * 0.85, height: screenSize.height * 0.75)
        }, completion: nil )
    }
    
    @objc func removeDescription(){
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.descriptionView.isHidden = true

            self.descriptionView.frame = CGRect(x: screenSize.width * 0.075, y: screenSize.height, width: screenSize.width * 0.85, height: screenSize.height * 0.75)
        }, completion: nil )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionView.isHidden = true
        descriptionView.translatesAutoresizingMaskIntoConstraints = false

        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.black
        tabBar.unselectedItemTintColor = SOYBEAN.withAlphaComponent(0.6)
        
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
    

    
    //MARK: - Load Movies
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
    
    
    // Function to get all movies
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
                    let glist = m["genre_ids"] as! [Int]
                    print(glist)
                    var genreString = ""
                    if glist.count == 0{
                        genreString = DEFAULT_GENRE
                    } else{
                        for g in glist{
                           let key = (GENRE_DICT as NSDictionary).allKeys(for: g) as! [String]
                           let value = key[0]
                           genreString.append(value + ",")
                       }
                         genreString = String(genreString.dropLast())
                    }
                   
                    let overview = m["overview"] as! String == "" ? DEFAULT_DESCRIPTIONS : m["overview"] as! String
                    let movie = MovieCardModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), text: m["title"] as! String, image: "https://image.tmdb.org/t/p/w780/" + (m["poster_path"] as! String), vote_average: rating, description: overview, genreList: genreString)
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
            if nowPlaying == false {
               search_url = filterURL
            }
            let movies = getMovies(filterURL: search_url)
            for movie in movies{
                self.viewModelData.append(movie)
            }
            self.stackContainer.dataSource = self
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDescription))
        card.addGestureRecognizer(tapGesture)
        return card
    }
 
    
    func emptyView() -> UIView? {
        print("end")
        return nil
    }
}

