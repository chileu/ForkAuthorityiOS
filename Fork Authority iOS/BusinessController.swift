//
//  BusinessController.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/27/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class BusinessController: UICollectionViewController, UICollectionViewDelegateFlowLayout, YelpClientDelegate {
    
    var location: Location? {
        didSet {
            // set searchTextField in header - is there a way to reload header only?...
            collectionView?.reloadData()
            
            // get yelp results for location
            guard let location = location else { return }
            searchYelp(for: location)
        }
    }
    var businesses = [Business]()
    let cellId = "cellId"
    let headerId = "headerId"
    let yelpClient = YelpClient()
    
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
    
    func searchYelp(for location: Location) {
        
        yelpClient.delegate = self

        yelpClient.fetchBusinesses(for: location) { [weak self] (businesses) in
            if !businesses.isEmpty {
                DispatchQueue.main.async {
                    self?.businesses = businesses
                    self?.collectionView?.reloadData()
                }
            }
        }
        
    }
    
    func incrementProgress() {
        print("progress is incrementing...")
    }
    
    override func didReceiveMemoryWarning() {
        imageCache.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.yelpBackgroundGrey()
        collectionView?.register(BusinessCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(BusinessHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        // creates a sticky header
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        addBanner()

    }
    
    fileprivate func addBanner() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        navBar.addSubview(bannerView)
        bannerView.anchor(top: navBar.topAnchor, left: navBar.leftAnchor, bottom: navBar.bottomAnchor, right: navBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        bannerView.addSubview(bannerLabel)
        bannerLabel.anchor(top: nil, left: bannerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        bannerLabel.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BusinessCell

        cell.business = businesses[indexPath.item]
        cell.business?.numberedOrder = indexPath.item + 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // create a dummy cell so that comments are sized properly according to their content
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        let dummyCell = BusinessCell(frame: frame)
        
        // set the cell's business after making api call
        dummyCell.business = businesses[indexPath.item]
        dummyCell.business?.numberedOrder = indexPath.item + 1
        
        dummyCell.layoutIfNeeded()      // this needs to be set after you load in the comment!! very important
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(10 + 85 + 9 + 40 + 5, estimatedSize.height) // businessImage top padding + image + (divider padding 8 + line 1)
                                                                     // + button height + bottom padding 5
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! BusinessHeader

        if location != nil {
            header.location = location
            header.greenIndicator.isHidden = false
        } else {
            header.greenIndicator.isHidden = true
        }
        
        return header
    }
    
    // *must* specify this method to render the header (unlike cell, which can be rendered without additional methods)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 105)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

