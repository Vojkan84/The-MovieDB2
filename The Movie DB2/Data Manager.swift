//
//  Data Manager.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/5/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

//import Foundation
//import RealmSwift
//import SwiftyJSON
//
//class DataManager{
//    
//    static let sharedManager = DataManager()
//    
//    
//    
//    func fetchNowShowingMovies(result:(movies:[Movie]?,error:ErrorType?)->Void){
//        
//        
//        
//        var movies:[Movie] = []
//        
//        let movieListName = "now_playing"
//        
//        TMDB.shaedInstance.fetchNowShowingMovies { (jsonResult, error) in
//            
//            if let error = error{
//                result(movies: nil, error: error)
//                print(error)
//                return
//            }
//            guard let json = jsonResult else{
//                result(movies: nil, error: nil)
//                return
//            }
//            do{
//                let realm = try! Realm()
//                
//                try! realm.write{
//                    for item in json["results"].arrayValue{
//                        let movieTitle = item["original_title"].stringValue
//                        let movieId = item["id"].stringValue
//                        let moviePosterPath = item["poster_path"].stringValue
//                        let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
//                        let overview = item["overview"].stringValue
//                        let realiseDate = item["release_date"].stringValue
//                        let genreIds = item["genre_ids"].stringValue
//                        //                        var stringGenreIds = [String]()
//                        //                for genreId in genreIds{
//                        //                    let stringGenreId = genreId.stringValue
//                        //                    stringGenreIds.append(stringGenreId)
//                        //                }
//                        let movie = Movie()
//                        movie.movieID = movieId
//                        movie.movieTitle = movieTitle
//                        movie.moviePosterPath = moviePosterPath
//                        movie.voteAverage = voteAverage
//                        movie.movieList = movieListName
//                        movie.overview = overview
//                        movie.releaseDate = realiseDate
//                        movie.genreIds = genreIds // TO DO .....ispravi genreID property jer Realm ne prima nizove kao property
//                        movie.moviePosterPath = "https://image.tmdb.org/t/p/w342\(moviePosterPath)" // TO DO
//                        
//                        movies.append(movie)
//                        realm.add(movie)
//                        
//                    }
//                }
//                result(movies: movies, error: nil)
//            }catch let error as NSError{
//                print(error)
//            }
//            
//        }
//    }
//}
