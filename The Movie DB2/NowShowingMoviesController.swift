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