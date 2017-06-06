//
//  BusinessHeader.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/27/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class BusinessHeader: UICollectionViewCell {
    
    var location: Location? {
        didSet {
            guard let location = location else { return }
            searchTextField.text = "\(location.name)" + " \(location.state ?? "")" + " \(location.zip ?? "")"
        }
    }
    
    let progressBar: UIProgressView = {
        let pv = UIProgressView()
        pv.progressTintColor = UIColor.yelpRed()
        return pv
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.smallerFont()
        label.textColor = UIColor.yelpFontGrey()
        label.text = "Loading stuff to eat ..."
        return label
    }()
    
    let searchTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.yelpFontGrey()
        return tf
    }()
    
    let greenIndicator: UILabel = {
        let label = UILabel()
        label.text = "•"
        label.textColor = UIColor.yelpGreen()
        label.textAlignment = .center
        label.font = UIFont.largeBoldFont()
        return label
    }()
    
    let foodOptionsLabel: UILabel = {
        let label = UILabel()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributedText = NSMutableAttributedString(string: "FOOD OPTIONS", attributes: [NSFontAttributeName: UIFont.mediumFont(), NSForegroundColorAttributeName: UIColor.yelpFontGrey(), NSParagraphStyleAttributeName: paragraph])
        attributedText.addAttribute(NSKernAttributeName, value: CGFloat(2.0), range: NSRange(location: 0, length: attributedText.length - 1))
        label.attributedText = attributedText
        return label
    }()
    
    let poweredByLabel: UILabel = {
        let label = UILabel()
        label.text = "powered by"
        label.textAlignment = .right
        label.font = UIFont.smallerItalicFont()
        label.numberOfLines = 1
        label.textColor = UIColor.yelpFontGrey()
        return label
    }()
    
    let yelpLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "yelp_logo").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.yelpBackgroundGrey()
        
        setSubviews()
    }
    
    fileprivate func setSubviews() {
        let locationStackview = UIStackView(arrangedSubviews: [searchTextField, greenIndicator])
        addSubview(locationStackview)
        locationStackview.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        searchTextField.anchor(top: locationStackview.topAnchor, left: locationStackview.leftAnchor, bottom: locationStackview.bottomAnchor, right: greenIndicator.leftAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        greenIndicator.anchor(top: locationStackview.topAnchor, left: nil, bottom: locationStackview.bottomAnchor, right: locationStackview.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 27, height: 0)
        
        addSubview(foodOptionsLabel)
        foodOptionsLabel.anchor(top: locationStackview.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        foodOptionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        let logoStackview = UIStackView(arrangedSubviews: [poweredByLabel, yelpLogo])
        logoStackview.axis = .horizontal
        logoStackview.distribution = .fillProportionally
        
        addSubview(logoStackview)
        logoStackview.anchor(top: foodOptionsLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 130, height: 20)
        logoStackview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        poweredByLabel.anchor(top: logoStackview.topAnchor, left: logoStackview.leftAnchor, bottom: logoStackview.bottomAnchor, right: yelpLogo.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        yelpLogo.anchor(top: logoStackview.topAnchor, left: nil, bottom: logoStackview.bottomAnchor, right: logoStackview.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 55, height: 0)
        
        addSubview(progressBar)
        progressBar.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 5)
        
        addSubview(progressLabel)
        progressLabel.anchor(top: nil, left: progressBar.leftAnchor, bottom: progressBar.topAnchor, right: progressBar.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 2, paddingRight: 0, width: 0, height: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
