//
//  TVShow.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 10/18/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import RealmSwift

class TVShow:Object{

    override class func primaryKey()->String{
        return "tvShowID"
    }
    dynamic var tvShowID:Int = 0
    dynamic var name:String = ""
    dynamic var posterPath:String = ""
    dynamic var popularity:Double = 0.0
    dynamic var backdropPath:String = ""
    dynamic var voteAverage:Double = 0.0
    dynamic var overview:String = ""
    dynamic var firstAirDate:String = ""
    dynamic var genreIds:String = ""
    dynamic var voteCount:Int = 0
    
    dynamic var genreNames:String?{
        let ids = genreIds.componentsSeparatedByString(",")
        return convertGenreIDsToNames(ids)
    }
    func convertGenreIDsToNames(genreIds:[String])->String{
        
        var genreLocalNames = [String]()
        for id in genreIds{
            switch id {
            case "10759":
                genreLocalNames.append("Action $ Adventure")
            case "16":
                genreLocalNames.append("Animation")
            case "35":
                genreLocalNames.append("Comedy")
            case "80":
                genreLocalNames.append("Crime")
            case "99":
                genreLocalNames.append("Documentary")
            case "18":
                genreLocalNames.append("Drama")
            case "10751":
                genreLocalNames.append("Family")
            case "10762":
                genreLocalNames.append("Kids")
            case "9648":
                genreLocalNames.append("Mistery")
            case "10763":
                genreLocalNames.append("News")
            case "10764":
                genreLocalNames.append("Reality")
            case "10765":
                genreLocalNames.append("Sci-Fi & Fantasy")
            case "10766":
                genreLocalNames.append("Soap")
            case "10767":
                genreLocalNames.append("Talk")
            case "10768":
                genreLocalNames.append("War & Politics")
            case "37":
                genreLocalNames.append("Western")
            default:
                return ""
            }
        }
        return genreLocalNames.joinWithSeparator(",")
    }
    dynamic var posterURL:NSURL?{
        
        let path = posterPath
            if path.containsString(".jpg"){
                let posterPath = "https://image.tmdb.org/t/p/w342\(path)"
                
                return NSURL(string:posterPath)
            }
        return nil
    }
    dynamic var backdropUrl:NSURL?{
        let path = backdropPath
        if path.containsString(".jpg"){
            let fullBackdropPath = "https://image.tmdb.org/t/p/w1280\(path)"
            return NSURL(string:fullBackdropPath)
        }
        return nil
    }

}
