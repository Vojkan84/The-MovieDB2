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
    
    
    var sectionNames = ["MovieDetail","Photos","Trailer","Director","Cast"]
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
                                    print(self!.movie)
                                    self!.tableView.reloadData()
                                })
                                
                                try! realm.write{
                                    
                                    realm.create(Movie.self, value:["movieID":self!.movieId!, "credits":credits!, "album":album!, "videos":videos!],update:true)
                                    print(self!.movie)
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
        
        return sectionNames.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if movie == nil{
            return UITableViewCell()
        }
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieLegendRow", forIndexPath: indexPath) as! MovieLegendRow
            
            let movie = self.movie?.first
            cell.titleTextField.text = movie!.movieTitle
            cell.overviewTextView.textColor = UIColor.whiteColor()
            cell.overviewTextView.text = movie!.overview
            cell.voteAverageTextField.text = String(movie!.voteAverage)
            cell.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetailPhotoRow",forIndexPath:indexPath) as! MovieDetailPhotoRow
            cell.collectionView.tag = indexPath.section+200
            cell.collectionView.reloadData()
            return cell
        default:break
        }
        return UITableViewCell()
        
    }
}
extension MovieDetailController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return (tableView.bounds.height - navigationController!.navigationBar.bounds.height)/2 - 44
        case 1:
            return (tableView.bounds.height - navigationController!.navigationBar.bounds.height-44)/3
        default:
            return tableView.rowHeight
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return tableView.bounds.height/1.6
        }
        return tableView.sectionHeaderHeight
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
}
extension MovieDetailController:UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 201:
            
            return (movie?.first?.album?.backdrops.count)!
        default:
            return 0
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag{
        case 201:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieDetailPhotoCell", forIndexPath: indexPath) as! MovieDetailPhotoCell
            let url = movie?.first?.album?.backdrops[indexPath.item].url
            cell.photoView.af_setImageWithURL(url!,
                                              placeholderImage: UIImage(named: "default"),
                                              imageTransition: .CrossDissolve(0.2))
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
}
extension MovieDetailController:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionView.tag == 201{
            let itemWidth = collectionView.bounds.size.width/4*3
            let itemHeight = collectionView.bounds.size.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
     return CGSize(width: 0, height: 0)
    }

}
