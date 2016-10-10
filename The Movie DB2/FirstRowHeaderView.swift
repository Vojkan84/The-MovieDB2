//
//  FirstRowHeaderView.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 10/3/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class FirstRowHeaderView:HeaderView,MovieDetailControllerDelegate{
    
    @IBOutlet weak var stickyView: UIView!
    
    
    func movieDetailControllerDidScrollToTop(){
        
        stickyView.hidden = true
        stickyView.bounds = CGRect(x: 0, y: 0, width: stickyView.bounds.size.width, height: stickyView.bounds.size.height)
    }
    func movieDetailControllerDidScrollToBottom(){
        
//        stickyView.hidden = false
        
        
    }
    func movieDetailControllerContentOffSetYIsNegative(){
     stickyView.hidden = false
    }


}
