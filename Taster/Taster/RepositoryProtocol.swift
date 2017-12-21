//
//  RepositoryProtocol.swift
//  Taster
//
//  Created by Nuno Pereira on 25/03/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation

protocol RepositoryProtocol {
    
    func createFoodWithName ( name: String, local:String) -> Food
    func favoriteFood() -> [Food]
    func foodByDate () -> [Food]
    func foodSearch (search :String) -> [Food]
    
    static func mediaPath() -> String
    
    func saveFoods();
    func loadFoods();
}
