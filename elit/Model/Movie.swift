//
//  Movie.swift
//  elit
//
//  Created by Abigail Tran on 4/20/20.
//  Copyright © 2020 Abhaya Tamrakar. All rights reserved.
//

import Foundation

//["genre_ids": <__NSArrayI 0x600002231710>(
//28,
//27,
//878,
//53
//)
//, "adult": 0, "video": 0, "popularity": 263.064, "release_date": 2020-01-08, "original_language": en, "poster_path": /gzlbb3yeVISpQ3REd3Ga1scWGTU.jpg, "vote_average": 6.5, "title": Underwater, "overview": After an earthquake destroys their underwater station, six researchers must navigate two miles along the dangerous, unknown depths of the ocean floor to make it to safety in a race against time., "original_title": Underwater, "vote_count": 789, "backdrop_path": /ww7eC3BqSbFsyE5H5qMde8WkxJ2.jpg, "id": 443791]
class Movie: NSObject {
    private var id: Int = 0
    private var genreIds: [Int] = []
    private var popularity: Int = 0
    private var releaseDate: Date = Date.init()
    private var orginalLanguage: String = "en"
    private var posterPath: String = ""
    private var backdropPath: String = ""
    private var voteAverage : Float = 0
    private var title: String = ""
    private var originalTitle: String = ""
    private var overview: String = ""
    private var voteCount: Int = 0
    private var email: String = ""
    
    init(id: Int, genreIds: [Int], popularity: Int, releaseDate: Date, orginalLanguage: String, posterPath: String, backdropPath: String, voteAverage : Float, title: String, originalTitle: String, overview: String, voteCount: Int, email: String = "") {
        super.init()
    }
    
    func getId() -> Int {
        id
    }
    func set(id: Int) {
        self.id = id;
    }
    
    func getGenreIds() -> [Int] {
        genreIds
    }
    func set(genreIds: [Int]) {
        self.genreIds = genreIds
    }
    
    func getPopularity() -> Int {
        popularity
    }
    func set(popularity: Int) {
        self.popularity = popularity
    }
    
    func getReleaseDate() -> Date {
        releaseDate
    }
    func set(releaseDate : Date) {
        self.releaseDate = releaseDate
    }
    
    func getOriginalLanguage() -> String {
        orginalLanguage
    }
    func set(originalLanguage : String) {
        self.orginalLanguage = originalLanguage
    }
    
    func getPosterPath() -> String {
        posterPath
    }
    func set(posterPath: String) {
        self.posterPath = posterPath
    }
    
}
