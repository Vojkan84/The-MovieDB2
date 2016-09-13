//
//  PopularMoviesController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/8/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import RealmSwift

class PopularMoviesController:UIViewController{
    
    
    
    var popularMovies:Results<Movie>?
    var refreshControl = UIRefreshControl()
    var currentPage : Double = 1
    var notificationToken:NotificationToken? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular"
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        refreshControl.triggerVerticalOffset = 50
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        self.collectionView.bottomRefreshControl = refreshControl
        
        let realm = try! Realm()
        notificationToken = realm.addNotificationBlock({[weak self] (notification, realm) in
            self!.popularMovies = MovieService.sharedInstace.loadMovies(fromList: "popular")
            self!.collectionView.reloadData()
            })
        
    }
    func loadNextPage(){
        self.currentPage += 1
        MovieService.sharedInstace.fetchPopularMoviesFromAPI(page: currentPage) { (movies, error) in
            if let err = error{
                print(err)
            }else{
                for movie in movies!{
                    MovieService.sharedInstace.saveMovie(movie)
                }
            }
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        loadNextPage()
        refreshControl.endRefreshing()
    }
    
    
}

extension PopularMoviesController:UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = self.popularMovies{
            return movies.count
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let movie = popularMovies![indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PopularCell", forIndexPath: indexPath) as! PopularCell
        let URL = movie.moviePosterUrl
        cell.titleLabel?.text? = movie.movieTitle
        cell.photoView?.af_setImageWithURL(
            URL!,
            placeholderImage: UIImage(named:"default"),
            filter: nil,
            imageTransition: .CrossDissolve(0.2))
        return cell
    }
}

extension PopularMoviesController:UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsPerRow : CGFloat = 3
        let itemsPerColumn:CGFloat = 3
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (collectionView.bounds.size.width - 2*layout.minimumInteritemSpacing)/itemsPerRow
        let itemHeight = (collectionView.bounds.size.height - 4*layout.minimumLineSpacing)/itemsPerColumn
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
}
extension PopularMoviesController{
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovieDetail"{
            let movieDetailController = segue.destinationViewController as! MovieDetailController
            let cell = sender as! UICollectionViewCell
            let position = cell.convertPoint(CGPointZero, toView: collectionView)
            if let indexPath = collectionView.indexPathForItemAtPoint(position){
                movieDetailController.movieId = self.popularMovies![indexPath.item].movieID
            }
        }
    }
}