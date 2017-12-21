//
//  CoreDataRepository.swift
//  Taster
//
//  Created by Nuno Pereira on 06/05/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class CoreDataRepository: RepositoryProtocol {
    
    var foods = [Food]()
    let context : NSManagedObjectContext;
    
    init(mContext:NSManagedObjectContext) {
        context = mContext;
    }
    
    func createFoodWithName(name: String, local: String) -> Food {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Food", in: context);
        let f  = Food(entity: entityDescription!, insertInto: context);
        f.name = name;
        f.local = local;
        return f;
    }
    
    func favoriteFood() -> [Food] {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Food", in: context);
        let request = NSFetchRequest<Food>();
        request.entity = entityDescription;
        
        var favFoods = [Food]();
        
        let pred = NSPredicate(format: "(favourite = 1)");
        request.predicate = pred;
        
        do{
            let foods = try context.fetch(request)
            for f in foods{
                favFoods.append(f)
            }
        }
    }
    
    func foodByDate() -> [Food] {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Food", in: context);
        
        let request = NSFetchRequest<Food>();
        request.entity = entityDescription
        
        let dateSort = NSSortDescriptor(key: "update_at", ascending: false);
        request.sortDescriptors = [dateSort];
        var dateFoods = [Food]();
        
        do{
            let foods = try context.fetch(request)
            for f in foods{
                dateFoods.append(f);
            }
        }
        catch{
            
        }
        return dateFoods;
    }
    
    func saveFoods() {
        do {
            try context.save()
        }
        catch{}
    }
    
    
}
