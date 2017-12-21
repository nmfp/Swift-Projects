//
//  Extensions.swift
//  Youtube
//
//  Created by Nuno Pereira on 31/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1);
    }
}

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {

    //Cria-se esta variavel auxiliar que vai permitir comparar se os urls da imagem ainda sao os mesmos
    var imageUrlString: String?

    func loadingImageUsingUrlString(stringUrl: String) {
        let imageUrl = URL(string: stringUrl)

        //Afecta-se a variavel auxiliar para quando se for afectar a UI se comparar
        imageUrlString = stringUrl;

        //Iguala-se a nil de forma a nao aparecer nenhuma imagem  e fica em fundo branco a nao ser a correcta
        image = nil

        //valida se ja existe a imagem em cache e se sim mostra a imagem
        if let imageCached = imageCache.object(forKey: stringUrl as NSString) {
            self.image = imageCached
            return
        }

        URLSession.shared.dataTask(with: imageUrl!, completionHandler: { (data, response, error) in
            if error != nil {
                print("error fetching thumbnail image...", error)
                return
            }
            DispatchQueue.main.async( execute: {
                //Isto significa que nao existia a imagem em cache e por isso guarda-se a imagem em cache e mostra-se a mesma na main thread
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: stringUrl as NSString)

                //Compara-se se ainda se os urls sao os mesmos, ou seja, se se esta a ver a mesma imagem e se sim afecta-se a UI
                if self.imageUrlString == stringUrl {
                    self.image = imageToCache
                }
            })
        }).resume()
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


