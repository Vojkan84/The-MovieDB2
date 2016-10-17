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
import XCDYouTubeKit
import MBProgressHUD
import VGParallaxHeader


protocol MovieDetailControllerDelegate{
    
    func movieDetailControllerDidScrollToTop(paralaxHeaderProgress:CGFloat)
    func movieDetailControllerDidScrollToBottom(paralaxHeaderProgress:CGFloat)
    func movieDetailControllerContentOffSetYIsNegative()
}




class MovieDetailController:UIViewController{
    
    
    var sectionNames = ["MovieDetail","Photos","Trailer","Director","Cast"]
    var movieId:Int?
    var viewIsOnScrean:Bool = false
    var loader:MBProgressHUD?
    var movie:Results<Movie>?{
        didSet{
            let URL = movie?.first?.moviePosterUrl
            self.photoView.af_setImageWithURL(URL!)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var firstRowHeaderView:FirstRowHeaderView?
    var headerView = FirstRowHeaderView?()
    var movieDetailControllerDelegate:MovieDetailControllerDelegate?
    var lastContentOffSet = CGPointZero
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loader = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loader!.backgroundView.color = UIColor.clearColor()
        
        
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        let headerView = UINib(nibName: "HeaderView", bundle: nil)
        tableView.registerNib(headerView, forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        
        firstRowHeaderView  = NSBundle.mainBundle().loadNibNamed("FirstRowHeaderView", owner: self, options: nil)[0] as? FirstRowHeaderView
        self.movieDetailControllerDelegate = firstRowHeaderView
        
        MovieService.sharedInstace.fetchCreditsForMovie(movieId: movieId!) {
            (credits, error) in
            if let err = error{
                print(err)
            }
            else{
                
                MovieService.sharedInstace.fetchMovieAlbum(movieId:self.movieId!){[weak self](album, error) in
                    
                    if let err = error{
                        print(err)
                    }else{
                        MovieService.sharedInstace.fetchMovieVideos(movieID: self!.movieId!) {(videos, error)
                            in
                            if let err = error{
                                print(err)
                            }else{
                                
                                let realm = try! Realm()
                                let movieToken = realm.addNotificationBlock({ (notification, realm) in
                                    
                                    self!.movie = realm.objects(Movie.self).filter("movieID = \(self!.movieId!) ")
                                    self!.tableView.reloadData()
                                    self!.loader!.hideAnimated(true)
                                })
                                
                                try! realm.write{
                                    
                                    realm.create(Movie.self, value:["movieID":self!.movieId!, "credits":credits!, "album":album!, "videos":videos!],update:true)
                                }
                                movieToken.stop()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        viewIsOnScrean = true
        self.tableView.backgroundView?.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.reloadData()
        
        if tableView.contentOffset.y != 0{
            self.visualEffectView.hidden = false
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        viewIsOnScrean = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.backgroundColor = UIColor.blackColor()
        self.visualEffectView.hidden = true
        
    }
}



extension MovieDetailController:UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if movie != nil && viewIsOnScrean{
            return sectionNames.count
        }
        
        return 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if movie != nil && viewIsOnScrean{
            return 1
        }
        
        return 0
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieLegendRow", forIndexPath: indexPath) as! MovieLegendRow
            
            let movie = self.movie?.first
            cell.titleTextField.text = movie!.movieTitle
            cell.overviewTextView.textColor = UIColor.whiteColor()
            cell.overviewTextView.text = movie!.overview
            cell.voteAverageTextField.text = String(movie!.voteAverage)
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetailPhotoRow",forIndexPath:indexPath) as! MovieDetailPhotoRow
            cell.collectionView.tag = indexPath.section+200
            cell.collectionView.reloadData()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetailVideoRow",forIndexPath:indexPath) as! MovieDetailVideRow
            cell.collectionView.tag = indexPath.section+200
            cell.collectionView.reloadData()
            return cell
        case 3:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetailDirectorRow", forIndexPath: indexPath) as! MovieDetailDirectorRow
            cell.collectionView.tag = indexPath.section+200
            cell.collectionView.reloadData()
            return cell
            
        default:
            break
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetailCastRow", forIndexPath: indexPath) as! MovieDetailCatsRow
        cell.collectionView.tag = indexPath.section + 200
        cell.collectionView.reloadData()
        return cell
        
        
        
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            
            
            tableView.setParallaxHeaderView(self.firstRowHeaderView, mode: .Fill, height: UIScreen.mainScreen().bounds.height - cell.bounds.height - (navigationController?.navigationBar.bounds.height)! - 44 - UIApplication.sharedApplication().statusBarFrame.height)
        }
    }
}
extension MovieDetailController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            return (tableView.bounds.height - 88)/3
        case 2:
            return (tableView.bounds.height - 88)/3
        case 3:
            return (tableView.bounds.height - 88)/4
        case 4:
            return (tableView.bounds.height - 88)/4
            
        default:
            return tableView.rowHeight
        }
        
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableViewAutomaticDimension
        }
        return tableView.rowHeight
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            return CGFloat.min
        }
        
        return tableView.sectionHeaderHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0{
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("HeaderView") as! HeaderView
            header.titleLabel.text! = self.sectionNames[section]
            return header
        }
        
        return nil
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        return sectionNames[section]
    }
}

extension MovieDetailController:UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 201:
            return (movie?.first?.album?.backdrops.count)!
        case 202:
            return (movie?.first?.videos.count)!
        case 203:
            return 1
        case 204:
            return (movie?.first?.credits?.casts.count)!
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if  collectionView.tag == 201{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieDetailPhotoCell", forIndexPath: indexPath) as! MovieDetailPhotoCell
            let url = movie?.first?.album?.backdrops[indexPath.item].url
            cell.photoView.af_setImageWithURL(url!,
                                              placeholderImage: UIImage(named: "default"),
                                              imageTransition: .CrossDissolve(0.2))
            return cell
        }
        if collectionView.tag == 202{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieDetailVideoCell", forIndexPath: indexPath) as! MovieDetailVideoCell
            let video = self.movie?.first?.videos[indexPath.item]
            
            let youTubeKey = video!.key
            cell.youTubeKey = youTubeKey
            cell.thumbnailImageView.af_setImageWithURL(video!.thumbnailUrl!)
            return cell
        }
        if collectionView.tag == 203{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieDetailDirectorCell", forIndexPath: indexPath) as!MovieDetailDirectorCell
            let crew = movie?.first?.credits?.crew
            for crewMember in crew!{
                
                if crewMember.job == "Director"{
                    
                    let url = crewMember.profileImagelUrl
                    cell.photoView?.af_setImageWithURL(url!,
                                                       placeholderImage: UIImage(named:"default"),
                                                       filter: nil,
                                                       imageTransition: .CrossDissolve(0.2)
                        
                    )
                    cell.nameLabel.text = crewMember.name
                    return cell
                }
                
            }
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieDetailCastCell", forIndexPath: indexPath) as! MovieDetailCastCell
        let actor = movie?.first?.credits?.casts[indexPath.item]
        let url = actor?.profileImagelUrl
        cell.photoView?.af_setImageWithURL(url!,
                                           placeholderImage: UIImage(named:"default"),
                                           filter: nil,
                                           imageTransition: .CrossDissolve(0.2)
            
        )
        cell.nameLabel.text = actor!.name
        return cell
        
        
    }
    
    
}
extension MovieDetailController:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionView.tag == 201{
            let itemWidth = collectionView.bounds.size.width/4*3
            let itemHeight = collectionView.bounds.size.height
            collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            return CGSize(width: itemWidth, height: itemHeight)
        }
        if collectionView.tag == 202{
            
            let itemWidth = collectionView.bounds.size.width/4*3
            let itemHeight = collectionView.bounds.size.height
            collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            return CGSize(width: itemWidth, height: itemHeight)
        }
        if collectionView.tag == 203{
            let itemWidth = collectionView.bounds.width/4
            let itemHeight = collectionView.bounds.size.height
            collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        let itemWidth = collectionView.bounds.width/4
        let itemHeight = collectionView.bounds.size.height
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
}
extension MovieDetailController{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.tableView.shouldPositionParallaxHeader()
        
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        if let movieLegendRow = tableView.cellForRowAtIndexPath(indexPath) as? MovieLegendRow{
            
            let cellBackroundColorAlpha = 0.8 - (1 - self.tableView.parallaxHeader.progress)
            let headerViewBackgroundColorAlpha = 0.8 - (1 - self.tableView.parallaxHeader.progress)
            
            if tableView.contentOffset.y > 0{
        
                let currentOffSet = scrollView.contentOffset
                // if scrolling to top
                if currentOffSet.y > lastContentOffSet.y{
                    movieDetailControllerDelegate?.movieDetailControllerDidScrollToTop(self.tableView.parallaxHeader.progress)
                    
                    movieLegendRow.visualEffectView.hidden = true
                   
                    
                    if firstRowHeaderView?.headerContentViewBackgroundColorAlpha > cellBackroundColorAlpha{
                        self.visualEffectView.hidden = false
                        firstRowHeaderView?.headerContentView.backgroundColor = UIColor.clearColor()
                        for cell in tableView.visibleCells{
                            cell.backgroundColor = UIColor.clearColor()
                            if let firstRowCell = cell as? MovieLegendRow{
                                firstRowCell.visualEffectView.hidden = true
                            }
                        }
                        for view in tableView.subviews{
                            if let header = view as? HeaderView{
                                header.view.backgroundColor = UIColor.clearColor()
                            }
                        }
                    }
                    if firstRowHeaderView?.headerContentViewBackgroundColorAlpha < cellBackroundColorAlpha{
                        for cell in tableView.visibleCells{
                            cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: cellBackroundColorAlpha)
                        }
                        for view in tableView.subviews{
                            if let header = view as? HeaderView{
                                header.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: headerViewBackgroundColorAlpha)
                            }
                        }
                    }
                }else{
                    // if scrolling to bottom
                    movieDetailControllerDelegate?.movieDetailControllerDidScrollToBottom(self.tableView.parallaxHeader.progress)
                    
                    if firstRowHeaderView?.headerContentViewBackgroundColorAlpha < cellBackroundColorAlpha{
                        self.visualEffectView.hidden = true
                        
                        for cell in tableView.visibleCells{
                            cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: cellBackroundColorAlpha)
                        }
                        for view in tableView.subviews{
                            if let header = view as? HeaderView{
                                header.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: headerViewBackgroundColorAlpha)
                            }
                        }
                    }
                    
                    if firstRowHeaderView?.headerContentViewBackgroundColorAlpha > cellBackroundColorAlpha{
                        firstRowHeaderView?.headerContentView.backgroundColor = UIColor.clearColor()
                        self.visualEffectView.hidden = false
                    }

                }
                lastContentOffSet = currentOffSet
            }else{
                movieDetailControllerDelegate?.movieDetailControllerContentOffSetYIsNegative()
                movieLegendRow.visualEffectView.hidden = false
            }
        }
        
    }
    
    
    
    
}


