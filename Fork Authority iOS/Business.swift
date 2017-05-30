//
//  Business.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import Foundation

struct Business: CustomStringConvertible {
    
    // MARK: Properties
    var name: String
    var image_url: String
    var review_count: Int
    var categories: [String]
    var rating: Double
    var address: String
    var distance: Double
    var numberedOrder: Int? // optional int. not included in init method below.
                            // set from collection view's indexPath.item?? 
    
    init(name: String, image_url: String, review_count: Int, categories: [String], rating: Double, address: String, distance: Double) {
        self.name = name
        self.image_url = image_url
        self.review_count = review_count
        self.categories = categories
        self.rating = rating
        self.address = address
        self.distance = distance
    }
    
    var description: String {
        return "\(name) \(address): \(distance)\n"
    }
    
    // MARK: Optional Properties
    //var coordinates: [String:Int]? // store values for keys "latitude" and "longitude" (for MapView?)
    //var price: String? // would need to add this to UI
    
    
}
