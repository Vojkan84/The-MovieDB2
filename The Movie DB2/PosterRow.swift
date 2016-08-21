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
    
    var collectionViewOffset:CGFloat{
        
        get{
            return collectionView.contentOffset.x
        }
        set{
            collectionView.contentOffset.x = newValue
        }
    
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
