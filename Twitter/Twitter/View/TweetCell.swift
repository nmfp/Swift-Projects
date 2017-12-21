//
//  TweetCell.swift
//  Twitter
//
//  Created by Nuno Pereira on 26/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import LBTAComponents
import UIKit

class TweetCell: DatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let tweet = datasourceItem as? Tweet else {return}
            
            //Coloca o nome do user a bold na textView
            let attributedString = NSMutableAttributedString(string: tweet.user.name, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
            
            let usernameString = "  \(tweet.user.username)\n"
            
            //Coloca o username do user a cinzento na textView
            attributedString.append(NSAttributedString(string: usernameString, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.gray]))
            
            
            //Cria-se um NSMutableParagraphStyle para se poder definir o espaco entre cada linha neste caso 4
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4;
            
            //E definida a range desde o inicio da tetView ate ao fim da attributedString e adiciona-se este atributo antes da mensagem para so se dar este espaco entre linhas, entre a primeira e a segunda linhas
            let range = NSRange(location: 0, length: attributedString.string.count); // ou podia ser attributedString.string.characters.count
            attributedString.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: range)
            
            //Coloca a mensagem na textView na linha abaixo do user e username
            attributedString.append(NSAttributedString(string: tweet.message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)]))
            
            messageTextView.attributedText = attributedString
            
            profileImageView.loadImage(urlString: tweet.user.profileImageUrl)
        }
    }
    
    let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "reply").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "retweet").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    let directMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send_message").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    
    
    
    
    
    
    
    
    var messageTextView: UITextView = {
       let tv = UITextView()
        tv.text = "SOME SAMPLE TEXT"
        tv.backgroundColor = .clear
        return tv
    }()
    
    
    var profileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "profile_image")
        return imageView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        separatorLineView.isHidden = false
        
        separatorLineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        backgroundColor = .white
        
        addSubview(profileImageView)
        
        addSubview(messageTextView)
        
//        addSubview(replyButton)
//        addSubview(retweetButton)
        
        messageTextView.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        profileImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
//        replyButton.anchor(nil, left: messageTextView.leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        
        setupBottomButtons()
    }
    
    private func setupBottomButtons() {
        let replyButtonContainerView = UIView()
        let retweetButtonContainerView = UIView()
        let likeButtonContainerView = UIView()
        let directMessageButtonContainerView = UIView()
        
        let buttonStackView = UIStackView(arrangedSubviews: [replyButtonContainerView, retweetButtonContainerView, likeButtonContainerView, directMessageButtonContainerView])
        
        //E necessario definir estas propriedades senao so aparece uma vista na stackView
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        addSubview(buttonStackView)
        
        buttonStackView.anchor(nil, left: messageTextView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        addSubview(replyButton)
        addSubview(retweetButton)
        addSubview(likeButton)
        addSubview(directMessageButton)
        
        replyButton.anchor(replyButtonContainerView.topAnchor, left: replyButtonContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        
        retweetButton.anchor(retweetButtonContainerView.topAnchor, left: retweetButtonContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        
        likeButton.anchor(likeButtonContainerView.topAnchor, left: likeButtonContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        
        directMessageButton.anchor(directMessageButtonContainerView.topAnchor, left: directMessageButtonContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
    }
}
