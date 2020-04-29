//
//  colorConstants.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/7/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

// Color Constants
let ECLIPSE = UIColor(red:0.20, green:0.19, blue:0.28, alpha:1.00)
let SOYBEAN = UIColor(red:0.84, green:0.77, blue:0.62, alpha:1.00)

// Api key
let API_KEY = "87c79f9342a6ad65c9524d97b0ca9a9d"

//defualt font
let ELIT_FONT = "Mukta Mahee"

//
let LANG_DICT = ["English": "en-US", "Spanish": "es", "Korean": "kr", "Japanese": "ja" ]
let ACTION_ID = 28
let ANIMATION_ID = 12
let COMEDY_ID = 35
let DRAMA_ID = 18
let ROMANCE_ID = 10749
let SCIFI_ID = 878
let THRILLER_ID = 53
let GENRE_DICT = ["Action": 28, "Animation": 12, "Comedy": 35, "Drama": 18, "Romance": 10749, "Science Fiction": 878, "Thriller": 53]


// URLS
let DISCOVER_URL = "https://api.themoviedb.org/3/discover/movie?api_key=\(API_KEY)&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
let PAGE_INDEX = 154
let NOW_PLAYING_URL = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)&page=1"
let GENREID_URL = "https://api.themoviedb.org/3/genre/movie/list?"
