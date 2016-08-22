//
//  MovieController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/16/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class MovieController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var nowShowingMovies:[Movie]?
    var comingSoonMovies:[Movie]?
    var popularMovies:[Movie]?{
        didSet{
            setupDataForPosterRow(self.images)
        }
    }
    var images = [UIImage(named:"jason bourne"),UIImage(named:"equalizer"),UIImage(named:"batman")]
    var timer = NSTimer()
    var indexPathsForPosterROw = NSIndexPath(forItem: 0, inSection: 0)
    var posterRowMovies:[Movie]?
    
    var movieLists = ["Poster","Now Showing","Coming Soon","Popular"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0)
        
       
        
        fetchData()
        startTimer()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("MEMORY WARNING")
    }
    
    func fetchData(){
    
        TMDBMenager.sharedManager.fetchNowShowingMovies { (movies, error) in
            
            if let err = error {
                print(err)
            }else{
                self.nowShowingMovies = movies
                self.tableView.reloadData()
                
            }
            TMDBMenager.sharedManager.fetchComingSoonMovies({ (movies, error) in
                
                if let err = error{
                    print(err)
                }else{
                    self.comingSoonMovies = movies
                    self.tableView.reloadData()
                }
                TMDBMenager.sharedManager.fetchPopularMovies({ (movies, error) in
                    
                    if let err = error{
                        print(err)
                    }else{
                        self.popularMovies = movies
                        self.tableView.reloadData()
                    }
                })
            })
        }

    }
    func setupDataForPosterRow(images:[UIImage?]){
        
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
            cell.titleTextField.text = posterRowMovies![indexPath.row].movieTitle
            return cell
            
        }else if collectionView.tag == 101{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NowShowingCell", forIndexPath: indexPath) as! NowShowingCell
            let URL = nowShowingMovies![indexPath.row].moviePosterUrl
            cell.photoView.af_setImageWithURL(URL!)
            return cell
        }else if collectionView.tag == 102{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NowShowingCell", forIndexPath: indexPath) as! NowShowingCell
            let URL = comingSoonMovies![indexPath.row].moviePosterUrl
            cell.photoView.af_setImageWithURL(URL!)
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NowShowingCell", forIndexPath: indexPath) as! NowShowingCell
            let URL = popularMovies![indexPath.row].moviePosterUrl
            print(URL)
            cell.photoView.af_setImageWithURL(URL!)
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
    
        self.performSegueWithIdentifier("seeAllSegue", sender: sender)
    }

     

}



