//
//  CollectionViewPhotoCell.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/16/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage
import CCBottomRefreshControl

class PosterRowPhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
}
