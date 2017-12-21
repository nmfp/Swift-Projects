//
//  Service.swift
//  Twitter
//
//  Created by Nuno Pereira on 28/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct Service {
    let tron = TRON(baseURL: "https://api.letsbuildthatapp.com")
    
    static let sharedInstance = Service()
    
    func fetchHomeFeed(completion: @escaping (HomeDatasource?, Error?) -> ()) {
        let request: APIRequest<HomeDatasource, JSONError> = tron.request("/twitter/home")
        
        request.perform(withSuccess: { (homeDatasource) in
            print("successfully fetched our json objects")
            print(homeDatasource.users.count)
//            self.datasource = homeDatasource
            
            completion(homeDatasource, nil)
        }) { (err) in
            print("failed to fecth json...", err)
            completion(nil, err)
        }
    }
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("JSON ERROR")
        }
    }
}


