//
//  Client_TV.swift
//  MDBSwiftWrapper
//
//  Created by George on 2016-02-15.
//  Copyright © 2016 GeorgeKye. All rights reserved.
//

import Foundation

extension Client{
  static func TV(urlType: String!, api_key: String!, page: Int?, language: String?, timezone: String?, append_to: [String]? = nil, completion: (ClientReturn) -> ()) -> (){
    
    var parameters: [String : AnyObject] = ["api_key": api_key]
    if(page != nil){
      parameters["page"] = page
    }
    if(language != nil){
      parameters["language"] = language
    }
    if(timezone != nil){
      parameters["timezone"] = timezone
    }
    if append_to != nil{
      parameters["append_to_response"] = append_to?.joinWithSeparator(",")
    }
    
    let url = "https://api.themoviedb.org/3/tv/\(urlType)"
    
    networkRequest(url: url, parameters: parameters, completion: {
      apiReturn in
      completion(apiReturn)
    })
  }
}

