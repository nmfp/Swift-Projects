//    //
////  Video.swift
////  Youtube
////
////  Created by Nuno Pereira on 01/11/2017.
////  Copyright © 2017 Nuno Pereira. All rights reserved.
////
//
import UIKit

class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        let uppercasedFirstCharacter = String(describing: key.first!).uppercased()

//        let range = key.startIndex...key.index(key.startIndex, offsetBy: 0);
//        let selectorString = key.replacingCharacters(in: range, with: uppercasedFirsrCharacter)

        let range = NSMakeRange(0, 1)
        let selectorString = NSString(string: key).replacingCharacters(in: range, with: uppercasedFirstCharacter)

        let selector = NSSelectorFromString("set\(selectorString):")
        let responds = self.responds(to: selector)

        //Se o objecto não responder ao selector, neste caso retorna-se sem afectar
        //nada evitando a aplicação de falhar se for acrescentado alguma coisa ao JSON
        if !responds {
            return
        }
        super.setValue(value, forKey: key)
    }
}

class Video: SafeJsonObject {
    @objc var thumbnail_image_name: String?
    @objc var title: String?
    @objc var number_of_views: NSNumber?
    @objc var uploadDate: Date?
    @objc var duration: NSNumber?

    @objc var channel: Channel?

    //Funcao que e chamada cada vez que e afectada uma chave de um dicionario
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel"{
            //custom channel setup
            self.channel = Channel()
            self.channel?.setValuesForKeys(value as! [String: AnyObject])
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    //Construcao de um construtor que recebe um dicionario e o transforma no objecto em questao neste caso atraves do metodo setValuesForKeys
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
}

class Channel: SafeJsonObject {
    @objc var profile_image_name: String?
    @objc var name: String?
}

