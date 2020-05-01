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
      
    init(bgColor: UIColor, text: String, image: String, vote_average: String) {
        self.bgColor = bgColor
        self.title = text
        self.image = image
        if (vote_average == "0") {
            self.vote_average = ""
        } else {
            self.vote_average = vote_average + "/10"
        }
        
    }
    
    func getTitle() -> String {
        title
    }
}

class FavMovies: NSObject{
    var movieList: [String] = []
    func hasMovie(movie : MovieCardModel) -> Bool {
        for m in self.movieList {
            if (m == movie.getTitle()) {
                return true
            }
        }
        return false
    }
}
