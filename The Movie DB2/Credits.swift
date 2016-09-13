//
//  CreditsModel.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/12/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import Foundation
import RealmSwift

class Credits:Object {
    
    override class func primaryKey()->String{
        return "id"
    }

    dynamic var id:Int = 0
    let casts = List<Cast>()
    let crew = List<CrewMember>()
    
    }
