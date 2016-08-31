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
import Realm

class TMDB {
    
    static let shaedInstance = TMDB()
    
    
 
//    static let sharedManager = TMDBMenager()
//    
//    let apiKey = "1a8cf68cea1be9ce3938eb5a6024d19a"
//    var basicURL = "https://api.themoviedb.org/3"
//    var nowPlayingMovie = "/movie/now_playing"
//    
//    
// 
//    func fetchNowShowingMovies(result:(movies:RLMArray?,error:NSError?)->Void){
//        
//        var movies :RLMArray
//        
//        request(.GET,"https://api.themoviedb.org/3/movie/now_playing?api_key=1a8cf68cea1be9ce3938eb5a6024d19a").validate().responseJSON { (response) in
//            switch response.result{
//                
//            case .Success:
//                if let value = response.result.value{
//                    let json = JSON(value)
////                    print(json)
//                    for item in json["results"].arrayValue{
//                        
//                        let movieTitle = item["original_title"].stringValue
//                        let movieId = item["id"].stringValue
//                        let moviePosterPath = item["poster_path"].stringValue
//                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
//                        let overview = item["overview"].stringValue
//                        let realiseDate = item["release_date"].stringValue
//                        let genreIds = item["genre_ids"].arrayValue
//                        let backdropPath = item["backdrop_path"].stringValue
//                        var stringGenreIds = [String]()
//                        for genreId in genreIds{
//                            let stringGenreId = genreId.stringValue
//                            stringGenreIds.append(stringGenreId)
//                        }
//                        let movie = Movie()
//                            movie.movieTitle = movieTitle
//                            movie.movieID = movieId
//                            movie.youTubeKey =  nil
//                            movie.voteAverage = voteAverage
//                            movie.overview = overview
//                            movie.releaseDate = realiseDate
//                            movie.genreIds = stringGenreIds
//                            movie.moviePosterPath = moviePosterPath
//                            movie.backdropPath = backdropPath
//                        movies.addObject(movie)
//                        
//                    }
//                    result(movies: movies, error: nil)
////                    print(movies)
//    
//    
//                    
//                }
//            case .Failure(let error):
//                print(error)
//                
//    
//            }
//        }
//        
//    
//    }
//    func fetchComingSoonMovies(result:(movies:[Movie]?,error:NSError?)->Void){
//        
//        var movies :[Movie]=[]
//        
//        request(.GET,"https://api.themoviedb.org/3/movie/upcoming?api_key=1a8cf68cea1be9ce3938eb5a6024d19a").validate().responseJSON { (response) in
//            switch response.result{
//                
//            case .Success:
//                if let value = response.result.value{
//                    let json = JSON(value)
////                    print(json)
//                    for item in json["results"].arrayValue{
//                        
//                        let movieTitle = item["original_title"].stringValue
//                        let movieId = item["id"].stringValue
//                        let moviePosterPath = item["poster_path"].stringValue
//                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
//                        let overview = item["overview"].stringValue
//                        let realiseDate = item["release_date"].stringValue
//                        let genreIds = item["genre_ids"].arrayValue
//                        let backdropPath = item["backdrop_path"].stringValue
//                        var stringGenreIds = [String]()
//                        for genreId in genreIds{
//                            let stringGenreId = genreId.stringValue
//                            stringGenreIds.append(stringGenreId)
//                        }
//                        let movie = Movie(movieTitle: movieTitle,
//                            movieID: movieId,
//                            youTubeKey: nil,
//                            voteAverage: voteAverage,
//                            overview: overview,
//                            releaseDate: realiseDate,
//                            genreIds: stringGenreIds,
//                            moviePosterPath: moviePosterPath,
//                            backdropPath:backdropPath)
//                        movies.append(movie)
//                        
//                    }
//                    result(movies: movies, error: nil)
////                    print(movies)
//                    
//                    
//                    
//                }
//            case .Failure(let error):
//                print(error)
//                
//                
//            }
//        }
//        
//        
//    }
//    func fetchPopularMovies(result:(movies:[Movie]?,error:NSError?)->Void){
//        
//        var movies :[Movie]=[]
//        
//        request(.GET,"https://api.themoviedb.org/3/movie/popular?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&append_to_response=images").validate().responseJSON { (response) in
//            switch response.result{
//                
//            case .Success:
//                if let value = response.result.value{
//                    let json = JSON(value)
//                    print(json)
//                    for item in json["results"].arrayValue{
//                        
//                        let movieTitle = item["original_title"].stringValue
//                        let movieId = item["id"].stringValue
//                        let moviePosterPath = item["poster_path"].stringValue
//                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
//                        let overview = item["overview"].stringValue
//                        let realiseDate = item["release_date"].stringValue
//                        let genreIds = item["genre_ids"].arrayValue
//                        let backdropPath = item["backdrop_path"].stringValue
//                        var stringGenreIds = [String]()
//                        for genreId in genreIds{
//                            let stringGenreId = genreId.stringValue
//                            stringGenreIds.append(stringGenreId)
//                        }
//                        let movie = Movie(movieTitle: movieTitle,
//                            movieID: movieId,
//                            youTubeKey: nil,
//                            voteAverage: voteAverage,
//                            overview: overview,
//                            releaseDate: realiseDate,
//                            genreIds: stringGenreIds,
//                            moviePosterPath: moviePosterPath,
//                        backdropPath:backdropPath)
//                        movies.append(movie)
//                        
//                    }
//                    result(movies: movies, error: nil)
////                    print(movies)
//                    
//                    
//                    
//                }
//            case .Failure(let error):
//                print(error)
//                
//                
//            }
//        }
//        
//        
//    }
//    
//    func fetchPopularTVShows(result:(tvShows:[Movie]?,error:NSError?)->Void){
//        
//        var tvShows:[Movie] = []
//        
//        request(.GET,"https://api.themoviedb.org/3/tv/popular?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&append_to_response=images").validate().responseJSON { (response) in
//            switch response.result{
//                
//            case .Success:
//                if let value = response.result.value{
//                    let json = JSON(value)
//                    print(json)
//                    for item in json["results"].arrayValue{
//                        
//                        let movieTitle = item["original_title"].stringValue
//                        let movieId = item["id"].stringValue
//                        let moviePosterPath = item["poster_path"].stringValue
//                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
//                        let overview = item["overview"].stringValue
//                        let realiseDate = item["release_date"].stringValue
//                        let genreIds = item["genre_ids"].arrayValue
//                        let backdropPath = item["backdrop_path"].stringValue
//                        var stringGenreIds = [String]()
//                        for genreId in genreIds{
//                            let stringGenreId = genreId.stringValue
//                            stringGenreIds.append(stringGenreId)
//                        }
//                        let movie = Movie(movieTitle: movieTitle,
//                            movieID: movieId,
//                            youTubeKey: nil,
//                            voteAverage: voteAverage,
//                            overview: overview,
//                            releaseDate: realiseDate,
//                            genreIds: stringGenreIds,
//                            moviePosterPath: moviePosterPath,
//                            backdropPath:backdropPath)
//                        tvShows.append(movie)
//                        
//                    }
//                    result(tvShows: tvShows, error: nil)
//                    print(tvShows)
//                    
//                    
//                    
//                }
//            case .Failure(let error):
//                print(error)
//                
//                
//            }
//        }
//    }
//    func fetchTopRatedTVShows(result:(tvShows:[Movie]?,error:NSError?)->Void){
//        
//        var tvShows:[Movie] = []
//        
//        request(.GET,"https://api.themoviedb.org/3/tv/top_rated?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&append_to_response=images").validate().responseJSON { (response) in
//            switch response.result{
//                
//            case .Success:
//                if let value = response.result.value{
//                    let json = JSON(value)
//                    print(json)
//                    for item in json["results"].arrayValue{
//                        
//                        let movieTitle = item["original_name"].stringValue
//                        let movieId = item["id"].stringValue
//                        let moviePosterPath = item["poster_path"].stringValue
//                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
//                        let overview = item["overview"].stringValue
//                        let realiseDate = item["release_date"].stringValue
//                        let genreIds = item["genre_ids"].arrayValue
//                        let backdropPath = item["backdrop_path"].stringValue
//                        var stringGenreIds = [String]()
//                        for genreId in genreIds{
//                            let stringGenreId = genreId.stringValue
//                            stringGenreIds.append(stringGenreId)
//                        }
//                        let movie = Movie(movieTitle: movieTitle,
//                            movieID: movieId,
//                            youTubeKey: nil,
//                            voteAverage: voteAverage,
//                            overview: overview,
//                            releaseDate: realiseDate,
//                            genreIds: stringGenreIds,
//                            moviePosterPath: moviePosterPath,
//                            backdropPath:backdropPath)
//                        tvShows.append(movie)
//                        
//                    }
//                    result(tvShows: tvShows, error: nil)
////                    print(tvShows)
//                    
//                    
//                    
//                }
//            case .Failure(let error):
//                print(error)
//                
//                
//            }
//        }
//    }
//    func fetchShowingTodayTVShows(result:(tvShows:[Movie]?,error:NSError?)->Void){
//        
//        var tvShows:[Movie] = []
//        
//        request(.GET,"https://api.themoviedb.org/3/tv/airing_today?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&append_to_response=images").validate().responseJSON { (response) in
//            switch response.result{
//                
//            case .Success:
//                if let value = response.result.value{
//                    let json = JSON(value)
//                    print(json)
//                    for item in json["results"].arrayValue{
//                        
//                        let movieTitle = item["original_name"].stringValue
//                        let movieId = item["id"].stringValue
//                        let moviePosterPath = item["poster_path"].stringValue
//                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
//                        let overview = item["overview"].stringValue
//                        let realiseDate = item["release_date"].stringValue
//                        let genreIds = item["genre_ids"].arrayValue
//                        let backdropPath = item["backdrop_path"].stringValue
//                        var stringGenreIds = [String]()
//                        for genreId in genreIds{
//                            let stringGenreId = genreId.stringValue
//                            stringGenreIds.append(stringGenreId)
//                        }
//                        let movie = Movie(movieTitle: movieTitle,
//                            movieID: movieId,
//                            youTubeKey: nil,
//                            voteAverage: voteAverage,
//                            overview: overview,
//                            releaseDate: realiseDate,
//                            genreIds: stringGenreIds,
//                            moviePosterPath: moviePosterPath,
//                            backdropPath:backdropPath)
//                        tvShows.append(movie)
//                        
//                    }
//                    result(tvShows: tvShows, error: nil)
////                    print(tvShows)
//                    
//                    
//                    
//                }
//            case .Failure(let error):
//                print(error)
//                
//                
//            }
//        }
//    }
//    
//  
    func fetchNowShowingMovies(result:(jasonResult:AnyObject?,error:ErrorType?)->Void){
    
      getRequest(forPath: APIPath.nowShowingMovies, result: result)
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
        
        var fullURL:NSURL{
            //base URL
            let URL = NSURL(string: "https://api.themoviedb.org/3/")!
            
            switch self {
            case .nowShowingMovies:
                return URL.URLByAppendingPathComponent("movie/now_playing?api_key=1a8cf68cea1be9ce3938eb5a6024d19a")
            case .coomingSoonMovies:
                return URL.URLByAppendingPathComponent("movie/upcoming?")
            case .popularMovies :
                return URL.URLByAppendingPathComponent("movie/popular?")
            case .popularTVShows :
                return URL.URLByAppendingPathComponent("tv/popular?")
            case .showingTodayTVShows:
                return URL.URLByAppendingPathComponent("tv/airing today?")
            case .topRatedTVShows :
                return URL.URLByAppendingPathComponent("tv/top rated?")
            case .searchPerson:
                return URL.URLByAppendingPathComponent("search/person?")
            case .searchMovie:
                return URL.URLByAppendingPathComponent("search/movie?")
            case .searchTVShow:
                return URL.URLByAppendingPathComponent("search/tv?")
          
            }
        }
        var parametars :[String:AnyObject]{
            var params = [String:AnyObject]()
            
            switch self{
                case .searchPerson(let name):
                params["name"] = name
            default:
                break
            }
            return params
        }
        var URLRequest:NSMutableURLRequest{
            
            let mutableURLRequest = NSMutableURLRequest(URL: self.fullURL)
            
            var params = self.parametars
            
            let encoding = Alamofire.ParameterEncoding.URL
            let encodingResult = encoding.encode(mutableURLRequest, parameters: params)
            return encodingResult.0
        }
    
    }
    
    private func getRequest(forPath path:APIPath,result:(jsonResult:AnyObject?,error:ErrorType?)->Void){
        
        let mutableURLRequest = path.URLRequest
        mutableURLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
        req
        request(mutableURLRequest).validate().responseJSON { (response) in
            
            switch response.result{
            case.Success(let jsonResult):
                return result(jsonResult: jsonResult, error: nil)
            case.Failure(let error):
                result(jsonResult: nil, error: error)
            }

        }
    }
}

