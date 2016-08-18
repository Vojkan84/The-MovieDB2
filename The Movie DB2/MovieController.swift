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
    
    
    var movieLists = ["Poster","Now Showing","Top Rated","Popular"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
                TMDBMenager.sharedManager.fetchNowShowingMovies { (movies, error) in
        
                    if let err = error {
                        print(err)
                    }else{
                        self.nowShowingMovies = movies
                        self.tableView.reloadData()
        
                    }
                    
                }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("MEMORY WARNING")
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
            let posterCell = tableView.dequeueReusableCellWithIdentifier("POSTERCELL", forIndexPath: indexPath)
            return posterCell
        }else if indexPath.section == 1{
            let movieCell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as! NowShowingRow
            movieCell.collectionView.reloadData()
            return movieCell
        }else{
        
            let movieCell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as!
            NowShowingRow
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

        if let movies = self.nowShowingMovies{
            return movies.count
        }else{
            return 0
        }


    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VIDEOCELL", forIndexPath: indexPath) as! MovieListRowCell
        let URL = nowShowingMovies![indexPath.row].moviePosterUrl
        cell.photoView.af_setImageWithURL(URL!)
        return cell
    }

}
extension MovieController:UICollectionViewDelegateFlowLayout{

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let itemsPerRow : CGFloat = 3
        let hardcodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.size.width/itemsPerRow)-hardcodedPadding
        let itemHeight = collectionView.bounds.size.height

        return CGSize(width: itemWidth, height: itemHeight)
    }
}


