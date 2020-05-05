//
//  SwipeCardView.swift
//  elit
//
//  Created by Abigail Tran on 4/20/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
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
    
    var dataSource : MovieCardModel? {
        didSet {
            swipeView.backgroundColor = .clear
            
            if (dataSource!.vote_average != "") {
                let star = UIImage(systemName: "star")
                
                let attachment = NSTextAttachment()
                attachment.image = star
                let attachmentString = NSAttributedString(attachment: attachment)
                let titleString = NSMutableAttributedString(string: dataSource!.title + " - ")
                let ratingString = NSMutableAttributedString(string: String(dataSource!.vote_average))

                titleString.append(attachmentString)
                titleString.append(ratingString)
                label.attributedText = titleString
            } else {
                label.text = dataSource!.getTitle()
            }
            
            guard let image = dataSource?.image else { return }
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
        configureButton()
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
//    override func layoutSubviews() {
//        if (imageView.frame.width != 0) {
//            label.widthAnchor.constraint(equalToConstant: imageView.frame.width * 0.9).isActive = true
//        }
//        if (imageView.image != nil) {
//            print(imageView.image!.size)
//        }
//    }
    
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
//        label.widthAnchor.constraint(equalToConstant: imageView.image?.size.width ?? imageView.bounds.width).isActive = true
       
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
    
    func configureButton() {
        label.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "plus-tab")?.withRenderingMode(.alwaysTemplate)
        moreButton.setImage(image, for: .normal)
        moreButton.tintColor = UIColor.red
        
        moreButton.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -15).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
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
                if !favMovies!.hasMovie(movie: cardContent) {
                    let movie = ["title": cardContent.getTitle(), "rating" : cardContent.vote_average]
                    favMovies!.movieList.append(movie)
                }

                favMovies.setCurrentFavMovies()
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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
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
            group.notify(queue: .main) {
                print(self.image as Any)
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
