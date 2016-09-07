//
//  Data Model.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/18/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import RealmSwift




class Movie:Object{
    
    override class func primaryKey() -> String {
        return "movieID"
    }
    
    dynamic var movieTitle:String = ""
    dynamic var movieID:String = ""
    dynamic var movieList:String = ""
    dynamic var youTubeKey:String?
    dynamic var voteAverage: Double = 0.0
    dynamic var overview:String = ""
    dynamic var releaseDate:String = ""
    dynamic var genreIds : String = ""
    //    dynamic var genreNames:String?{
    //        return convertGenreIDsToNames()
    //    }
    
    dynamic var moviePosterPath:String?
    dynamic var backdropPath:String?
    dynamic var moviePosterUrl:NSURL?{
        
        if let path = moviePosterPath{
            let posterPath = "https://image.tmdb.org/t/p/w342\(path)"
            return NSURL(string:posterPath)
        }
        return nil
    }
    dynamic var backdropUrl:NSURL?{
        if let path = backdropPath{
        let backdropPath = "https://image.tmdb.org/t/p/w1280\(path)"
        return NSURL(string:backdropPath)
        }
        return nil
    }
    //    func convertGenreIDsToNames()->String{
    //
    //        var genreLocalNames = [String]()
    //        for genreId in genreIds{
    //            switch genreId {
    //            case "28":
    //                genreLocalNames.append("Action")
    //            case "12":
    //                genreLocalNames.append("Adventure")
    //            case "16":
    //                genreLocalNames.append("Animation")
    //            case "35":
    //                genreLocalNames.append("Comedy")
    //            case "80":
    //                genreLocalNames.append("Crime")
    //            case "99":
    //                genreLocalNames.append("Documentary")
    //            case "18":
    //                genreLocalNames.append("Drama")
    //            case "10751":
    //                genreLocalNames.append("Family")
    //            case "14":
    //                genreLocalNames.append("Fantasy")
    //            case "10769":
    //                genreLocalNames.append("Foreign")
    //            case "36":
    //                genreLocalNames.append("History")
    //            case "27":
    //                genreLocalNames.append("Horor")
    //            case "10402":
    //                genreLocalNames.append("Music")
    //            case "9648":
    //                genreLocalNames.append("Mystery")
    //            case "10749":
    //                genreLocalNames.append("Romance")
    //            case "878":
    //                genreLocalNames.append("Science Fiction")
    //            case "10770":
    //                genreLocalNames.append("TV Movie")
    //            case "53":
    //                genreLocalNames.append("Thriller")
    //            case "10752":
    //                genreLocalNames.append("War")
    //            case "37":
    //                genreLocalNames.append("Western")
    //            default:
    //                return ""
    //            }
    //        }
    //        return genreLocalNames.joinWithSeparator(",")
    //    }
    
    
    
    
}
