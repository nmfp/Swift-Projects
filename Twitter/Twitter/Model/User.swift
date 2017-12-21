//
//  User.swift
//  Twitter
//
//  Created by Nuno Pereira on 24/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import SwiftyJSON
import TRON

struct User: JSONDecodable {
    let name: String
    let username: String
    let textBio: String
    let profileImageUrl: String
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.username = json["username"].stringValue
        self.textBio = json["bio"].stringValue
        self.profileImageUrl = json["profileImageUrl"].stringValue 
    }
}
