//
//  MovieController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/16/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class MovieController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var movieLists = ["Poster","Showing Today","Top Rated","Popular"]
    var timer = NSTimer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
  
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("MEMORY WARNING")
    }

}

extension MovieController:UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return movieLists.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let posterCell = tableView.dequeueReusableCellWithIdentifier("POSTERCELL", forIndexPath: indexPath) as! PosterRow
            return posterCell
        }else{
            let movieCell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as! MovieListRow
            return movieCell
        }
    }
}

extension MovieController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 220
        }
        return tableView.rowHeight
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        return movieLists[section]
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }

    
}
