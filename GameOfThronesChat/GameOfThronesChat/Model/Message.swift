//
//  Message.swift
//  GameOfThronesChat
//
//  Created by Nuno Pereira on 14/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var toId: String?
    var fromId: String?
    var message: String?
    var timestamp: NSNumber?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var videoUrl: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    init(dictionary: [String: AnyObject]) {
        fromId = dictionary["fromId"] as? String
        message = dictionary["message"] as? String
        toId = dictionary["toId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
    }
}
