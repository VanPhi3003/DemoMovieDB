//
//  Movie.swift
//  MovieDBTableView
//
//  Created by Phi Trinh on 5/24/17.
//  Copyright © 2017 Phi Trinh. All rights reserved.
//

import Foundation

class Movie {
    var posterPath: String?
    var overview: String?
    var id: Int?
    var title: String?
    var voteAverage: Double?
    
    init(json: [String:Any]){
        posterPath = json["poster_path"] as? String
        overview = json["overview"] as? String
        id = json["id"] as? Int
        title = json["title"] as? String
        voteAverage = json["vote_average"] as? Double
    }
}
