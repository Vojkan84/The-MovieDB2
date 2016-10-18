//
//  TVShowService.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 10/18/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class TVShowService{
    
    static let sharedInstance = TVShowService()
    
     private var apiKey = "1a8cf68cea1be9ce3938eb5a6024d19a"
     private var baseUrl = "https://api.themoviedb.org/3"
    
}
//enum TVShowURL :String{
//    
//    case searchTVShow = "/search/tv"
//}


extension TVShowService{

    func searchTVShow(byText text:String,result:(tvShows:[TVShow]?,error:NSError?)->Void){
       
        request(.GET, "\(baseUrl)/search/tv?api_key=\(apiKey))&query=\(text)").validate().responseJSON { (response) in
            switch response.result{
            case .Failure(let error):
                result(tvShows: nil, error: error)
            case .Success:
                
                if let value = response.result.value{
                    let json = JSON(value)
                    let tvShows = self.parseTVShowJson(json)
                    result(tvShows: tvShows, error: nil)
                    
                }
            }
        }
    }
    
    func parseTVShowJson(json:JSON)->[TVShow]{
        var tvShows = [TVShow]()
        let tvShow = TVShow()
        tvShow.apiPage = json["page"].intValue
        for item in json["results"].arrayValue{
            tvShow.name = item["name"].stringValue
            tvShow.backdropPath = item["backdrop_path"].stringValue
            tvShow.posterPath = item["poster_path"].stringValue
            tvShow.firstAirDate = item["first_air_date"].stringValue
            tvShow.overview = item["overview"].stringValue
            tvShow.genreIds = item["genre_ids"].stringValue
            tvShow.popularity = item["popularity"].doubleValue
            tvShow.tvShowID = item["id"].intValue
            tvShow.voteAverage = item["vote_average"].doubleValue
            tvShow.voteCount = item["vote_count"].intValue
            tvShows.append(tvShow)
        }
        return tvShows
    }
    
}


