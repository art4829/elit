//
//  FavMovies.swift
//  elit
//
//  Created by Abigail Tran on 5/2/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation

class FavMovies: NSObject, Encodable, Decodable{
    var movieList: [Dictionary<String, String>] = []
    var username: String = ""
    
    func getUsername() -> String {
        username
    }
    func hasMovie(movie : MovieCard) -> Bool {
        for dict in self.movieList {
            for (key, value) in dict {
                if (key == "title" && value == movie.getTitle()) {
                    return true
                }
            }

        }
        return false
    }
}
