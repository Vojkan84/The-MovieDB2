//
//  MovieListRow.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/16/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import AlamofireImage

class NowShowingRow: UITableViewCell {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nowShowingMovies:[Movie]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        TMDBMenager.sharedManager.fetchNowShowingMovies { (movies, error) in
            
            if let err = error {
                print(err)
            }else{
                self.nowShowingMovies = movies
                self.collectionView.reloadData()
                
            }
            
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension NowShowingRow:UICollectionViewDataSource{
    
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
extension NowShowingRow:UICollectionViewDelegateFlowLayout{

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsPerRow : CGFloat = 3
        let hardcodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.size.width/itemsPerRow)-hardcodedPadding
        let itemHeight = collectionView.bounds.size.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

