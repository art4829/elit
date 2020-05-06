//
//  MovieCardModel.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 4/20/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//
import Foundation
import UIKit

struct MovieCard {
    
    var bgColor: UIColor
    var title : String
    var vote_average: String
    var image : String
    var description: String
    var genreList: String
      
    init(bgColor: UIColor, text: String, image: String, vote_average: String, description: String, genreList: String) {
        self.bgColor = bgColor
        self.title = text
        self.image = image
        self.description = description
        self.genreList = genreList
        if (vote_average == "0") {
            self.vote_average = ""
        } else {
            //Change rating to base 5
            let rating = (Double(vote_average)!)/10 * 5
            let ratingStr :String = String(format:"%.1f", rating)
            self.vote_average = ratingStr + "/5"
        }
    }
    
    func getTitle() -> String {
        title
    }
    
    func getBgColor() -> UIColor {
        bgColor
    }
    
    func getVoteAverage() -> String {
        vote_average
    }
    
    func getImage() -> String {
        image
    }
    
    func getDescription() -> String {
        description
    }
    
    func getGenre() -> String {
        genreList
    }
    
}


