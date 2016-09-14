//
//  Backdrops.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/13/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import RealmSwift

class Backdrop:Object{
    
    dynamic var aspectRatio:Double = 0
    dynamic var filePath:String = ""
    dynamic var height:Int = 0
    dynamic var voteAverage:Double = 0
    dynamic var voteCount:Int = 0
    dynamic var width:Int = 0
    dynamic var url:NSURL?{
         let path = "https://image.tmdb.org/t/p/w342\(filePath)"
         return NSURL(string: path)
    }

}