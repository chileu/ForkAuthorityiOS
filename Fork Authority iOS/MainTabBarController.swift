//
//  MainTabBarController.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/27/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use UICollectionViewFLOWLAYOUT when instantiating collection view controller
        let mainController = GeocoderViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: mainController)
        navController.tabBarItem.image = #imageLiteral(resourceName: "home_unselected").withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected").withRenderingMode(.alwaysOriginal)
        
        viewControllers = [navController]
        
        
    }
    
    
}
