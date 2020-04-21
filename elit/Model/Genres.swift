//
//  Genres.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/19/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation

class Genres: NSObject {
    var genreList: [Genre] = []
    
    func getId(name: String) -> Int{
        for genre in genreList{
            if genre.getName() == name{
                return genre.getId()
            }
        }
        return -1
    }
}

