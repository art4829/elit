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

    
    var stackContainer : StackContainerView!
    var filterURL = ""
    var search_url = NOW_PLAYING_URL

    
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
        guard let filterViewController = storyboard?.instantiateViewController(identifier: "SlideMenuController") else {return}

        filterViewController.modalPresentationStyle = .overCurrentContext
        filterViewController.transitioningDelegate = self
        present(filterViewController, animated: true)
    }
    

    var movies = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FILTER URL: ", filterURL)
        if filterURL != ""{
             search_url = filterURL
        }
        self.viewModelData = getMovies(filterURL: search_url)
        self.stackContainer = StackContainerView()
        self.view.addSubview(self.stackContainer)
        self.configureStackContainer()
        self.stackContainer.translatesAutoresizingMaskIntoConstraints = false
        self.configureNavigationBarButtonItem()
        
        self.stackContainer.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func getMovies(filterURL: String) -> [MovieCardModel]{
        var moviesData = [MovieCardModel]()
        var furl = filterURL
        var moviesURLS = [String]()
        let url = URL(string: furl)!
        let data = try? Data(contentsOf: url)
        
        if let json = (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as? [String:Any]{
            let total_pages = json["total_pages"] as! Int
            var page_index = 1
            var replace_text = "page=\(page_index)"
            while(page_index < total_pages){
                furl = furl.replacingOccurrences(of: replace_text, with: "page=\(page_index)")
                replace_text = "page=\(page_index)"
                page_index += 1
                moviesURLS.append(furl)
                if page_index == 10{
                    break
                }
            }
        }
        print(moviesURLS.count)
       for val in moviesURLS{
        print(val)
        let url = URL(string: val)!
        let data = try? Data(contentsOf: url)
            if let json = (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as? [String:Any]{
              if let mv = json["results"] as? Array<[String:Any]> {
                 for m in mv {
                    if !(m["poster_path"] is NSNull){
                         let movie = MovieCardModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), text: m["title"] as! String, image: "https://image.tmdb.org/t/p/w500/" + (m["poster_path"] as! String))
                         moviesData.append(movie)
                    }
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

        return transition
    }
  }



extension MoviesViewController : SwipeCardsDataSource {

    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }

}
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
}
