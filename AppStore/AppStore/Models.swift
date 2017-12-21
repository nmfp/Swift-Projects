//
//  Models.swift
//  AppStore
//
//  Created by Nuno Pereira on 10/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class FeaturedApps: NSObject {
    @objc var bannerCategory: AppCategory?
    @objc var appCategories: [AppCategory]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "categories"{
            appCategories = [AppCategory]()
            for dictionary in value as! [[String: AnyObject]] {
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dictionary)
                appCategories? .append(appCategory)
            }
        }
        else if key == "bannerCategory"{
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}

class AppCategory: NSObject {
    @objc var name: String?
    @objc var apps: [App]?
    @objc var type: String?
    
//    static func fetchAppCategories(completion: @escaping ([AppCategory]) -> ()) {
    static func fetchAppCategories(completion: @escaping (FeaturedApps) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            let featuredApps = FeaturedApps()
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String:AnyObject] {
                   
                    
                    featuredApps.setValuesForKeys(jsonDictionaries)// as! [String: AnyObject])
                    
                    
//                    for dictionary in jsonDictionaries["categories"] as! [[String: AnyObject]] {
//                        let appCategory = AppCategory()
//                        appCategory.setValuesForKeys(dictionary)
//                        appCategories.append(appCategory)
//                    }
                }
                DispatchQueue.main.async {
//                    completion(appCategories)
                    completion(featuredApps)
                    
                }
            }
            catch let err {
                print(err)
            }
            }.resume()
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps"{
            var apps = [App]()
            for dictionary in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeys(dictionary)
                apps.append(app)
            }
            super.setValue(apps, forKey: key)
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}

class App: NSObject {
    @objc var id: NSNumber?
    @objc var name: String?
    @objc var category: String?
    @objc var imageName: String?
    @objc var price: NSNumber?
    
    @objc var Screenshots: [String]?
    @objc var appInformation: [[String:String]]?
    //a variavel com o nome description e um caso especial para os objectos que derivam NSObject
    //Para isso tem que ter outro nome e fazer override ao setValue
//    @objc var description: String?
    @objc var desc: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description" {
            self.desc = value as? String
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}
