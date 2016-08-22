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
    var nowPlayingMovie = "/movie/now_playing"
    
    
 
    func fetchNowShowingMovies(result:(movies:[Movie]?,error:NSError?)->Void){
        
        var movies :[Movie]=[]
        
        request(.GET,"https://api.themoviedb.org/3/movie/now_playing?api_key=1a8cf68cea1be9ce3938eb5a6024d19a").validate().responseJSON { (response) in
            switch response.result{
                
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
//                    print(json)
                    for item in json["results"].arrayValue{
                        
                        let movieTitle = item["original_title"].stringValue
                        let movieId = item["id"].stringValue
                        let moviePosterPath = item["poster_path"].stringValue
                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
                        let overview = item["overview"].stringValue
                        let realiseDate = item["release_date"].stringValue
                        let genreIds = item["genre_ids"].arrayValue
                        let backdropPath = item["backdrop_path"].stringValue
                        var stringGenreIds = [String]()
                        for genreId in genreIds{
                            let stringGenreId = genreId.stringValue
                            stringGenreIds.append(stringGenreId)
                        }
                        let movie = Movie(movieTitle: movieTitle,
                            movieID: movieId,
                            youTubeKey: nil,
                            voteAverage: voteAverage,
                            overview: overview,
                            releaseDate: realiseDate,
                            genreIds: stringGenreIds,
                            moviePosterPath: "https://image.tmdb.org/t/p/w342\(moviePosterPath)",
                            backdropPath: "https://image.tmdb.org/t/p/w1280\(backdropPath)")
                        movies.append(movie)
                        
                    }
                    result(movies: movies, error: nil)
//                    print(movies)
    
    
                    
                }
            case .Failure(let error):
                print(error)
                
    
            }
        }
        
    
    }
    func fetchComingSoonMovies(result:(movies:[Movie]?,error:NSError?)->Void){
        
        var movies :[Movie]=[]
        
        request(.GET,"https://api.themoviedb.org/3/movie/upcoming?api_key=1a8cf68cea1be9ce3938eb5a6024d19a").validate().responseJSON { (response) in
            switch response.result{
                
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
//                    print(json)
                    for item in json["results"].arrayValue{
                        
                        let movieTitle = item["original_title"].stringValue
                        let movieId = item["id"].stringValue
                        let moviePosterPath = item["poster_path"].stringValue
                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
                        let overview = item["overview"].stringValue
                        let realiseDate = item["release_date"].stringValue
                        let genreIds = item["genre_ids"].arrayValue
                        let backdropPath = item["backdrop_path"].stringValue
                        var stringGenreIds = [String]()
                        for genreId in genreIds{
                            let stringGenreId = genreId.stringValue
                            stringGenreIds.append(stringGenreId)
                        }
                        let movie = Movie(movieTitle: movieTitle,
                            movieID: movieId,
                            youTubeKey: nil,
                            voteAverage: voteAverage,
                            overview: overview,
                            releaseDate: realiseDate,
                            genreIds: stringGenreIds,
                            moviePosterPath: "https://image.tmdb.org/t/p/w342\(moviePosterPath)",
                            backdropPath:"https://image.tmdb.org/t/p/w1280\(backdropPath)")
                        movies.append(movie)
                        
                    }
                    result(movies: movies, error: nil)
//                    print(movies)
                    
                    
                    
                }
            case .Failure(let error):
                print(error)
                
                
            }
        }
        
        
    }
    func fetchPopularMovies(result:(movies:[Movie]?,error:NSError?)->Void){
        
        var movies :[Movie]=[]
        
        request(.GET,"https://api.themoviedb.org/3/movie/popular?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&append_to_response=images").validate().responseJSON { (response) in
            switch response.result{
                
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    print(json)
                    for item in json["results"].arrayValue{
                        
                        let movieTitle = item["original_title"].stringValue
                        let movieId = item["id"].stringValue
                        let moviePosterPath = item["poster_path"].stringValue
                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
                        let overview = item["overview"].stringValue
                        let realiseDate = item["release_date"].stringValue
                        let genreIds = item["genre_ids"].arrayValue
                        let backdropPath = item["backdrop_path"].stringValue
                        var stringGenreIds = [String]()
                        for genreId in genreIds{
                            let stringGenreId = genreId.stringValue
                            stringGenreIds.append(stringGenreId)
                        }
                        let movie = Movie(movieTitle: movieTitle,
                            movieID: movieId,
                            youTubeKey: nil,
                            voteAverage: voteAverage,
                            overview: overview,
                            releaseDate: realiseDate,
                            genreIds: stringGenreIds,
                            moviePosterPath: "https://image.tmdb.org/t/p/w780\(moviePosterPath)",
                        backdropPath:"https://image.tmdb.org/t/p/w1280\(backdropPath)")
                        movies.append(movie)
                        
                    }
                    result(movies: movies, error: nil)
//                    print(movies)
                    
                    
                    
                }
            case .Failure(let error):
                print(error)
                
                
            }
        }
        
        
    }
    
    func fetchPopularTVShows(result:(tvShows:[Movie]?,error:NSError?)->Void){
        
        var tvShows:[Movie] = []
        
        request(.GET,"https://api.themoviedb.org/3/tv/popular?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&append_to_response=images").validate().responseJSON { (response) in
            switch response.result{
                
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    print(json)
                    for item in json["results"].arrayValue{
                        
                        let movieTitle = item["original_name"].stringValue
                        let movieId = item["id"].stringValue
                        let moviePosterPath = item["poster_path"].stringValue
                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
                        let overview = item["overview"].stringValue
                        let realiseDate = item["release_date"].stringValue
                        let genreIds = item["genre_ids"].arrayValue
                        let backdropPath = item["backdrop_path"].stringValue
                        var stringGenreIds = [String]()
                        for genreId in genreIds{
                            let stringGenreId = genreId.stringValue
                            stringGenreIds.append(stringGenreId)
                        }
                        let movie = Movie(movieTitle: movieTitle,
                            movieID: movieId,
                            youTubeKey: nil,
                            voteAverage: voteAverage,
                            overview: overview,
                            releaseDate: realiseDate,
                            genreIds: stringGenreIds,
                            moviePosterPath: "https://image.tmdb.org/t/p/w780\(moviePosterPath)",
                            backdropPath:"https://image.tmdb.org/t/p/w1280\(backdropPath)")
                        tvShows.append(movie)
                        
                    }
                    result(tvShows: tvShows, error: nil)
                    print(tvShows)
                    
                    
                    
                }
            case .Failure(let error):
                print(error)
                
                
            }
        }
    }
    func fetchTopRatedTVShows(result:(tvShows:[Movie]?,error:NSError?)->Void){
        
        var tvShows:[Movie] = []
        
        request(.GET,"https://api.themoviedb.org/3/tv/top_rated?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&append_to_response=images").validate().responseJSON { (response) in
            switch response.result{
                
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    print(json)
                    for item in json["results"].arrayValue{
                        
                        let movieTitle = item["original_name"].stringValue
                        let movieId = item["id"].stringValue
                        let moviePosterPath = item["poster_path"].stringValue
                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
                        let overview = item["overview"].stringValue
                        let realiseDate = item["release_date"].stringValue
                        let genreIds = item["genre_ids"].arrayValue
                        let backdropPath = item["backdrop_path"].stringValue
                        var stringGenreIds = [String]()
                        for genreId in genreIds{
                            let stringGenreId = genreId.stringValue
                            stringGenreIds.append(stringGenreId)
                        }
                        let movie = Movie(movieTitle: movieTitle,
                            movieID: movieId,
                            youTubeKey: nil,
                            voteAverage: voteAverage,
                            overview: overview,
                            releaseDate: realiseDate,
                            genreIds: stringGenreIds,
                            moviePosterPath: "https://image.tmdb.org/t/p/w780\(moviePosterPath)",
                            backdropPath:"https://image.tmdb.org/t/p/w1280\(backdropPath)")
                        tvShows.append(movie)
                        
                    }
                    result(tvShows: tvShows, error: nil)
//                    print(tvShows)
                    
                    
                    
                }
            case .Failure(let error):
                print(error)
                
                
            }
        }
    }
    func fetchShowingTodayTVShows(result:(tvShows:[Movie]?,error:NSError?)->Void){
        
        var tvShows:[Movie] = []
        
        request(.GET,"https://api.themoviedb.org/3/tv/airing_today?api_key=1a8cf68cea1be9ce3938eb5a6024d19a&append_to_response=images").validate().responseJSON { (response) in
            switch response.result{
                
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    print(json)
                    for item in json["results"].arrayValue{
                        
                        let movieTitle = item["original_name"].stringValue
                        let movieId = item["id"].stringValue
                        let moviePosterPath = item["poster_path"].stringValue
                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
                        let overview = item["overview"].stringValue
                        let realiseDate = item["release_date"].stringValue
                        let genreIds = item["genre_ids"].arrayValue
                        let backdropPath = item["backdrop_path"].stringValue
                        var stringGenreIds = [String]()
                        for genreId in genreIds{
                            let stringGenreId = genreId.stringValue
                            stringGenreIds.append(stringGenreId)
                        }
                        let movie = Movie(movieTitle: movieTitle,
                            movieID: movieId,
                            youTubeKey: nil,
                            voteAverage: voteAverage,
                            overview: overview,
                            releaseDate: realiseDate,
                            genreIds: stringGenreIds,
                            moviePosterPath: "https://image.tmdb.org/t/p/w780\(moviePosterPath)",
                            backdropPath:"https://image.tmdb.org/t/p/w1280\(backdropPath)")
                        tvShows.append(movie)
                        
                    }
                    result(tvShows: tvShows, error: nil)
//                    print(tvShows)
                    
                    
                    
                }
            case .Failure(let error):
                print(error)
                
                
            }
        }
    }
    
    

    
}

