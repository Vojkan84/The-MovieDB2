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

    @IBOutlet weak var headerContentView: UIView!
    var headerContentViewBackgroundColorAlpha : CGFloat?
    
    func movieDetailControllerDidScrollToTop(paralaxHeaderProgress:CGFloat){
        
        stickyView.hidden = true
        stickyView.bounds = CGRect(x: 0, y: 0, width: stickyView.bounds.size.width, height: stickyView.bounds.size.height)
        headerContentViewBackgroundColorAlpha = 1 - paralaxHeaderProgress
        headerContentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: headerContentViewBackgroundColorAlpha!)
    }
    func movieDetailControllerDidScrollToBottom(paralaxHeaderProgress:CGFloat){
        
        headerContentViewBackgroundColorAlpha = 1 - paralaxHeaderProgress
        headerContentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: headerContentViewBackgroundColorAlpha!)
        
        
    }
    func movieDetailControllerContentOffSetYIsNegative(){
     stickyView.hidden = false
   
    }


}
