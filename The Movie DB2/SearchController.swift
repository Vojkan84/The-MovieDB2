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
    var tvShows:[TVShow]?
    var names = ["pera","mika","zika","laza"]
    var filteredData = [AnyObject]()
    var searchBarActive:Bool = false
    var searchText:String?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControlContentView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        
        segmentedControl.addTarget(self, action: #selector(valueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
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
        
        self.searchText = searchText
        if segmentedControl.selectedSegmentIndex == 0 && searchText != ""{
            searchMovies(self.searchText!)
        }
        if segmentedControl.selectedSegmentIndex == 1 && searchText != ""{
            searchTVShows(self.searchText!)
        }
        self.tableView.reloadData()
    }
    func valueChanged(segmentedControl:UISegmentedControl){
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            if searchText == nil || searchText == ""{return}
                searchMovies(searchText!)
            
        }else if segmentedControl.selectedSegmentIndex == 1{
            
            if searchText == nil || searchText == "" {return}
            searchTVShows(searchText!)
        }else if segmentedControl.selectedSegmentIndex == 2{
            self.filteredData = self.names
        }else{
            self.filteredData = self.movies!
        }
        self.tableView.reloadData()
    }
    func searchMovies(searchText:String){
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
    func searchTVShows(searchText:String){
        TVShowService.sharedInstance.searchTVShow(byText: searchText, result: { (tvShows, error) in
            if let err = error{
                print(err)
            }else{
                self.tvShows = tvShows
                self.filteredData = self.tvShows!
                self.tableView.reloadData()
            }
        })
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieAndTVShowSearchResultCell", forIndexPath: indexPath) as! MovieAndTVShowSearchResultCell
        if segmentedControl.selectedSegmentIndex == 0 && movies != nil{
            print(segmentedControl.selectedSegmentIndex)
            let movies = self.movies
            let movie = movies![indexPath.row]
            if let URL = movie.moviePosterUrl{
                cell.photoView?.af_setImageWithURL(URL,
                                                   placeholderImage: UIImage(named:"default"),
                                                   filter: nil,
                                                   imageTransition: .CrossDissolve(0.2)
                )
                cell.nameLabel.text = movie.movieTitle
            }
        }else if segmentedControl.selectedSegmentIndex == 1 && self.tvShows != nil{
            let tvShows = self.tvShows
            let tvShow = tvShows![indexPath.row]
            if let URL = tvShow.posterURL{
                
                cell.photoView.af_setImageWithURL(URL, placeholderImage: UIImage(named: "default"), filter: nil, imageTransition: .CrossDissolve(0.2)
                )
            }
            cell.nameLabel.text = tvShow.name
            
        }else{
            cell.photoView.image = nil
            cell.nameLabel.text = ""
            
            
            
        }
        return cell
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

