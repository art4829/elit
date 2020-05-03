//
//  MovieCardModel.swift
//  elit
//
//  Created by Abigail Tran on 4/20/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//
import Foundation
import UIKit

struct MovieCardModel {
    
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
            self.vote_average = vote_average + "/10"
        }
    }
    
    func getTitle() -> String {
        title
    }
    
    func getDescription() -> String {
        description
    }
    
    func getGenre() -> String {
        genreList
    }
    
}


