//
//  SearchController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 10/17/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class SearchController:UIViewController,UISearchBarDelegate{
    
   
    var data = ["a","ab","abc","abcd","abcd","abcde","acdef","abcdefg"]
    var letters = ["a","ab","abc","abcd","abcd","abcde","acdef","abcdefg"]
    var numbers = ["1","2","3","4","5"]
    var names = ["pera","mika","zika","laza"]
    var filteredData = [String]()
    var searchBarActive:Bool = false
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControlContentView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      searchBar.delegate = self
        
  
        segmentedControl.addTarget(self, action: #selector(valueChanged), forControlEvents: UIControlEvents.ValueChanged)

    }
    override func viewWillAppear(animated: Bool) {
        

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
    func valueChanged(segmentedControl:UISegmentedControl){
        if segmentedControl.selectedSegmentIndex == 0 {
            self.data = self.letters
        }else if segmentedControl.selectedSegmentIndex == 1{
            self.data = self.numbers
        }else if segmentedControl.selectedSegmentIndex == 2{
            self.data = self.names
        }else{
            self.data = self.letters
        }
        self.tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
 
}
extension SearchController:UITableViewDataSource{
    
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
extension SearchController:UITableViewDelegate{
    

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
}

