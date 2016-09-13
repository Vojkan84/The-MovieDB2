//
//  Crew.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/12/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import RealmSwift

class CrewMember:Object{
    
    
    override class func primaryKey()->String{
        return "creditId"
    }
    
    dynamic var creditId:String = ""
    dynamic var department:String = ""
    dynamic var id:Int = 0
    dynamic var job:String = ""
    dynamic var name:String = ""
    dynamic var profilePath:String = ""
    
    
}
