//
//  Video.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/13/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import RealmSwift

class Video:Object{
    
    override class func primaryKey()->String{
        return "id"
    }

    dynamic var id:String = ""
    dynamic var key:String = ""
    dynamic var name:String = ""
    dynamic var site:String = ""
    dynamic var size:Int = 0
    dynamic var type:String = ""
    dynamic var thumbnailUrl:NSURL?{
        
        return NSURL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }
}
