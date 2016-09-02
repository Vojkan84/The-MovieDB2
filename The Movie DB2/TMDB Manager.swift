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

//extension Provider{
//
//    public static func TMDB(ClientID ClientID:String,clientSecret:String,redirectUrl:String)->Provider{
//
//        let provider = Provider(clientID: ClientID,
//                                clientSecret: clientSecret,
//                                authorizeURL:"https://www.themoviedb.org/authenticate" ,
//                                tokenURL:"http://api.themoviedb.org/3/authentication/token/new" ,
//                                redirectURL: redirectUrl)
//        return provider
//    }
//
//}


class TMDB {
    
    static let shaedInstance = TMDB()
    
    var apiKey = "1a8cf68cea1be9ce3938eb5a6024d19a"
    
    var token:String?
    var sesionID:String?
    

    
    
 

    func fetchNowShowingMovies(result:(jasonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.nowShowingMovies, result: result)
    }
    func searchPerson(byName name:String,result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.searchPerson(byName: name), result: result)
    }
    func searchMovie(byTitle title:String,result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.searchMovie(byTitle: title), result: result)
    }
    func searchTVShow(byTitle title:String,result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.searchTVShow(byTitle: title), result: result)
    }
    func fetchPopularMovies(result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.popularMovies, result: result)
    }
    func fetchComingSoonMovies(result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.coomingSoonMovies, result: result)
    }
    func fetchShowingTodayTVShows(result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.showingTodayTVShows, result: result)
    }
    func fetchTopRatedTVShows(result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.topRatedTVShows, result: result)
    }
    func fetchPopularTVShows(result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.popularTVShows, result: result)
    }
    func fetchCredits(forMovieID movieID:String,result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.credits(forMovieID: movieID), result: result)
    }
    func fetchTVShowCredits(forTVShowID tvShowID:String,result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        getRequest(forPath: APIPath.tvShowCredits(forTVShowID: tvShowID), result: result)
    }
    func signUp(){
        
        if let url = NSURL(string: "https://www.themoviedb.org/account/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
//    func validateUser(withUsername username:String,password:String){
//        
//        let url =  "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)&request_token=a53847aa97d859289308cad093f6cc1764b756b6&username=\(username)&password=\(password)"
//        request(.GET, url).validate().responseJSON { (respond) in
//            switch respond.result{
//            case .Success(let jsonResult):
//                token = jsonResult["request_token"]
//            case.Failure(let error):
//                print(error)
//            }
//            
//        }
//        
//    }
    func validateUser(withUsername username:String,password:String){
        
        let url = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)&request_token=77e07a959e2d24e5ca19f6e1ba515297401c8be8&username=\(username)&password=\(password)"
        request(.GET, url).validate().responseJSON { (respose) in
            switch respose.result{
            case .Success(let jsonResult):
                
                print(jsonResult)
                let resolt = JSON(jsonResult)
                self.token = resolt["request_token"].stringValue
                
            case .Failure(let error):
                print(error)
            }
            let url = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(self.apiKey)&request_token=\(self.token)"
            
            request(.GET, url).validate().responseJSON{ (response) in
                switch respose.result{
                case .Success(let jsonResult):
                    print(jsonResult)
                    let resolt = JSON(jsonResult)
                    self.sesionID = resolt["session_id"].stringValue
                case .Failure(let error):
                    print(error)
                }
            }
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
    
    private func getRequest(forPath path:APIPath,result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        let mutableURLRequest = path.URLRequest
        
        var params = path.parametars
        params["api_key"] = apiKey
        
        mutableURLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
        
        let encoding = Alamofire.ParameterEncoding.URL
        let encodingResult = encoding.encode(mutableURLRequest, parameters: params)
        let fullMutableURLRequest = encodingResult.0
        
        
        
        request(fullMutableURLRequest).validate().responseJSON { (response) in
            
            switch response.result{
            case.Success(let jsonResult):
                return result(jsonResult: jsonResult, error: nil)
            case.Failure(let error):
                result(jsonResult: nil, error: error)
            }
            
        }
    }
}

