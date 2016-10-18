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
    private var baseUrl = "https://api.themoviedb.org/3/movie/"
    
}
//Networking
extension MovieService{
    
    //     Otprilike bi ovako dohvato listu filmova,closure bi vratio ili filmove ili gresku
    func fetchNowShowingMoviesFromAPI(page page:Double,result:(movies:[Movie]?,error:NSError?)->Void){
        request(.GET, "\(baseUrl)now_playing?api_key=\(apiKey)&page=\(page)").validate().responseJSON { (response) in
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
    
    
    func fetchPopularMoviesFromAPI(page page:Double,result:(movies:[Movie]?,error:NSError?)->Void){
        request(.GET, "\(baseUrl)popular?api_key=\(apiKey)&page=\(page)").validate().responseJSON { (response) in
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
    func fetchComingSoonMoviesFromAPI(page page:Double,result:(movies:[Movie]?,error:NSError?)->Void){
        request(.GET, "\(baseUrl)upcoming?api_key=\(apiKey)&page=\(page)").validate().responseJSON { (response) in
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
    func fetchCreditsForMovie(movieId id:Int,result:(credits:Credits?,error:NSError?)->Void){
        
        request(.GET, "\(baseUrl)\(id)/credits?api_key=\(apiKey)").validate().responseJSON { (response) in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    let id = json["id"].intValue
                    let credits = Credits()
                    credits.id = id
                    for item in json["cast"].arrayValue{
                        let castId = item["cast_id"].intValue
                        let character = item["character"].stringValue
                        let creditId = item["credit_id"].stringValue
                        let id = item["id"].intValue
                        let name = item["name"].stringValue
                        let order = item["order"].intValue
                        let profilePath = item["profile_path"].stringValue
                        let cast = Cast()
                        cast.id = castId
                        cast.character = character
                        cast.creditId = creditId
                        cast.id = id
                        cast.name = name
                        cast.order = order
                        cast.profilePath = profilePath
                        credits.casts.append(cast)
                    }
                    for item in json["crew"].arrayValue{
                        let creditId = item["credit_id"].stringValue
                        let department = item["department"].stringValue
                        let id = item["id"].intValue
                        let job = item["job"].stringValue
                        let name = item["name"].stringValue
                        let profilePath = item["profile_path"].stringValue
                        let crewMember = CrewMember()
                        crewMember.creditId = creditId
                        crewMember.department = department
                        crewMember.id = id
                        crewMember.job = job
                        crewMember.name = name
                        crewMember.profilePath = profilePath
                        credits.crew.append(crewMember)
                    }
                    result(credits: credits, error: nil)
                }
            case .Failure(let error):
                result(credits: nil, error: error)
                print(error)
            }
        }
    }
    
    func fetchMovieAlbum(movieId id:Int,result:(album:MovieAlbum?,error:NSError?)->Void){
        request(.GET, "\(baseUrl)\(id)/images?api_key=\(apiKey)").validate().responseJSON { (response) in
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    
                    let id = json["id"].intValue
                    let movieAlbum = MovieAlbum()
                    movieAlbum.id = id
                    for item in json["backdrops"].arrayValue{
                        let aspectRatio = item["ascpect_ratio"].doubleValue
                        let filePath = item["file_path"].stringValue
                        let height = item["height"].intValue
                        //  let iso6391 = item["iso_639_0"].stringValue
                        let voteAverage = item["vote_average"].doubleValue
                        let voteCount = item["vote_count"].intValue
                        let width = item["width"].intValue
                        let backdrop = Backdrop()
                        backdrop.aspectRatio = aspectRatio
                        backdrop.filePath = filePath
                        backdrop.height = height
                        backdrop.voteAverage = voteAverage
                        backdrop.voteCount = voteCount
                        backdrop.width = width
                        movieAlbum.backdrops.append(backdrop)
                    }
                    result(album: movieAlbum, error: nil)
                }
            case .Failure(let error):
                result(album: nil, error: error)
            }
        }
    }
    
    func fetchMovieVideos(movieID id:Int,result:(videos:[Video]?,error:NSError?)->Void){
        
        request(.GET, "\(baseUrl)\(id)/videos?api_key=\(apiKey)").validate().responseJSON { (response) in
            switch response.result{
            case . Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    var videos = [Video]()
                    for item in json["results"].arrayValue{
                        let video = Video()
                        video.id = item["id"].stringValue
                        video.key = item["key"].stringValue
                        video.name = item["name"].stringValue
                        video.site = item["site"].stringValue
                        video.size = item["size"].intValue
                        video.type = item["type"].stringValue
                        videos.append(video)
                    }
                    result(videos: videos, error: nil)
                }
            case .Failure(let error):
                result(videos: nil, error: error)
                
            }
        }
        
    }
    
//    func searchMoviesByText(text:String,result:(movies:[Movie]?,error:NSError?)->Void){
//       
//        request(.Get,
//        
//    }
    
    private func parseMovieJson(json:JSON)->[Movie]{
        var movies:[Movie] = []
        
        let apiPage = json["page"].intValue
        for item in json["results"].arrayValue{
            let movieTitle = item["original_title"].stringValue
            let movieId = item["id"].intValue
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
            movie.apiPage = apiPage
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
        let movies = realm.objects(Movie.self).filter("movieList = '\(list)'")
        return movies
    }
    
}



