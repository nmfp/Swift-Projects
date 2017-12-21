//
//  PageCell.swift
//  AutoLayout_LBTA
//
//  Created by Nuno Pereira on 29/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var page : Page? {
        didSet{
            guard let unwrappedPage = page else {return}
            bearImageView.image = UIImage(named: unwrappedPage.imageName)
            
            let attributedText = NSMutableAttributedString(string: unwrappedPage.headerString, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)])
            attributedText.append(NSAttributedString(string: "\n\n\n\(unwrappedPage.bodyText)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.gray]))
            
            descriptionTextView.attributedText = attributedText
            
            //sempte que se altera o attributedText o textAlignment volta a ficar por defeito que e a esquerda
            descriptionTextView.textAlignment = .center
        }
    }
    
    private let bearImageView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bear_first"));
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Join us today in our fun and games!", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n\n\nAre you ready for loads and loads of fun? Dont wait any longer! We hope to seee you in out stores soon! ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        tv.attributedText = attributedText

        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    
    private func setupLayout() {
        let imageContainerView = UIView()
        addSubview(imageContainerView)
        addSubview(descriptionTextView)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        imageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageContainerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageContainerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        imageContainerView.addSubview(bearImageView)
        
        bearImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        bearImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        bearImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.6).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: 0).isActive = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
