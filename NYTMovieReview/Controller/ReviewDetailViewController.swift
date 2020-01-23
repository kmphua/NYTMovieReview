//
//  ReviewDetailViewController.swift
//  NYTMovieReview
//
//  Created by Kevin Phua on 2020/1/23.
//  Copyright © 2020 HagarSoft. All rights reserved.
//

import UIKit

class ReviewDetailViewController: UIViewController {
    
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .white
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let linkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Review Detail"
        view.backgroundColor = .white
        loadSubviews()
    }
    
    @objc func openUrl(sender: UITapGestureRecognizer) {
        if let url = URL(string: self.linkLabel.text ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    private func loadSubviews() {

        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(summaryLabel)
        view.addSubview(linkLabel)
        
        posterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        posterImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true

        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true

        summaryLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10).isActive = true
        summaryLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14).isActive = true
        summaryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true

        linkLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 10).isActive = true
        linkLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14).isActive = true
        linkLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true

        posterImageView.sizeToFit()
        summaryLabel.sizeToFit()
        
        // Make link clickable
        let linkTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewDetailViewController.openUrl))
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(linkTapGestureRecognizer)
    }
    
    func setDetailViewWith(_ review: Review) {
        DispatchQueue.main.async {
            if let rating = review.rating, let title = review.title {
                if !rating.isEmpty {
                    self.titleLabel.text = "\(title) (\(rating))"
                } else {
                    self.titleLabel.text = review.title
                }
            } else {
                self.titleLabel.text = review.title
            }
            self.authorLabel.text = review.byLine
            self.summaryLabel.text = review.summary
            self.linkLabel.text = review.linkUrl
            if let url = review.mediaUrl {
                self.posterImageView.loadImageUsingCacheWithURLString(url, placeHolder: nil)
            }
        }
    }
}
