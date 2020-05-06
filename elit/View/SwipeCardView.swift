//
//  SwipeCardView.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 4/20/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class SwipeCardView : UIView {
   
    //MARK: - Properties
    var swipeView : UIView!
    var shadowView : UIView!
    var imageView = UIImageView()
    var image : UIImage!
  
    var label = UILabel()
    var moreButton = UIButton()
    
    var delegate : SwipeCardsDelegate?

    var divisor : CGFloat = 0
    let baseView = UIView()

    var favMovies: FavMovies!
    let defaults = UserDefaults.standard

    var parentMargins : UILayoutGuide!
    var parentSafeArea : UILayoutGuide!
    
    //Load the MovieCardModel of this card and create the label for the card
    var dataSource : MovieCard? {
        didSet {
            swipeView.backgroundColor = .clear
            
            if (dataSource!.getVoteAverage() != "") {
                let star = UIImage(systemName: "star")
                
                let attachment = NSTextAttachment()
                attachment.image = star
                let attachmentString = NSAttributedString(attachment: attachment)
                let titleString = NSMutableAttributedString(string: dataSource!.getTitle() + " - ")
                let ratingString = NSMutableAttributedString(string: String(dataSource!.getVoteAverage()))

                titleString.append(attachmentString)
                titleString.append(ratingString)
                label.attributedText = titleString
            } else {
                label.text = dataSource!.getTitle()
            }
            
            guard let image = dataSource?.getImage() else { return }
            imageView.downloaded(from: image)
        }
    }
    
    
    //MARK: - Init
     override init(frame: CGRect) {
        super.init(frame: .zero)
        self.restorationIdentifier = "SwipeCardView"
        configureShadowView()
        configureSwipeView()
        configureImageView()
        configureLabelView()
        addPanGestureOnCards()
        configureTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    func configureShadowView() {
        shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 4.0
        addSubview(shadowView)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func configureSwipeView() {
        swipeView = UIView()
        swipeView.layer.cornerRadius = 20
        swipeView.clipsToBounds = true
        shadowView.addSubview(swipeView)
        
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        swipeView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
        swipeView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
        swipeView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        swipeView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    }
    
    func configureLabelView() {
        swipeView.addSubview(label)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.backgroundColor = .white
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        label.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
    }
    
    func configureImageView() {
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        swipeView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -85).isActive = true
        imageView.leadingAnchor.constraint(equalTo: swipeView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: swipeView.trailingAnchor).isActive = true
    }

    func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! SwipeCardView
        let cardContent = card.dataSource!
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
       
        switch sender.state {
        case .ended:
            //Swipe Right
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                //Add the card to favorite movies
                if !favMovies!.hasMovie(movie: cardContent) {
                    let movie = ["title": cardContent.getTitle(), "rating" : cardContent.getVoteAverage()]
                    favMovies!.movieList.append(movie)
                }

                Helper.setCurrentFavMovies(favMovies: favMovies)
                return
            }
            //Swipe Left
            else if card.center.x < -35 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
    }
}

//The extension to download images from an URL
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async() {
                self.image = image
                group.leave()
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
