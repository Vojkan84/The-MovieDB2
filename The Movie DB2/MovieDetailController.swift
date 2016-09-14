//
//  MovieDetailController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/10/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift

class MovieDetailController:UIViewController{
    
    var movieId:Int?
    var movie:Results<Movie>?{
        didSet{
            
            let URL = movie?.first?.moviePosterUrl
            self.photoView.af_setImageWithURL(URL!)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieService.sharedInstace.fetchCreditsForMovie(movieId: movieId!) {[weak self] (credits, error) in
            if let err = error{
                print(err)
            }
            else{
                
                let realm = try! Realm()
                let movie = realm.objects(Movie.self).filter("movieID = \(self!.movieId!) ")
                MovieService.sharedInstace.fetchMovieAlbum(movieId:self!.movieId!){(album, error) in
                    if let err = error{
                        print(err)
                    }else{
                        MovieService.sharedInstace.fetchMovieVideos(movieID: self!.movieId!) {(videos, error) in
                            if let err = error{
                                print(err)
                            }else{
                                let movieToken = realm.addNotificationBlock({[weak self] (notification, realm) in
                                    self?.movie = realm.objects(Movie.self).filter("movieID = \(self!.movieId!) ")
                                    })
                                try! realm.write{
                                    realm.create(Movie.self, value:["movieId":self!.movieId!,"credits":credits!,"album":album!,"videos":videos!],update:true)
                                }
                                movieToken.stop()
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

extension MovieDetailController:UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 6
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
