//
//  FoodRepository.swift
//  Taster
//
//  Created by Nuno Pereira on 25/03/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation

class FoodRepository : RepositoryProtocol{
    var foods =  [Food]();
    
    
    //Cria-se uma instancia estatica pois só ira existir uma instancia em toda a aplicação (SingleTon) e assim é impedido de ser criada uma nova instancia além da primeira
    static let repository = FoodRepository();
    private init(){};
    
    
    var documentsPath : URL = URL(fileURLWithPath: "")
    var filePath : URL = URL(fileURLWithPath: "")
    
    
    private func getNextId() -> Int{
        if let lastId = self.foods.last?.id{
            return lastId + 1;
        }
        else{
            return 1;
        }
    }
    
    func createFoodWithName(name: String, local: String) -> Food {
        let id = getNextId();
        
        let f = Food(id: id, name: name, local: local);
        
        self.foods.append(f);
        
        return f;
    }
    
    func favoriteFood() -> [Food] {
        var fav = [Food]();
        
        for f in self.foods{
            if f.favourite{
                fav.append(f);
            }
        }
        return fav;
    }
    
    func foodByDate() -> [Food] {
        var orderedFood = foods;
        
        orderedFood.sort{(food1, food2) -> Bool in
            return food1.update_at.compare(food2.update_at) == .orderedDescending;
        }
        return orderedFood;
    }

    
    
    func foodSearch(search: String) -> [Food] {
        if search.characters.count == 0 {
            return foods;
        }
        
        var searchedFoods = [Food]();
        
        for f in foods {
            if (f.name?.contains(search))! || (f.foodDescription?.contains(search))! || (f.local?.contains(search))!{
                searchedFoods.append(f);
            }
        }
        return searchedFoods;
    }
    
    static func mediaPath() -> String {
        return ""
    }
    
    func saveFoods() {
        documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0]) as URL;
        filePath = documentsPath.appendingPathComponent("Food.data", isDirectory: false);
        
        let path = filePath.path;
        NSKeyedArchiver.archiveRootObject(foods, toFile: path);
    }
    
    func loadFoods() {
        documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) as URL;
        filePath = documentsPath.appendingPathComponent("Food.data", isDirectory: false);
        
        let path = filePath.path;
        if let newData = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [Food] {
            foods = newData;
        }
    }
}
