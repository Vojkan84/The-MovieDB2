//
//  MovieDetailDirectorCell.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/16/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class MovieDetailDirectorCell:UICollectionViewCell{
    
    @IBOutlet weak var photoView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    
    override var bounds: CGRect{
        didSet{
            
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.photoView.layer.masksToBounds = true
        self.photoView.layer.cornerRadius = self.photoView.frame.size.width/2.0
     
       
     
    }
    
}
