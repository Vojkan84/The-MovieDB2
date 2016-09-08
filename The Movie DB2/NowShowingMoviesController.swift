//
//  NowPlayingMoviesController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/8/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

class NowShowingMoviesController:UIViewController{
    
    var nowShowingMovies:Results<Movie>?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Now Showing"
        
        self.nowShowingMovies = MovieService.sharedInstace.loadMovies(fromList: "now_playing")

    }
    
}

extension NowShowingMoviesController:UICollectionViewDataSource{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = self.nowShowingMovies{
            return movies.count
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NowShowingCell", forIndexPath: indexPath) as! NowShowingCell
        let URL = nowShowingMovies![indexPath.row].moviePosterUrl
        cell.photoView.af_setImageWithURL(URL!)
        return cell
    }
}

extension NowShowingMoviesController:UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
        let itemsPerRow : CGFloat = 3
        let itemsPerColumn:CGFloat = 3
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (collectionView.bounds.size.width - 2*layout.minimumInteritemSpacing)/itemsPerRow
        let itemHeight = (collectionView.bounds.size.height - 4*layout.minimumLineSpacing)/itemsPerColumn
        return CGSize(width: itemWidth, height: itemHeight)
    
    }
    
}