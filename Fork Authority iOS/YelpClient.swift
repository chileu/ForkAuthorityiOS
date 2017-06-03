//
//  YelpClient.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/31/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import Foundation
import CoreLocation

protocol YelpClientDelegate {
    func incrementProgress()
}

class YelpClient {
    
    // MARK: Properties
    fileprivate var businessCache = [String: Business]()
    fileprivate var total: Int?
    fileprivate var max = YelpAPI.Results.MAX_NUMBER_OF_RESULTS
    
    var delegate: YelpClientDelegate?

    // MARK: Methods for networking-related calls
    
    func fetchBusinesses(for location: Location, completion: @escaping ([Business]) -> () ) {
        
        var businessArray = [Business]()
        var offset = YelpAPI.ParamValues.offset
        let limit = YelpAPI.ParamValues.limit

        
        while offset < max {
            
            let url = "\(YelpAPI.baseURLForAPIcall)&\(YelpAPI.ParamKeys.OFFSET)\(offset)&\(YelpAPI.ParamKeys.LIMIT)\(limit)&\(YelpAPI.ParamKeys.LATITUDE)\(location.coordinate.latitude)&\(YelpAPI.ParamKeys.LONGITUDE)\(location.coordinate.longitude)"
            
            completeDataTask(with: url) { [weak self] businesses in
                
                // handle case where total is less than max number of desired results
                if let total = self?.total, let max = self?.max, total < max {
                    guard total > 0 else {
                        completion([Business]())
                        return
                    }
                    self?.max = total
                }
                
                self?.incrementProgress()
                
                businessArray += businesses
                
                if businessArray.count == self?.max {
                    completion(businessArray)
                }
                
                // get exact number of desired results by doing one last fetch (to account for 'invalid' businesses)...
                let remainingBusinesses = (self?.max ?? YelpAPI.Results.MAX_NUMBER_OF_RESULTS) - businessArray.count
                if remainingBusinesses < YelpAPI.ParamValues.limit, remainingBusinesses > 0, businessArray.count > 0 {
                    self?.incrementProgress()
                    self?.fetchRemainingBusinesses(with: url, completion: { businesses in
                            businessArray += businesses[0...remainingBusinesses-1]
                            businessArray.sort { $0.distance < $1.distance }
                            completion(businessArray)
                    })
                }
            }
            offset += YelpAPI.ParamValues.limit
        }
    }
    
    func incrementProgress() {
        delegate?.incrementProgress()
    }
    
    fileprivate func fetchRemainingBusinesses(with url: String, completion: @escaping ([Business]) -> ()) {
        let regex = try! NSRegularExpression(pattern: "(offset=)[0-9]+&", options: [])
        let newUrl = regex.stringByReplacingMatches(in: url, options: [], range: NSRange(location: 0, length: url.characters.count), withTemplate: "offset=\(max)&")
        completeDataTask(with: newUrl) { businesses in
            completion(businesses)
        }
    }
    
    fileprivate func completeDataTask(with url: String, completion: @escaping ([Business]) -> ()) {
        
        // create URL and URLRequest from params
        let url = URL(string: url)
        guard let requestUrl = url else { return }
        let request = NSMutableURLRequest(url: requestUrl)
        request.addValue(YelpAPI.Header.value, forHTTPHeaderField: YelpAPI.Header.key)
        
        // initialize the dataTask
        URLSession.shared.dataTask(with: request as URLRequest) { [weak self] (data, response, error) in
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
            
            self?.parse(json, completion: { businessArray in
                completion(businessArray)
            })
            
            }.resume()
    }
    
    fileprivate func parse(_ json: AnyObject, completion: @escaping ([Business]) -> () ) {
        
        if total == nil {
            if let total = json["total"] as? Int {
                self.total = total
            }
        }
        
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
    
}
