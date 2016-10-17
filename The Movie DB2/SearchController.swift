//
//  SearchController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 10/17/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class SearchController:UIViewController,UITableViewDataSource,UISearchBarDelegate{
    
   
    var data = ["a","ab","abc","abcd","abcd","abcde","acdef","abcdefg"]
    var numbers = ["1","2","3","4","5"]
    var filteredData = [String]()
    var searchBarActive:Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      searchBar.delegate = self

        
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBarActive = true
        
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBarActive = false
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarActive = false
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBarActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = data.filter{ sentence in
            return sentence.lowercaseString.containsString(searchText.lowercaseString)
        }
        if filteredData.count == 0{
            searchBarActive = false
        }else{
            searchBarActive = true
        }
        tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarActive && searchBar.text != ""{
            return filteredData.count
        }
        
        return data.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchControllerCell")
        let text:String
        if searchBarActive && searchBar.text != ""{
            text = filteredData[indexPath.row]
        }else{
            text = data[indexPath.row]
        }
        cell?.textLabel?.text = text
        return cell!
    }
}

