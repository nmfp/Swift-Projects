//
//  TipModel.swift
//  FirstApp
//
//  Created by Hebert Fronza on 14/12/16.
//  Copyright © 2016 Hebert Fronza. All rights reserved.
//

import Foundation
import UIKit

class Tip {
    var tipTitulo : String!
    var tipDescricao : String!
    
    init (titulo : String, descricao: String){
        self.tipTitulo = titulo
        self.tipDescricao = descricao
    }
}

extension Array
{
        /** Randomizes the order of an array's elements. */
        mutating func shuffle()
        {
            for _ in 0..<10
            {
                sort { (_,_) in arc4random() < arc4random() }
            }
        }
}
