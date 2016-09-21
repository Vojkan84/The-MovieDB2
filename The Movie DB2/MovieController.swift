//
//  MovieController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/16/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//


// TO DO - ucrtaj labelu ispod imageView-a u nultom redu tabele

import UIKit
import RealmSwift

class MovieController: UIViewController{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var nowShowingMovies:Results<Movie>?
    var comingSoonMovies:Results<Movie>?
    var popularMovies:Results<Movie>?{
        didSet{
            setupDataForPosterRow()
        }
    }
    
    var posterRowMovies:[Movie]?
    var timer = NSTimer()
    var indexPathsForPosterROw = NSIndexPath(forItem: 0, inSection: 0)
    
    
    var movieLists = ["Poster","Now Showing","Coming Soon","Popular"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0)
        
        fetchData()
        startTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("MEMORY WARNING")
    }
    
    func fetchData(){
        MovieService.sharedInstace.fetchNowShowingMoviesFromAPI(page: 1) { [weak self](movies, error) in
            
            if let err = error{
                print(err)
            }else{
                let realm = try! Realm()
                
                let nowShowingMoviesToken = realm.addNotificationBlock({ [weak self](notification, realm) in
                    self?.nowShowingMovies = realm.objects(Movie.self).filter("movieList = 'now_playing' AND apiPage = 1")
                    self!.tableView.reloadData()
                    
                    })
                for movie in movies!{
                    MovieService.sharedInstace.saveMovie(movie)
                }
                nowShowingMoviesToken.stop()
                
            }
            MovieService.sharedInstace.fetchPopularMoviesFromAPI(page:1){ (movies, error) in
                if let err = error{
                    print(err)
                }else{
                    let realm = try! Realm()
                    
                    let popularMoviesToken = realm.addNotificationBlock({[weak self](notification, realm) in
                        self!.popularMovies = realm.objects(Movie.self).filter("movieList = 'popular' AND apiPage = 1")
                        self!.tableView.reloadData()
                        })
                    for movie in movies!{
                        MovieService.sharedInstace.saveMovie(movie)
                    }
                    popularMoviesToken.stop()
                }
                MovieService.sharedInstace.fetchComingSoonMoviesFromAPI(page:1){ (movies, error) in
                    if let err = error{
                        print(err)
                    }else{
                        let realm = try! Realm()
                        let commingSoonMoviesToken = realm.addNotificationBlock({[weak self] (notification, realm) in
                            self!.comingSoonMovies = realm.objects(Movie.self).filter("movieList = 'coming_soon' AND apiPage = 1")
                            self!.tableView.reloadData()
                            })
                        for movie in movies!{
                            MovieService.sharedInstace.saveMovie(movie)
                        }
                        commingSoonMoviesToken.stop()
                    }
                }
            }
        }
    }
    func setupDataForPosterRow(){
        
        var expandedMovies = [Movie]()
        
        if let workingMovies = self.popularMovies{
            var i = 0
            for movie in workingMovies{
                if i < 5{
                    expandedMovies.append(movie)
                    i += 1
                }
            }
        }
        
        
        let firstItem = expandedMovies.first
        let lastItem = expandedMovies.last
        expandedMovies.insert(lastItem!, atIndex: 0)
        expandedMovies.append(firstItem!)
        self.posterRowMovies = expandedMovies
        
    }
    
    
    
}



extension MovieController:UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return movieLists.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let posterCell = tableView.dequeueReusableCellWithIdentifier("PosterRow", forIndexPath: indexPath) as! PosterRow
            posterCell.collectionView.tag = indexPath.section+100
            posterCell.collectionView.reloadData()
            return posterCell
        }else{
            let movieCell = tableView.dequeueReusableCellWithIdentifier("NowShowingRow", forIndexPath: indexPath) as! NowShowingRow
            movieCell.collectionView.tag = indexPath.section+100
            movieCell.collectionView.reloadData()
            return movieCell
        }
        
        
    }
    
}

extension MovieController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 220
        }
        return tableView.rowHeight
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        return movieLists[section]
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return CGFloat.min
        }
        return 40
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            return nil
        }else{
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width,height: 40))
            view.backgroundColor = UIColor.blackColor()
            
            let movieListLabel = UILabel()
            movieListLabel.translatesAutoresizingMaskIntoConstraints = false
            movieListLabel.text = movieLists[section]
            movieListLabel.backgroundColor = UIColor.blackColor()
            movieListLabel.font = UIFont.systemFontOfSize(18)
            movieListLabel.textColor = UIColor.lightGrayColor()
            
            let seeAllButton = UIButton()
            seeAllButton.translatesAutoresizingMaskIntoConstraints = false
            seeAllButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            seeAllButton.setTitle("See All", forState: .Normal)
            seeAllButton.titleLabel?.font = UIFont.systemFontOfSize(14)
            seeAllButton.backgroundColor = UIColor.clearColor()
            seeAllButton.addTarget(self, action: #selector(performSegue(_:)), forControlEvents: .TouchUpInside)
            
            
            view.addSubview(movieListLabel)
            view.addSubview(seeAllButton)
            
            let mLLBottomConstraint =  NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: movieListLabel, attribute: .Bottom, multiplier: 1, constant: 4)
            let mLLLeadingConstraint = NSLayoutConstraint(item: movieListLabel, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 4)
            let seeAllButtonBottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: seeAllButton, attribute: .Bottom, multiplier: 1, constant: -1)
            let seeAllButtonTrailingConstraint = NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: seeAllButton, attribute: .Trailing, multiplier: 1, constant: 8)
            
            view.addConstraint(mLLBottomConstraint)
            view.addConstraint(mLLLeadingConstraint)
            view.addConstraint(seeAllButtonBottomConstraint)
            view.addConstraint(seeAllButtonTrailingConstraint)
            return view
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

