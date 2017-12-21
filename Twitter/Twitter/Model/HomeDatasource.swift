//
//  HomeDatasource.swift
//  Twitter
//
//  Created by Nuno Pereira on 23/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import LBTAComponents
import TRON
import SwiftyJSON

extension Collection where Iterator.Element == JSON {
    func decode<T: JSONDecodable>() throws -> [T] {
        return try map({try T(json: $0)})
    }
}

class HomeDatasource: Datasource, JSONDecodable {
    
//    let users : [User] = {
//        let brianUser = User(name: "Nuno Pereira", username: "@nmfp", textBio: "iPhone, iPad, iOS Programming Community. Join us to learn Swift, Objective-C and build apps!", profileImage: #imageLiteral(resourceName: "profile_image"))
//        let rayUser = User(name: "Ray Wenderlich", username: "@rwenderlich", textBio: "Ray Wenderlich is an iPhone developer and...", profileImage: #imageLiteral(resourceName: "profile_image"))
//        let kindleCourse = User(name: "kindleCourse", username: "@kindleCourse", textBio: "iPhone, iPad, iOS Programming Community. Join us to learn Swift, Objective-C and build apps!iPhone, iPad, iOS Programming Community. Join us to learn Swift, Objective-C and build apps!iPhone, iPad, iOS Programming Community. Join us to learn Swift, Objective-C and build apps!iPhone, iPad, iOS Programming Community. Join us to learn Swift, Objective-C and build apps!", profileImage: #imageLiteral(resourceName: "profile_image"))
//        return[brianUser, rayUser, kindleCourse ]
//    }()

    let users: [User]
    let tweets: [Tweet]
    
    required init(json: JSON) throws {
//        var users = [User]()
        guard let usersJsonArray = json["users"].array else {
            throw NSError(domain: "com.nMfpereira", code: 1, userInfo: [NSLocalizedDescriptionKey: "'users' not valid in JSON"])
        }
//        self.users = usersJsonArray.map({return User(json: $0)})
        
//        for userJson in usersJsonArray! {
//            let name = userJson["name"].stringValue
//            let username = userJson["username"].stringValue
//            let bioText = userJson["bio"].stringValue
//
//            let user = User(name: name, username: username, textBio: bioText, profileImage: UIImage())
//            print(user.username)
//            let user = User(json: userJson);
//            users.append(user)
//        }
        
//        var tweets = [Tweet]()
        guard let tweetsJsonArray = json["tweets"].array else {
            throw NSError(domain: "com.nMfpereira", code: 1, userInfo: [NSLocalizedDescriptionKey: "'tweets' not valid in JSON"])
        }
//        self.tweets = tweetsJsonArray.map({return Tweet(json: $0)})
        
//        for tweetJson in tweetsJsonArray! {
//            print(tweetJson)
//
//            let userJson = tweetJson["user"];
//            let name = userJson["name"].stringValue
//            let username = userJson["username"].stringValue
//            let bioText = userJson["bio"].stringValue
//
//            let user = User(name: name, username: username, textBio: bioText, profileImage: UIImage())
//
//            let user = User(json: userJson);
//
//            let message = tweetJson["message"].stringValue
//
//            let tweet = Tweet(user: user, message: message)
  
//            let tweet = Tweet(json: tweetJson)
//
//            tweets.append(tweet)
//        }
        
//        self.tweets = tweets
//        self.users = users;
        
        
        self.users = try usersJsonArray.decode()
        self.tweets = try tweetsJsonArray.decode()
    }
    
    
    
    
    //Tem que se implementar esse metodo que retorna o tipo de cabecalho que a collectionView vai ter
    override func footerClasses() -> [DatasourceCell.Type]? {
        return [UserFooter.self]
    }
    
    //Tem que se implementar esse metodo que retorna o tipo de cabecalho que a collectionView vai ter
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [UserHeader.self]
    }
    
    //Tem que se implementar esse metodo que retorna o tipo de celulas que a collectionView vai ter
    override func cellClasses() -> [DatasourceCell.Type] {
        return [UserCell.self, TweetCell.self];
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        if section == 1 {
            return tweets.count
        }
        return users.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == 1 {
            return tweets[indexPath.item]
        }
        
        return users[indexPath.item];
    }
}
