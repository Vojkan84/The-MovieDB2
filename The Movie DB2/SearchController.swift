//
//  SearchController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 10/17/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchController:UIViewController,UISearchBarDelegate{
    
    
    var data = ["a","ab","abc"]
    var movies:[Movie]?
    var tvShows = ["1","2","3","4","5"]
    var names = ["pera","mika","zika","laza"]
    var filteredData = [AnyObject]()
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
        
        if segmentedControl.selectedSegmentIndex == 0{
            var fData = filteredData as! [Movie]
            MovieService.sharedInstace.searchMoviesByText(searchText, result: { (movies, error) in
                
                if let err = error{
                    print(err)
                }else{
                    self.movies = movies
                    self.filteredData = self.movies!
                    self.tableView.reloadData()
                }
            })
        }
        //        filteredData = data.filter{ object in
        //            return object.lowercaseString.containsString(searchText.lowercaseString)
        //        }
        //        if filteredData.count == 0{
        //            searchBarActive = false
        //        }else{
        //            searchBarActive = true
        //        }
        tableView.reloadData()
    }
    func valueChanged(segmentedControl:UISegmentedControl){
        if segmentedControl.selectedSegmentIndex == 0 {
            self.filteredData = self.movies!
        }else if segmentedControl.selectedSegmentIndex == 1{
            self.filteredData = self.numbers
        }else if segmentedControl.selectedSegmentIndex == 2{
            self.filteredData = self.names
        }else{
            self.filteredData = self.movies!
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
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MovieAndTVShowSearchResultCell", forIndexPath: indexPath) as! MovieAndTVShowSearchResultCell
        if segmentedControl.selectedSegmentIndex == 0 && movies != nil{
            let movies = filteredData as! [Movie]
            let movie = movies[indexPath.row]
            if let URL = movie.moviePosterUrl{
                print(URL)
                movieCell.photoView?.af_setImageWithURL(URL,
                                                   placeholderImage: UIImage(named:"default"),
                                                   filter: nil,
                                                   imageTransition: .CrossDissolve(0.2)
                )
                movieCell.nameLabel.text = movie.movieTitle
            }else{
                movieCell.photoView.image = nil
                movieCell.nameLabel.text = ""
            }
         
    
            
        }
        return movieCell
//        let cell = tableView.dequeueReusableCellWithIdentifier("MovieAndTVShowSearchResultCell")
//        let text:String
//        if searchBarActive && searchBar.text != ""{
//            text = filteredData[indexPath.row].title
//        }else{
//            text = data[indexPath.row]
//        }
//        cell?.textLabel?.text = text
//        return cell!
    }

    
    
}
extension SearchController:UITableViewDelegate{
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
}

