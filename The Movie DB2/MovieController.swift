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
    var popularMovies:[Movie]?
    
    
    var movieLists = ["Poster","Now Showing","Coming Soon","Popular"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0)
        
       
        
        fetchData()
        
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
            posterCell.collectionView.tag = indexPath.section
            return posterCell
        }else if indexPath.section == 1{
            
            let movieCell = tableView.dequeueReusableCellWithIdentifier("NowShowingRow", forIndexPath: indexPath) as! NowShowingRow
            movieCell.collectionView.tag = indexPath.section
            movieCell.collectionView.reloadData()
            return movieCell
        }else if indexPath.section == 2{
        
            let movieCell = tableView.dequeueReusableCellWithIdentifier("ComingSoonRow", forIndexPath: indexPath) as! ComingSoonRow
            movieCell.collectionView.tag = indexPath.section
            movieCell.collectionView.reloadData()
            return movieCell
        }else {
            let movieCell = tableView.dequeueReusableCellWithIdentifier("PopularRow", forIndexPath: indexPath) as! PopularRow
            movieCell.collectionView.tag = indexPath.section
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
            
        case 0:
            return 5
        case 1:
            if let movies = self.nowShowingMovies{
                return movies.count
            }else{
                return 0
            }
        case 2:
            if let movies = self.comingSoonMovies{
                return movies.count
            }else{
                return 0
            }
        case 3:
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
        if collectionView.tag == 1{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NowShowingCell", forIndexPath: indexPath) as! NowShowingCell
            let URL = nowShowingMovies![indexPath.row].moviePosterUrl
            cell.photoView.af_setImageWithURL(URL!)
            return cell
        }else if collectionView.tag == 2{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ComingSoonCell", forIndexPath: indexPath) as! ComingSoonCell
            let URL = comingSoonMovies![indexPath.row].moviePosterUrl
            cell.photoView.af_setImageWithURL(URL!)
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PopularCell", forIndexPath: indexPath) as! PopularCell
            let URL = popularMovies![indexPath.row].moviePosterUrl
            cell.photoView.af_setImageWithURL(URL!)
            return cell
        }
    }

}
extension MovieController:UICollectionViewDelegateFlowLayout{

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
   
        let itemsPerRow : CGFloat = 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (collectionView.bounds.size.width - 4*layout.minimumInteritemSpacing)/itemsPerRow
        let itemHeight = collectionView.bounds.size.height
        return CGSize(width: itemWidth, height: itemHeight)
      
        
    }
        
}



