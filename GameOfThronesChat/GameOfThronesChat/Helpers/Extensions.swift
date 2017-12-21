//
//  Extensions.swift
//  GameOfThronesChat
//
//  Created by Nuno Pereira on 13/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>();

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString : String) {
        
        //Fazer reset à imagem
        self.image = nil;
        
        //Valida se a imagem ja foi descarregada e se sim devolve a mesma
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage;
            return;
        }
        
        //Faz download se a imagem não estiver em cache
        let profileImageUrl = URL(string: urlString);
        URLSession.shared.dataTask(with: profileImageUrl!, completionHandler: { (data, res, err) in
            if err != nil {
                print(err);
                return;
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject);
                    self.image = downloadedImage;
                }
            }
        }).resume();
    }
}
