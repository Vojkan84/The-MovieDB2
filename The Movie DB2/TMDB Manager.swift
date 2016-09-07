//
//  TMDB Manager.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/17/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyOAuth
import SwiftyJSON



class TMDB {
    
    static let shaedInstance = TMDB()
    
    private var apiKey = "1a8cf68cea1be9ce3938eb5a6024d19a"
    
    private var token:[String:String]?{
        
        didSet{
            if let accessToken = self.token{
                DefaultsKey.acessToken.save(accessToken)
            }
        }
    }
    private var sesionID:[String:String]?{
        didSet{
            if let sesionID = self.sesionID{
                DefaultsKey.sesiionId.save(sesionID)
            }
        }
    }
    

    
    
 

    func fetchNowShowingMovies(result:(jsonResult:JSON?,error:ErrorType?)->Void){
        
        getRequest(forPath: APIPath.nowShowingMovies, result: result)
    }
    func searchPerson(byName name:String,result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.searchPerson(byName: name), result: result)
    }
    func searchMovie(byTitle title:String,result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.searchMovie(byTitle: title), result: result)
    }
    func searchTVShow(byTitle title:String,result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.searchTVShow(byTitle: title), result: result)
    }
    func fetchPopularMovies(result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.popularMovies, result: result)
    }
    func fetchComingSoonMovies(result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.coomingSoonMovies, result: result)
    }
    func fetchShowingTodayTVShows(result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.showingTodayTVShows, result: result)
    }
    func fetchTopRatedTVShows(result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.topRatedTVShows, result: result)
    }
    func fetchPopularTVShows(result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.popularTVShows, result: result)
    }
    func fetchCredits(forMovieID movieID:String,result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.credits(forMovieID: movieID), result: result)
    }
    func fetchTVShowCredits(forTVShowID tvShowID:String,result:(jsonResult:JSON?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.tvShowCredits(forTVShowID: tvShowID), result: result)
    }
    func signUp(){
        
        if let url = NSURL(string: "https://www.themoviedb.org/account/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func loginWithUsername(username:String,and password:String){
        
        guard let _ = self.token else{
            
            let url = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)"
            request(.GET, url).validate().responseJSON { (response) in
                switch response.result{
                case .Success(let jsonResult):
                    
                    let result = JSON(jsonResult)
                    self.token = ["AcessToken":result["request_token"].stringValue]
                    self.validateUser(withUsername: "SpasicVojkan", password: "1Tihavodabregroni")
                    
                    print(self.token)
                case .Failure(let error):
                    self.token = nil
                    print(error)
                }
            }
            return
        }
        validateUser(withUsername: username, password:password)
    }

    func validateUser(withUsername username:String,password:String){
        
        if let tok = self.token!["AcessToken"]{
            
            let url = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(self.apiKey)&request_token=\(tok)&username=\(username)&password=\(password)"
            request(.GET, url).validate().responseJSON { (response) in
                switch response.result{
                case .Success(let jsonResult):
                    self.getSessionID()
                    print(jsonResult)
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getSessionID(){
        
        if let tok = self.token!["AcessToken"]{
            
            let url = "https://api.themoviedb.org/3/authentication/session/new?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&request_token=\(tok)"
            
            request(.GET, url).validate().responseJSON { (response) in
                switch response.result{
                case .Success(let jsonResult):
                    let result = JSON(jsonResult)
                    print(jsonResult)
                    self.sesionID = ["sesion_id":result["sesion_id"].stringValue]
                case .Failure(let error):
                    self.sesionID = nil
                    print(error)
                }
            }
        }
    }
   
    

    
    
    
}

// MARK: User Defaults
extension TMDB {
    private enum DefaultsKey:String{
        
        case acessToken = "AcessToken"
        case sesiionId = "session_id"
        
        func save(value:[String:String]){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(value, forKey: String(self))
        }
        func fetch () ->String?{
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.stringForKey(String(self))
        }
    }

}

extension TMDB {
    
    private enum APIPath:URLRequestConvertible {
        
        case nowShowingMovies
        case popularMovies
        case coomingSoonMovies
        case showingTodayTVShows
        case topRatedTVShows
        case popularTVShows
        case searchPerson(byName:String)
        case searchTVShow(byTitle:String)
        case searchMovie(byTitle:String)
        case credits(forMovieID:String)
        case tvShowCredits(forTVShowID:String)
        
        
        
        var fullURL:NSURL{
            //base URL
            let URL = NSURL(string: "https://api.themoviedb.org/3/")!
            
            switch self {
            case .nowShowingMovies:
                return URL.URLByAppendingPathComponent("movie/now_playing")
            case .coomingSoonMovies:
                return URL.URLByAppendingPathComponent("movie/upcoming")
            case .popularMovies :
                return URL.URLByAppendingPathComponent("movie/popular")
            case .popularTVShows :
                return URL.URLByAppendingPathComponent("tv/popular")
            case .showingTodayTVShows:
                return URL.URLByAppendingPathComponent("tv/airing today")
            case .topRatedTVShows :
                return URL.URLByAppendingPathComponent("tv/top_rated")
            case .searchPerson:
                return URL.URLByAppendingPathComponent("search/person")
            case .searchMovie:
                return URL.URLByAppendingPathComponent("search/movie")
            case .searchTVShow:
                return URL.URLByAppendingPathComponent("search/tv")
            case.credits(let movieID):
                return URL.URLByAppendingPathComponent("movie/\(movieID)/credits")
            case.tvShowCredits(let tvShowID):
                return URL.URLByAppendingPathComponent("tv/\(tvShowID)/credits")
                
                
            }
        }
        var parametars :[String:AnyObject]{
            var params = [String:AnyObject]()
            
            switch self{
            case .searchPerson(let name):
                params["query"] = name
            case .searchMovie(let title):
                params["query"] = title
            case .searchTVShow(let title):
                params["query"] = title
            default:
                break
            }
            return params
        }
        var URLRequest:NSMutableURLRequest{
            
            return NSMutableURLRequest(URL: self.fullURL)
            
            
        }
        
    }
    
    private func getRequest(forPath path:APIPath,result:(jsonResult:JSON?,error:ErrorType?)->Void){
        
        let mutableURLRequest = path.URLRequest
        
        var params = path.parametars
        params["api_key"] = apiKey
        
        mutableURLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
        
        let encoding = Alamofire.ParameterEncoding.URL
        let encodingResult = encoding.encode(mutableURLRequest, parameters: params)
        let fullMutableURLRequest = encodingResult.0
        
        
        
        request(fullMutableURLRequest).validate().responseJSON { (response) in
            
            switch response.result{
                
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    result(jsonResult: json, error: nil)
                }
            case .Failure(let error):
                result(jsonResult: nil, error: error)
                
                
            }
        }
    }
}


