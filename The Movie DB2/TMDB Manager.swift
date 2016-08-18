//
//  TMDB Manager.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/17/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TMDBMenager {
 
    static let sharedManager = TMDBMenager()
    
    let apiKey = "1a8cf68cea1be9ce3938eb5a6024d19a"
    var basicURL = "https://api.themoviedb.org/3"
    
    
 
    func fetchNowShowingMovies(){
        
        request(.GET,"https://api.themoviedb.org/3/genre/movie/list?api_key=1a8cf68cea1be9ce3938eb5a6024d19a").validate().responseJSON { (response) in
            switch response.result{
                
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
    
                                print(json)
    
    
                    
                }
            case .Failure(let error):
                print(error)
                
    
            }
        }
        
        req
    
    }
    
  

}

