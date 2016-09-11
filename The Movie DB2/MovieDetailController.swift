//
//  MovieDetailController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/10/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailController:UIViewController{
    
    var movie:Movie?
    
    @IBOutlet weak var photoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie?.moviePosterUrl)
        let URL = movie?.moviePosterUrl
        self.photoView.af_setImageWithURL(URL!)
        
        
        
        
    }
}
