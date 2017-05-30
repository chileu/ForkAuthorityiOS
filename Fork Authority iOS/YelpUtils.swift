//
//  YelpUtils.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import Foundation

struct YelpAPI {
    
    static func fetchBusinesses(for location: Location, completion: @escaping ([Business]) -> () ) {
        let baseUrl = "\(URL.BASE)\(ParamKeys.TERM)\(ParamValues.food)&\(ParamKeys.RADIUS)\(ParamValues.radius)&\(ParamKeys.LATITUDE)\(location.coordinate.latitude)&\(ParamKeys.LONGITUDE)\(location.coordinate.longitude)"
        print(baseUrl)
        
        
        
    }
    
    
    struct URL {
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
        static let limit = 20
        static let offset = 0
        static let radius = 1609 // 1609 meters / mile.
        static let maximumLimit = 50
    }
    
    struct Headers {
        static let headers = ["Authorization": "Bearer \(accessToken)"]
    }
    
    struct Results {
        static let MAX_NUMBER_OF_RESULTS = 200
    }
}

