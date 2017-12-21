//
//  ViewController.swift
//  DecodeSwift4
//
//  Created by Nuno Pereira on 14/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    struct Episode: Decodable {
//        var links: String?
//        var airdate: String?
//        var airstamp: String?
//        var airtime: String?
//        var id: Int?
//        var image: String?
//        var name: String?
//        var number: String?
//        var runtime: Int?
//        var season: Int?
//        var summary: String?
//        var url: String?
//    }
    
    
    //o endpoint tem 3 objectos mas um deles faltam campos
    //Para o Decodable funcionar sem os campos todos e necessario
    //a struct ter os seus campos como opcionais
    struct Course: Decodable {
        var id: Int?
        var name: String?
        var link: String?
        var imageUrl: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses_missing_fields"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if err != nil {
                return
            }
            guard let data = data else { return}
            do {
                //uma vez que o endpoint retorna um array de objectos Course
                //e necessario especificar [Course].self senao seria Course.self
                let json = try JSONDecoder().decode([Course].self, from: data)
                print(json)
                
            }
            catch let jsonErr {
                print("error parsing json: ", jsonErr.localizedDescription)
            }
            
        }.resume()
        
    }



}

