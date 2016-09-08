//
//  MovieService.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/6/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class MovieService{
    
    // singlton
    static let sharedInstace = MovieService()
    
    // api key koji mi treba za svaki API poziv
    private var apiKey = "1a8cf68cea1be9ce3938eb5a6024d19a"
    
}
//Networking
extension MovieService{
    
    //     Otprilike bi ovako dohvato listu filmova,closure bi vratio ili filmove ili gresku
    func fetchNowShowingMoviesFromAPI(result:(movies:[Movie]?,error:NSError?)->Void){
        request(.GET, "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)").validate().responseJSON { (response) in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    let movies = self.parseMovieJson(json)
                    for movie in movies{
                        movie.movieList = "now_playing"
                    }
                    result(movies: movies, error: nil)
                }
            case .Failure(let error):
                result(movies: nil, error: error)
                print (error)
            }
        }
    }
    
    
    func fetchPopularMoviesFromAPI(result:(movies:[Movie]?,error:NSError?)->Void){
        request(.GET, "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)").validate().responseJSON { (response) in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    let movies = self.parseMovieJson(json)
                    for movie in movies{
                        movie.movieList = "popular"
                    }
                    result(movies: movies, error: nil)
                }
            case .Failure(let error):
                result(movies: nil, error: error)
                print (error)
            }
        }
    }
    func fetchComingSoonMoviesFromAPI(result:(movies:[Movie]?,error:NSError?)->Void){
        request(.GET, "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)").validate().responseJSON { (response) in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    let movies = self.parseMovieJson(json)
                    for movie in movies{
                        movie.movieList = "coming_soon"
                    }
                    result(movies: movies, error: nil)
                }
            case .Failure(let error):
                result(movies: nil, error: error)
                print (error)
            }
        }
    }
    func fetchListOfMovieGenres(result:(genres:[Genre]?,error:NSError?)->Void){
        var genres:[Genre] = []
        request(.GET, "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)").validate().responseJSON { (response) in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    for item in json["genres"].arrayValue{
                        let id = item["id"].stringValue
                        let name = item["name"].stringValue
                        
                        let genre = Genre()
                        genre.id = id
                        genre.name = name
                        genres.append(genre)
                    }
                    print(genres)
                    result(genres: genres, error: nil)
                }
            case .Failure(let error):
                result(genres: nil, error: error)
                print (error)
            }
        }
    }
    
    private func parseMovieJson(json:JSON)->[Movie]{
        var movies:[Movie] = []
        for item in json["results"].arrayValue{
            let movieTitle = item["original_title"].stringValue
            let movieId = item["id"].stringValue
            let moviePosterPath = item["poster_path"].stringValue
            let voteAverage = round(1000*item["vote_average"].doubleValue)/1000
            let overview = item["overview"].stringValue
            let realiseDate = item["release_date"].stringValue
            let genreIds = item["genre_ids"].arrayValue
            let backdropPath = item["backdrop_path"].stringValue
            var stringGenreIds = [String]() // TO DO napravi Model Genre
            for genreId in genreIds{
                let stringGenreId = genreId.stringValue
                stringGenreIds.append(stringGenreId)
            }
            let movie = Movie()
            movie.movieTitle = movieTitle
            movie.movieID = movieId
            movie.youTubeKey = nil
            movie.voteAverage = voteAverage
            movie.overview = overview
            movie.moviePosterPath = moviePosterPath
            movie.backdropPath = backdropPath
            movie.releaseDate = realiseDate
            movies.append(movie)
            
        }
        return movies
    }
    // ovde snimam pojedinacni film u bazu
    func saveMovie(movie:Movie){
        let realm = try! Realm()
        try! realm.write{
            realm.add(movie,update: true)
        }
    }
    // ovde ucitavam listu filmova iz baze, nisam siguran da je nacin filtriranja dobar(filtriram pod pretpostavkom da sam film entitetu dodelio atribut movieList.Nisam do sada koristio notifikacije a pretpostavlja da bi model sa controller-om trebao da komunicira preko notifikacija tako da ova funkcija vraca Results<Movie> ne znam kako bi njih pretvorio u niz filmova koji mi treba da bi ga iskoristio kao data source.
    func loadMovies(fromList list:String)->Results<Movie>{
        let realm = try! Realm()
        let movies = realm.objects(Movie.self).filter("movieList == '\(list)'")
        return movies
    }
}



