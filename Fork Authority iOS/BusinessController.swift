//
//  BusinessController.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/27/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class BusinessController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    let bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yelpRed()
        return view
    }()
    
    let bannerLabel: UILabel = {
        let label = UILabel()
        label.text = "Fork Authority"
        label.font = UIFont.mediumBoldFont()
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(BusinessCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(BusinessHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        guard let navBar = navigationController?.navigationBar else { return }
       
        navBar.addSubview(bannerView)
        bannerView.anchor(top: navBar.topAnchor, left: navBar.leftAnchor, bottom: navBar.bottomAnchor, right: navBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        bannerView.addSubview(bannerLabel)
        bannerLabel.anchor(top: nil, left: bannerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bannerLabel.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor).isActive = true

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BusinessCell

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // create a dummy cell so that comments are sized properly according to their content
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        let dummyCell = BusinessCell(frame: frame)
        
        // set the cell's business after making api call
        //dummyCell.business = business[indexPath.item]
        
        dummyCell.layoutIfNeeded()      // this needs to be set after you load in the comment!! very important
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(10 + 85 + 9 + 40 + 5, estimatedSize.height) // businessImage top padding + image + (divider padding 8 + line 1)
                                                                     // + button height + bottom padding 5
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! BusinessHeader

        
        return header
    }
    
    // *must* specify this method to render the header (unlike cell, which can be rendered without additional methods)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
