//
//  TVShowController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/22/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class TVShowController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posterTVShows:[Movie]?
    var showingTodayTVShows:[Movie]?
    var topRatedTVShows:[Movie]?
    var popularTVShows:[Movie]?{
        
        didSet{
            setupDataForPosterTVShows()
        }
    }
    
    var tvShowList = ["Poster","Showing Today","Top Rated","Popular"]
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0)
        
        
        
        fetchData()
        startTimer()
        

    }
    
    func setupDataForPosterTVShows(){
        
        var expandedTVShows = [Movie]()
        
        if let workingMovies = self.popularTVShows{
            var i = 0
            for movie in workingMovies{
                if i < 5{
                    expandedTVShows.append(movie)
                    i += 1
                }
            }
        }
        
        
        let firstItem = expandedTVShows.first
        let lastItem = expandedTVShows.last
        expandedTVShows.insert(lastItem!, atIndex: 0)
        expandedTVShows.append(firstItem!)
        self.posterTVShows = expandedTVShows
        
    }
    
    func fetchData(){
    
        TMDBMenager.sharedManager.fetchPopularTVShows { (tvShows, error) in
            
            if error != nil{
                return
            }else{
                self.popularTVShows = tvShows
                self.tableView.reloadData()
            }
            TMDBMenager.sharedManager.fetchTopRatedTVShows({ (tvShows, error) in
                
                if error != nil{
                    return
                }else {
                    self.topRatedTVShows = tvShows
                    self.tableView.reloadData()
                }
                TMDBMenager.sharedManager.fetchShowingTodayTVShows({ (tvShows, error) in
                    if error != nil{
                        return
                    }else{
                        self.showingTodayTVShows = tvShows
                        self.tableView.reloadData()
                    }
                })
            })
        }
    
    
    }
    

    

}

extension TVShowController:UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return tvShowList.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let posterCell = tableView.dequeueReusableCellWithIdentifier("TVPosterRow", forIndexPath: indexPath) as! TVPosterRow
            posterCell.collectionView.tag = indexPath.section+100
            posterCell.collectionView.reloadData()
            return posterCell
        }else{
            let movieCell = tableView.dequeueReusableCellWithIdentifier("TVVideoRow", forIndexPath: indexPath) as! TVVideoRow
            movieCell.collectionView.tag = indexPath.section+100
            movieCell.collectionView.reloadData()
            return movieCell
        }
        
        
    }
    
}

extension TVShowController:UITableViewDelegate{
    
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
        return tvShowList[section]
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
            movieListLabel.text = tvShowList[section]
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

extension TVShowController:UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
            
        case 100:
            if let movies = posterTVShows{
                return movies.count
            }else{
                return 0
            }
        case 101:
            if let movies = self.showingTodayTVShows{
                
                return movies.count
            }else{
                return 0
            }
        case 102:
            if let movies = self.topRatedTVShows{
                return movies.count
            }else{
                return 0
            }
        case 103:
            if let movies = self.popularTVShows{
                
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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TVPosterCell", forIndexPath: indexPath) as! TVPosterCell
            let URL = posterTVShows![indexPath.row].backdropUrl
            cell.posterView.af_setImageWithURL(URL!)
            cell.titleTextField.text = posterTVShows![indexPath.row].movieTitle
            return cell
            
        }else if collectionView.tag == 101{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TVVideoCell", forIndexPath: indexPath) as! TVVideoCell
            let URL = showingTodayTVShows![indexPath.row].moviePosterUrl
            cell.photoView.af_setImageWithURL(URL!)
            return cell
        }else if collectionView.tag == 102{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TVVideoCell", forIndexPath: indexPath) as! TVVideoCell
            let URL = topRatedTVShows![indexPath.row].moviePosterUrl
            cell.photoView.af_setImageWithURL(URL!)
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TVVideoCell", forIndexPath: indexPath) as! TVVideoCell
            let URL = popularTVShows![indexPath.row].moviePosterUrl
            print(URL)
            cell.photoView.af_setImageWithURL(URL!)
            return cell
        }
        
    }
    
    
    
}
extension TVShowController:UICollectionViewDelegateFlowLayout{
    
    
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

extension TVShowController{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let posterRow = self.view.viewWithTag(100) as? UICollectionView
        
        if posterRow != nil{
            
            if scrollView != posterRow {return}
            
            let contentOffSetWhenFullyScrolledRight = posterRow!.frame.size.width * CGFloat(self.posterTVShows!.count - 1)
            
            // when scrollView is fully scrolled to right
            if scrollView.contentOffset.x == contentOffSetWhenFullyScrolledRight{
                let newIndexPath = NSIndexPath(forItem: 1, inSection: 0)
                // scroll back to item 1
                posterRow!.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                // when scroolView is fully scroled to left
            }else if scrollView.contentOffset.x == 0{
                let newIndexPath = NSIndexPath(forItem: self.posterTVShows!.count - 2, inSection: 0)
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
extension TVShowController{
    
    func performSegue(sender:UIButton){
        
        self.performSegueWithIdentifier("seeAllSegue", sender: sender)
    }
    
    
    
}