extension MovieController:UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
            
        case 100:
            if let movies = posterRowMovies{
                return movies.count
            }else{
                return 0
            }
        case 101:
            if let movies = self.nowShowingMovies{
                return movies.count
            }else{
                return 0
            }
        case 102:
            if let movies = self.comingSoonMovies{
                return movies.count
            }else{
                return 0
            }
        case 103:
            if let movies = self.popularMovies{
                return movies.count
            }else{
                return 0
            }
        default:
            return 0
        }
        
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 100{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTOCELL", forIndexPath: indexPath) as! PosterRowPhotoCell
            let URL = posterRowMovies![indexPath.row].backdropUrl
            cell.photoView.af_setImageWithURL(URL!)
            cell.titleTextField.text! = posterRowMovies![indexPath.row].movieTitle
            return cell
            
        }else if collectionView.tag == 101{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NowShowingRowCell", forIndexPath: indexPath) as! NowShowingRowCell
            let movie = nowShowingMovies![indexPath.row]
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
            
        }else if collectionView.tag == 102{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NowShowingRowCell", forIndexPath: indexPath) as! NowShowingRowCell
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
            
    
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NowShowingRowCell", forIndexPath: indexPath) as! NowShowingRowCell
            let movie = popularMovies![indexPath.row]
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
}
extension MovieController:UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionView.tag == 100{
            let itemWidth = collectionView.bounds.size.width
            let itemHeight = collectionView.bounds.size.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        let itemsPerRow : CGFloat = 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (collectionView.bounds.size.width - 4*layout.minimumInteritemSpacing)/itemsPerRow
        let itemHeight = collectionView.bounds.size.height
        return CGSize(width: itemWidth, height: itemHeight)
        
        
    }
    
}
// Scrolling system for posterRow

extension MovieController{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let posterRow = self.view.viewWithTag(100) as? UICollectionView
        if posterRow != nil{
            if scrollView != posterRow {return}
            let contentOffSetWhenFullyScrolledRight = posterRow!.frame.size.width * CGFloat(self.posterRowMovies!.count - 1)
            // when scrollView is fully scrolled to right
            if scrollView.contentOffset.x == contentOffSetWhenFullyScrolledRight{
                let newIndexPath = NSIndexPath(forItem: 1, inSection: 0)
                // scroll back to item 1
                posterRow!.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                // when scroolView is fully scroled to left
            }else if scrollView.contentOffset.x == 0{
                let newIndexPath = NSIndexPath(forItem: self.posterRowMovies!.count - 2, inSection: 0)
                // scroll back to one item before last
                posterRow!.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
            }
            // restart timer
            restartTimer()
            
        }
        
        
    }
    /// Scrolls to next cell
    func scrollToNextCell(){
        
        if let posterRow = self.view.viewWithTag(100) as? UICollectionView{
            let cellSize = CGSizeMake(posterRow.bounds.size.width, posterRow.bounds.size.height)
            let contentOffSet = posterRow.contentOffset
            posterRow.scrollRectToVisible(CGRectMake(contentOffSet.x+cellSize.width, contentOffSet.y,      cellSize.width, cellSize.height), animated: true)
        }
    }
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    func restartTimer(){
        timer.invalidate()
        startTimer()
    }
}

//segues
extension MovieController{
    
    func performSegue(sender:UIButton){
        let position:CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(position){
            let section = indexPath.section
            switch section{
            case 1:
                self.performSegueWithIdentifier("showNowShowingMovies", sender: sender)
            case 2:
                self.performSegueWithIdentifier("showComingSoonMovies", sender: sender)
            case 3:
                self.performSegueWithIdentifier("showPopularMovies", sender: sender)
            default:break
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "movieToMovieDetail"{
            let collectionViewCell = sender as! UICollectionViewCell
            let collectionView = collectionViewCell.superview as! UICollectionView
            let position:CGPoint = collectionViewCell.convertPoint(CGPointZero, toView: collectionView)
            if let indexPath = collectionView.indexPathForItemAtPoint(position){
                switch collectionView.tag {
                case 100:
                    
                    let movieDetailController = segue.destinationViewController as! MovieDetailController
                    movieDetailController.movieId = popularMovies![indexPath.item].movieID
                case 101:
                    let movieDetailController = segue.destinationViewController as! MovieDetailController
                    movieDetailController.movieId = nowShowingMovies![indexPath.item].movieID
                case 102:
                    let movieDetailController = segue.destinationViewController as! MovieDetailController
                    movieDetailController.movieId = comingSoonMovies![indexPath.item].movieID
                case 103:
                    let movieDetailController = segue.destinationViewController as! MovieDetailController
                    movieDetailController.movieId = popularMovies![indexPath.item].movieID
                default:break
                }
            }
        }
        
    }
}



