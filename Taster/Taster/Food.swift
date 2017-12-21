//
//  Food.swift
//  Taster
//
//  Created by Nuno Pereira on 25/03/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation


class Food: NSObject, NSCoding {
    
    var id = 0
    var name: String?
    var ingredients : [String]?
    var local : String?
    var foodDescription:String?
    var mediaFile:String?
    var rating:Int?
    var favourite = false;
    var update_at = Date();
    var latitude = Double();
    var longitude = Double();
    
    init(id: Int, name: String, local:String) {
        self.id = id;
        self.name = name;
        self.local = local;
    }
    
    
    var numberIngredients :Int {
        if let ing = ingredients{
            return ing.count;
        }
        else {
            return 0;
        }
    }
    
    
    func fullIngredients () -> String {
        if let ing = ingredients {
            return ing.joined(separator: " ");
        }
        else{
            return ""
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id");
        aCoder.encode(name, forKey: "name");
        aCoder.encode(local, forKey: "local");
        aCoder.encode(foodDescription, forKey: "foodDescription");
        aCoder.encode(ingredients, forKey: "ing");
        aCoder.encode(mediaFile, forKey: "media");
        aCoder.encode(rating, forKey: "rating");
        aCoder.encode(favourite, forKey: "fav");
        aCoder.encode(update_at, forKey: "date");
        aCoder.encode(latitude, forKey: "lat");
        aCoder.encode(longitude, forKey: "long");
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id");
        name = aDecoder.decodeObject(forKey: "name") as? String;
        local = aDecoder.decodeObject(forKey: "local") as? String;
        foodDescription = aDecoder.decodeObject(forKey: "foodDescription") as? String;
        ingredients = aDecoder.decodeObject(forKey: "ing") as? [String];
        mediaFile = aDecoder.decodeObject(forKey:  "media") as? String;
        rating = aDecoder.decodeObject(forKey: "rating") as? Int;
        favourite = aDecoder.decodeBool(forKey: "fav");
        update_at = aDecoder.decodeObject(forKey: "date") as! Date;
        
        latitude = aDecoder.decodeDouble(forKey: "lat");
        longitude = aDecoder.decodeDouble(forKey: "long");
    }
}
