//
//  SearchController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 10/17/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class SearchController:UIViewController,UITableViewDataSource{
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
