//
//  YelpUtils.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import Foundation
import CoreLocation

fileprivate var businessCache = [String: Business]()

struct YelpAPI {
    
    struct URLSTRING {
        static let BASE = "https://api.yelp.com/v3/businesses/search?"
    }
    
    struct ParamKeys {
        static let LATITUDE = "latitude="
        static let LONGITUDE = "longitude="
        static let LOCATION = "location="
        static let TERM = "term="
        static let LIMIT = "limit="
        static let OFFSET = "offset="
        static let RADIUS = "radius="
    }
    
    struct ParamValues {
        static let food = "food"
        static let limit = 50
        static let offset = 0
        static let radius = 1609 // 1609 meters / mile.
        static let maximumLimit = 50
    }
    
    struct Header {
        static let key = "Authorization"
        static let value = "Bearer \(accessToken)"
    }
    
    struct Results {
        static let MAX_NUMBER_OF_RESULTS = 200
    }
    
    static func fetchBusinesses(for location: Location, completion: @escaping ([Business]) -> () ) {

        var businessArray = [Business]()
        var offset = ParamValues.offset
        
        while offset < Results.MAX_NUMBER_OF_RESULTS {
            
            let url = "\(URLSTRING.BASE)\(ParamKeys.TERM)\(ParamValues.food)&\(ParamKeys.RADIUS)\(ParamValues.radius)&\(ParamKeys.OFFSET)\(offset)&\(ParamKeys.LIMIT)\(ParamValues.limit)&\(ParamKeys.LATITUDE)\(location.coordinate.latitude)&\(ParamKeys.LONGITUDE)\(location.coordinate.longitude)"
            
            completeDataTask(with: url) { businesses in
                businessArray += businesses
                
                if Results.MAX_NUMBER_OF_RESULTS - businessArray.count < ParamValues.limit {
                    businessArray.sort { $0.distance < $1.distance }
                    completion(businessArray)
                }
                
            }
            offset += ParamValues.limit
            print(url)
        }
        
    }
    

}

fileprivate func completeDataTask(with url: String, completion: @escaping ([Business]) -> ()) {
    
    // create URL and URLRequest from params
    let url = URL(string: url)
    guard let requestUrl = url else { return }
    let request = NSMutableURLRequest(url: requestUrl)
    request.addValue(YelpAPI.Header.value, forHTTPHeaderField: YelpAPI.Header.key)

    // initialize the dataTask
    URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            print("There was an error with your request: \(error)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("Your request returned a status code other than 2xx!")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            print("No data was returned by the request!")
            return
        }
        
        // convert data to json object
        var json: AnyObject! = nil
        do {
            json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch let error {
            print("Failed to parse data as json", error)
        }
        
        parse(json, completion: { businessArray in
            completion(businessArray)
        })
        
        }.resume()
}

fileprivate func parse(_ json: AnyObject, completion: @escaping ([Business]) -> () ) {
    guard let businesses = json["businesses"] as? [Dictionary<String, AnyObject>] else {
        print("Failed to get businesses from json")
        return
    }
    
    var businessArray = [Business]()
    
    for business in businesses {
        guard let id = business["id"] as? String else {
            print("id not found for:", business)
            continue
        }
        
        // prevent duplicates by checking if the business id is already in the businessesCache
        if let _ = businessCache[id] {
            print("\(id) already exists in business cache")
            continue
        }
        
        guard let distance = business["distance"] as? Double else {
            print("Failed to find distance for business: ", id)
            continue
        }
        
        guard let name = business["name"] as? String else {
            print("Failed to find name for business: ", id)
            continue
        }
        
        guard let image_url = business["image_url"] as? String else {
            print("Failed to find imageUrl for business: ", id)
            continue
        }
        
        guard let review_count = business["review_count"] as? Int else {
            print("Failed to find review count for business: ", id)
            continue
        }
        
        var categoriesArray = [String]()
        guard let categories = business["categories"] as? [Dictionary<String,AnyObject>] else {
            continue
        }
        for category in categories {
            guard let title = category["title"] as? String else {
                print("Failed to find category title for business: ", id)
                continue
            }
            categoriesArray.append(title)
        }
        
        guard let rating = business["rating"] as? Double else {
            print("Failed to find rating for business: ", id)
            continue
        }
        
        guard let location = business["location"] as? Dictionary<String,AnyObject> else {
            print("Failed to find location for business: ", id)
            continue
        }
        
        guard let address = location["address1"] as? String, address != "" else {
            print("Failed to find address1 for business: ", id)
            continue
        }
        
        let business = Business(name: name, image_url: image_url, review_count: review_count, categories: categoriesArray, rating: rating, address: address, distance: distance)
        businessArray.append(business)
        businessCache[id] = business
    }
    completion(businessArray)

}



