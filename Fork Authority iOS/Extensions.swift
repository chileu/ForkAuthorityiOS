//
//  Extensions.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/27/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func yelpBackgroundGrey() -> UIColor {
        return UIColor.rgb(red: 230, green: 230, blue: 230)
    }
    
    static func yelpFontGrey() -> UIColor {
        return UIColor.rgb(red: 153, green: 153, blue: 153)
    }
    
    static func yelpRed() -> UIColor {
        return UIColor.rgb(red: 211, green: 35, blue: 35)
    }
    
    static func yelpGreen() -> UIColor {
        return UIColor.rgb(red: 65, green: 167, blue: 0)
    }
    
    
}
// font vars
let largeFontSize = CGFloat(21)
let mediumFontSize = CGFloat(18)
let smallFontSize = CGFloat(15)
let smallerFontSize = CGFloat(12)
let smallestFontSize = CGFloat(10)

extension UIFont {
  
    // bold
    static func largeBoldFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: largeFontSize)
    }
    
    static func mediumBoldFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: mediumFontSize)
    }
    
    static func smallBoldFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: smallFontSize)
    }
    static func smallerBoldFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: smallerFontSize)
    }
    
    static func smallestBoldFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: smallestFontSize)
    }
    
    // regular
    static func mediumFont() -> UIFont {
        return UIFont.systemFont(ofSize: mediumFontSize)
    }
    
    static func smallFont() -> UIFont {
        return UIFont.systemFont(ofSize: smallFontSize)
    }
    
    static func smallerFont() -> UIFont {
        return UIFont.systemFont(ofSize: smallerFontSize)
    }
    
    static func smallestFont() -> UIFont {
        return UIFont.systemFont(ofSize: smallestFontSize)
    }
    
    // italic
    static func smallestItalicFont() -> UIFont {
        return UIFont.italicSystemFont(ofSize: 12)
    }
    
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        // set this line - easy to forget
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}


