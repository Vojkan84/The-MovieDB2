//
//  TMDBTabBarController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/20/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class TMDBTabBarController: UITabBarController,UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        
    }

}
