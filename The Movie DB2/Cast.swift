//
//  Cast.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/12/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import RealmSwift

class Cast:Object{

    override class func primaryKey()->String{
        return "creditId"
    }
    
    dynamic var castId:Int = 0
    dynamic var character:String = ""
    dynamic var creditId:String = ""
    dynamic var id:Int = 0
    dynamic var name:String = ""
    dynamic var order:Int = 0
    dynamic var profilePath:String = ""
    dynamic var profileImagelUrl:NSURL?{
        
        return NSURL(string: "https://image.tmdb.org/t/p/w342\(profilePath)")
    }
    
}
