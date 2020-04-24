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
        let url = URL(string: search_url)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                print(error.localizedDescription)
             } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              
                print(dataDictionary)
                self.movies = dataDictionary["results"] as! [[String:Any]]     // instantiates variable movies as results then casts as dictionary
//                print(" \n Number of Dictionaries/Hashes: ", (dataDictionary["results"] as! Array<Any>).count, "\n")

                for m in self.movies {
                    var movie = MovieCardModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), text: m["title"] as! String, image: "https://image.tmdb.org/t/p/w500/" + (m["poster_path"] as! String))
                    self.viewModelData.append(movie);
                }

                self.stackContainer = StackContainerView()
                self.view.addSubview(self.stackContainer)
                self.configureStackContainer()
                self.stackContainer.translatesAutoresizingMaskIntoConstraints = false
                self.configureNavigationBarButtonItem()
                
                self.stackContainer.dataSource = self
                
             }
          }
        
        task.resume()
        
        
        // Do any additional setup after loading the view.
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
