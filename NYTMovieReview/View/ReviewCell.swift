//
//  ReviewCell.swift
//  NYTMovieReview
//
//  Created by Kevin Phua on 2020/1/23.
//  Copyright © 2020 HagarSoft. All rights reserved.
//

import Foundation
import UIKit

class ReviewCell: UITableViewCell {
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        
        addSubview(titleLabel)
        addSubview(authorLabel)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true

        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setReviewCellWith(review: Review) {
        DispatchQueue.main.async {
            self.titleLabel.text = review.title
            self.authorLabel.text = review.byLine
//            if let url = review.mediaURL {
  //              self.photoImageview.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
    //        }
        }
    }
}


