//
//  TabBarControllerDelegate.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/3/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class TabBarControllerDelegate: NSObject,UITabBarControllerDelegate{
    
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if viewController is ProfileNavigationController{
            
            if let controller = tabBarController.storyboard?.instantiateViewControllerWithIdentifier("ProfileNavigationController") {
                tabBarController.presentViewController(controller, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
    
    
    

}
