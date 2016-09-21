//
//  ComingSoonMoviesController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/8/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import RealmSwift

class ComingSoonMoviesController:UIViewController{
    
    
    var comingSoonMovies:Results<Movie>?
    var refreshControl = UIRefreshControl()
    var currentPage : Double = 1
    var notificationToken:NotificationToken? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Coming Soon"
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        refreshControl.triggerVerticalOffset = 50
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        self.collectionView.bottomRefreshControl = refreshControl
        
        let realm = try! Realm()
        self.comingSoonMovies = MovieService.sharedInstace.loadMovies(fromList: "coming_soon")
        notificationToken = realm.addNotificationBlock({[weak self] (notification, realm) in
            self!.collectionView.reloadData()
            })
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        notificationToken?.stop()
    }
    func loadNextPage(){
        self.currentPage += 1
        MovieService.sharedInstace.fetchComingSoonMoviesFromAPI(page: currentPage) { (movies, error) in
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

extension ComingSoonMoviesController:UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = self.comingSoonMovies{
            return movies.count
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ComingSoonCell", forIndexPath: indexPath) as! ComingSoonCell
        let movie = comingSoonMovies![indexPath.row]
        if let URL = movie.moviePosterUrl{
            cell.titleLabel?.hidden = true
            cell.photoView?.af_setImageWithURL(URL,
                                               placeholderImage: UIImage(named:"default"),
                                               filter: nil,
                                               imageTransition: .CrossDissolve(0.2)
            )
        }else{
            cell.titleLabel.hidden = false
            cell.titleLabel.text! = movie.movieTitle
            cell.photoView.image = UIImage(named: "default")
        }
        return cell
        
    }

}

extension ComingSoonMoviesController:UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsPerRow : CGFloat = 3
        let itemsPerColumn:CGFloat = 3
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (collectionView.bounds.size.width - 2*layout.minimumInteritemSpacing)/itemsPerRow
        let itemHeight = (collectionView.bounds.size.height - 4*layout.minimumLineSpacing)/itemsPerColumn
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
}
extension ComingSoonMoviesController{
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovieDetail"{
            let movieDetailController = segue.destinationViewController as! MovieDetailController
            let cell = sender as! UICollectionViewCell
            let position = cell.convertPoint(CGPointZero, toView: collectionView)
            if let indexPath = collectionView.indexPathForItemAtPoint(position){
                movieDetailController.movieId = self.comingSoonMovies![indexPath.item].movieID
            }
        }
    }
}