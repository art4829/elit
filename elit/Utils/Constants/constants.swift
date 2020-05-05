//
//  colorConstants.swift
//  elit
//
//  Created by Abhaya Tamrakar on 4/7/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation
import UIKit

//UserDefaults keys
let USER = "user"
let FAV_MOVIES = "favMovies"
let IS_LOGIN = "isLoggedIn"
let RATING = "rating"
let GENRE = "genreList"
let LANGUAGE = "language"
let ALL_LANGUAGES = "All Languages"

//PLIST FILE NAMES
let USERS_PLIST = "users"
let FAV_MOVIES_PLIST = "userFavMovies"

// Color Constants
let ECLIPSE = UIColor(red:0.20, green:0.19, blue:0.28, alpha:1.00)
let LIGHT_ECLIPSE = UIColor(red:0.39, green:0.38, blue:0.49, alpha:1.00)
let SOYBEAN = UIColor(red:0.84, green:0.77, blue:0.62, alpha:1.00)

// Api key
let API_KEY = "87c79f9342a6ad65c9524d97b0ca9a9d"

//default font
let ELIT_FONT = "Mukta Mahee"

//
let LANG_DICT = ["English": "en-US", "Spanish": "es", "Korean": "kr", "Japanese": "ja" ]
let ACTION_ID = 28
let ANIMATION_ID = 16
let COMEDY_ID = 35
let DRAMA_ID = 18
let ROMANCE_ID = 10749
let SCIFI_ID = 878
let THRILLER_ID = 53
let GENRE_DICT = ["Action": 28, "Animation": 16, "Comedy": 35, "Drama": 18, "Romance": 10749, "Science Fiction": 878, "Thriller": 53, "Adventure": 12, "Crime": 80, "Documentary": 99, "Family": 10751, "Fantasy": 14, "History": 36, "Horror": 27, "Music": 10402, "Mystery": 9648, "TV Movie": 10770, "War": 10752, "Western": 37]

// URLS
let DISCOVER_URL = "https://api.themoviedb.org/3/discover/movie?api_key=\(API_KEY)&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"

let NOW_PLAYING_URL = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)&page=1"
let GENREID_URL = "https://api.themoviedb.org/3/genre/movie/list?"
let IMAGE_URL = "https://image.tmdb.org/t/p/w780/"

// Messages
let DEFAULT_DESCRIPTIONS = "No descriptions yet!"
let DEFAULT_GENRE = "Not out yet!"

// Number Constants
let TAB_BAR_HEIGHT = 49.0

//Alert messages
let INCORRECT_USERNAME_PASSWORD = "Incorrect Username or Password"
let INVALID_EMAIL = "Invalid email format"
let PUT_ALL_FIELDS = "Please enter all required fields."
let CHOOSE_DIFFERENT_USERNAME = "Please choose a different username"
let CHOOSE_DIFFERENT_EMAIL = "Please choose a different email"
let CONFIRM_PASSWORD = "Passwords entered are not the same"
let USER_UDPATED = "User info is updated"
let NO_INTERNET = "You are not connected to the Internet"

