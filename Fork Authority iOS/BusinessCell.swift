//
//  BusinessCell.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/27/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class BusinessCell: UICollectionViewCell {
    
    var business: Business? {
        didSet {
            updateUIForCell()
        }
    }
    
    fileprivate func updateUIForCell() {
        guard let business = business else { return }
        guard let numberedOrder = business.numberedOrder else { return }
        
        businessNameLabel.text = "\(numberedOrder). " + "\(business.name)"
        addressLabel.text = business.address
        reviewsLabel.text = "\(business.review_count)" + " review\(business.review_count > 1 ? "s" : " ")"
        categoriesLabel.text = business.categories.joined(separator: ", ")
    
        if let url = URL(string: business.image_url) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        self?.businessImageView.image = UIImage(data: data)
                    }
                }
            }
        }

        if let image = UIImage(named: "\(business.rating)") {
            ratingsImageView.image = image
        }

    }
    
    let cardView: UIView = {
        let card = UIView()
        card.backgroundColor = .white
        return card
    }()
    
    lazy var businessImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var businessNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.yelpFontGrey()
        label.textAlignment = .left
        label.font = UIFont.smallBoldFont()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ratingsImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var reviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "237 reviews"
        label.textColor = UIColor.yelpFontGrey()
        label.textAlignment = .left
        label.font = UIFont.smallestFont()
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.textColor = UIColor.yelpFontGrey()
        label.textAlignment = .left
        label.font = UIFont.smallBoldFont()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var categoriesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.yelpFontGrey()
        label.textAlignment = .left
        label.font = UIFont.smallerFont()
        return label
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yelpBackgroundGrey()
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        
        // set button's tint color to grey and image's rendering mode to .alwaysTemplate for grey image
        button.tintColor = UIColor.yelpFontGrey()
        button.setImage(#imageLiteral(resourceName: "ThumbsUpUnfilled").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
        
        button.setTitle("LIKE", for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(30, -65, 0, 0)
        button.setTitleColor(UIColor.yelpFontGrey(), for: .normal)
        button.titleLabel?.font = UIFont.smallestFont()
        
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        return button
    }()
    
    func handleLike() {
        print("like pressed")
    }
    
    lazy var justAteHereImageButton: UIButton = {
        let button = UIButton(type: .system)      
        // set button's tint color to grey and image's rendering mode to .alwaysTemplate for grey image
        button.tintColor = UIColor.yelpFontGrey()
        button.setImage(#imageLiteral(resourceName: "JustAteHereUnfilled").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5)
        
        button.addTarget(self, action: #selector(handleAteHere), for: .touchUpInside)
        
        return button
    }()
    
    lazy var justAteHereTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("JUST ATE HERE", for: .normal)
        button.setTitleColor(UIColor.yelpFontGrey(), for: .normal)
        button.titleLabel?.font = UIFont.smallestFont()
        button.addTarget(self, action: #selector(handleAteHere), for: .touchUpInside)
        return button
    }()
    
    func handleAteHere() {
        print("ate here pressed")
    }
    
    lazy var dislikeImageButton: UIButton = {
        let button = UIButton(type: .system)
        
        // set button's tint color to grey and image's rendering mode to .alwaysTemplate for grey image
        button.tintColor = UIColor.yelpFontGrey()
        button.setImage(#imageLiteral(resourceName: "ThumbsDownUnfilled").withRenderingMode(.alwaysTemplate), for: .normal)
        
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        return button
    }()
    
    lazy var dislikeTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DON'T LIKE", for: .normal)
        button.setTitleColor(UIColor.yelpFontGrey(), for: .normal)
        button.titleLabel?.font = UIFont.smallestFont()
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        return button
    }()
    
    func handleDislike() {
        print("don't like pressed")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.yelpBackgroundGrey()
        
        setSubviews()
        
    }
    
    
    fileprivate func setSubviews() {
        addSubview(cardView)
        cardView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: 0, height: 0)
        
        addSubview(businessImageView)
        businessImageView.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 58 + 7, paddingRight: 0, width: 85, height: 85)
        
        let ratingsStackview = UIStackView(arrangedSubviews: [ratingsImageView, reviewsLabel])
        ratingsStackview.axis = .horizontal
        ratingsStackview.distribution = .fillProportionally
        ratingsStackview.spacing = 5
        
        addSubview(businessNameLabel)
        addSubview(ratingsStackview)
        addSubview(addressLabel)
        addSubview(categoriesLabel)
        addSubview(dividerLine)
        
        businessNameLabel.anchor(top: businessImageView.topAnchor, left: businessImageView.rightAnchor, bottom: ratingsStackview.topAnchor, right: cardView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 2, paddingRight: 5, width: 0, height: 0)
        businessNameLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        
        ratingsStackview.anchor(top: businessNameLabel.bottomAnchor, left: businessNameLabel.leftAnchor, bottom: addressLabel.topAnchor, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 2, paddingRight: 0, width: 0, height: 15)
        ratingsImageView.anchor(top: ratingsStackview.topAnchor, left: ratingsStackview.leftAnchor, bottom: ratingsStackview.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        reviewsLabel.anchor(top: ratingsStackview.topAnchor, left: nil, bottom: ratingsStackview.bottomAnchor, right: ratingsStackview.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addressLabel.anchor(top: ratingsStackview.bottomAnchor, left: ratingsStackview.leftAnchor, bottom: categoriesLabel.topAnchor, right: cardView.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 2, paddingRight: 8, width: 0, height: 0)
        addressLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        
        categoriesLabel.anchor(top: addressLabel.bottomAnchor, left: addressLabel.leftAnchor, bottom: nil, right: cardView.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        categoriesLabel.bottomAnchor.constraint(greaterThanOrEqualTo: dividerLine.bottomAnchor, constant: -8).isActive = true
        
        dividerLine.anchor(top: nil, left: cardView.leftAnchor, bottom: nil, right: cardView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 1)
        dividerLine.topAnchor.constraint(greaterThanOrEqualTo: dividerLine.bottomAnchor, constant: 8).isActive = true
        
        addSubview(likeButton)
        likeButton.anchor(top: dividerLine.topAnchor, left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 30, paddingBottom: 10, paddingRight: 0, width: 40, height: 40)
        
        addSubview(justAteHereImageButton)
        justAteHereImageButton.anchor(top: dividerLine.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 35, height: 30)
        justAteHereImageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addSubview(justAteHereTextButton)
        justAteHereTextButton.anchor(top: justAteHereImageButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 10)
        justAteHereTextButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        addSubview(dislikeImageButton)
        dislikeImageButton.anchor(top: dividerLine.topAnchor, left: nil, bottom: nil, right: cardView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 40, height: 30)
        addSubview(dislikeTextButton)
        dislikeTextButton.anchor(top: dislikeImageButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 10)
        dislikeTextButton.centerXAnchor.constraint(equalTo: dislikeImageButton.centerXAnchor).isActive = true


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
