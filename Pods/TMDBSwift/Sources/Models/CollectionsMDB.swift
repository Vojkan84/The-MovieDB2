//
//  Collection.swift
//  TheMovieDBWrapperSwift
//
//  Created by George on 2016-02-08.
//  Copyright © 2016 GeorgeKye. All rights reserved.
//

import Foundation


//** CHECK LISt-> may contain collection or tv object.

public struct CollectionMDB: ArrayObject{
  
  public var id: Int?
  public var name: String?
  public var poster_path: String?
  public var backdrop_path: String?
  public var overview: String?
  public var collectionItems = [MovieMDB]()
  
  public init(results: JSON) {
    for i in 0 ..< results["parts"].count {
      collectionItems.append(MovieMDB(results: results["parts"][i]))
    }
    id = results["id"].int
    name = results["name"].string
    poster_path = results["poster_path"].string
    backdrop_path = results["backdrop_path"].string
    overview = results["overview"].string
  }
  
  ///Get the basic collection information for a specific collection id.
  public static func collection(api_key: String!, collectionId: Int!, language: String? = nil, completion: (clientReturn: ClientReturn, data: CollectionMDB?) -> ()) -> (){
    Client.Collection(api_key, collectionId: "\(collectionId)", language: language){
      apiReturn in
      if(apiReturn.error == nil){
        completion(clientReturn: apiReturn, data: CollectionMDB(results: apiReturn.json!))
      }else{
        completion(clientReturn: apiReturn, data: nil)
      }
    }
  }
  
  ///Get all of the images for a particular collection by collection id.
  public static func collectionImages(api_key: String!, collectionId: Int!, language: String?, completion:  (clientReturn: ClientReturn, data: ImagesMDB?) -> ()) -> (){
    let modId =  "\(collectionId)/images"
    Client.Collection(api_key, collectionId: modId, language: language){
      apiReturn in
      if(apiReturn.error == nil){
        completion(clientReturn: apiReturn, data: ImagesMDB.init(results: apiReturn.json!))
      }else{
        completion(clientReturn: apiReturn, data: nil)
      }
    }
  }
}