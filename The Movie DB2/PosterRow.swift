//
//  PosterRow.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/16/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class PosterRow: UITableViewCell {
    
   

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage(named:"jason bourne"),UIImage(named:"equalizer"),UIImage(named:"batman")]
  
    
 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupDataForCollectionView()
        startTimer()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupDataForCollectionView(){
        
        var originalImages = [UIImage(named:"jason bourne"),UIImage(named:"equalizer"),UIImage(named:"batman")]
        let firstItem = originalImages[0]
        let lastItem = originalImages.last
        var workingImages = originalImages
        workingImages.insert(lastItem!, atIndex: 0)
        workingImages.append(firstItem!)
        self.images = workingImages
    }
    func scrollToNextCell(){
        
        let cellSize = CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height)
        let contentOffSet = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRectMake(contentOffSet.x+cellSize.width, contentOffSet.y, cellSize.width, cellSize.height), animated: true)
        
    }
    
    func startTimer(){
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let contentOffSetWhenFullyScrolledRight = self.collectionView.frame.size.width * CGFloat(self.images.count-1)
        
        if scrollView.contentOffset.x == contentOffSetWhenFullyScrolledRight{
            let newIndexPath = NSIndexPath(forItem: 1, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        }else if scrollView.contentOffset.x == 0{
            let newIndexPath = NSIndexPath(forItem: self.images.count - 2, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        }

        
    }
  

}
extension PosterRow:UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTOCELL", forIndexPath: indexPath) as! CollectionViewPhotoCell
        cell.photoView.image = images[indexPath.row]
        return cell
    }
    
}
extension PosterRow:UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.size.width
        let itemHeight = collectionView.bounds.size.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return CGFloat.min
    }

}
