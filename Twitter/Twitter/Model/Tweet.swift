//
//  Tweet.swift
//  Twitter
//
//  Created by Nuno Pereira on 26/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct Tweet: JSONDecodable {
    let user: User;
    let message: String;
    
    init(json: JSON) {
        let userJson = json["user"]
        self.user = User(json: userJson)
        self.message = json["message"].stringValue
    }
}
