//
//  HomeDatasourceController.swift
//  Twitter
//
//  Created by Nuno Pereira on 23/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import LBTAComponents
import TRON
import SwiftyJSON

class HomeDatasourceController: DatasourceController {

    
    var errorMessageLabel: UILabel = {
        let label = UILabel();
        label.text = "Apologies, something went wrong. Please try again later..."
        label.textAlignment = .center
        label.numberOfLines = 0;
        label.isHidden = true
        return label;
    }()
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(errorMessageLabel)
        //LBTA method
        //Faz com que o elemento esteja ancorado ao topo, aos lados e ao fundo da vista.
        errorMessageLabel.fillSuperview()
        
        collectionView?.backgroundColor = UIColor(r: 232, g: 236, b: 241)
        
        setupNavigationBarItems()
        
//        let homeDatasource = HomeDatasource()
//        self.datasource = homeDatasource
//        fetchHomeFeed()
        Service.sharedInstance.fetchHomeFeed { homeDatasource, error in
            if let error = error {
                self.errorMessageLabel.isHidden = false

                if let error = error as? APIError<Service.JSONError> {
                    print(error.response?.statusCode)
                    self.errorMessageLabel.text = "Status code was not 200"
                }
                print("HomeDatasourceController error fetching json: ", error)
                return
            }
            print("print in closure")
            self.datasource = homeDatasource
        }
    }
    
    
//    class Home: JSONDecodable {
//        let users: [User]
//
//        required init(json: JSON) throws {
//            var users = [User]()
//            let array = json["users"].array
//            
//            for userJson in array! {
//                let name = userJson["name"].stringValue
//                let username = userJson["username"].stringValue
//                let bioText = userJson["bio"].stringValue
//                
//                let user = User(name: name, username: username, textBio: bioText, profileImage: UIImage())
//                print(user.username)
//                users.append(user)
//            }
//            self.users = users;
//        }
//    }
    
//    class JSONError: JSONDecodable {
//        required init(json: JSON) throws {
//            print("JSON ERROR")
//        }
//    }
    
//    let tron = TRON(baseURL: "https://api.letsbuildthatapp.com")
//
//    private func fetchHomeFeed() {
//        //start our fetch here
//
//        let request: APIRequest<HomeDatasource, JSONError> = tron.request("/twitter/home")
//
//        request.perform(withSuccess: { (homeDatasource) in
//            print("successfully fetched our json objects")
//            print(homeDatasource.users.count)
//            self.datasource = homeDatasource
//        }) { (err) in
//            print("failed to fecth json...", err)
//        }
//    }
    
    
    //metodo que define o minimo espaco entre as celulas
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0{
            guard let user = datasource?.item(indexPath) as? User else {return .zero}
            
            //            user?.textBio
            //let's get an estimation of the height of the cell based on textBio
            
            //as subtracoes sao das margens e da foto de perfil / o ultimo 12 era 8 mas alterou se porque tinha que ser um valor maior devido as textviews terem um padding dentro do proprio componente
            //e adicionou-se o -2 porque ao diminuir a largura vai fazer com que aumente a altura preenchendo assim mais algum espaco em branco
//            let aproximatedWithTextBio = view.frame.width - 12 - 50 - 12 - 2
//
//            let size = CGSize(width: aproximatedWithTextBio, height: 1000) // a altura tem que ser um valor muito alto
//
//            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
//
//            let estimatedFrame = NSString(string: user.textBio).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
//
//            return CGSize(width: view.frame.width, height: estimatedFrame.height + 66) // o valor 52 passou a ser 66 pois tem que ser um valor maior devido as textviews terem um padding dentro do proprio componente. Era 52 porque e o sumatorio das alturas e dos paddings do nameLabel, userLabel e paddings = 20 + 20 + 12
                
            let estimatedHeight = estimatedHeighForText(user.textBio)
            return CGSize(width: view.frame.width, height: estimatedHeight + 66)
            
            
        }
        else if indexPath.section == 1 {
            //our tweets size estimation
            
            guard let tweet = datasource?.item(indexPath) as? Tweet else {return .zero}
            
            let estimatedHeight = estimatedHeighForText(tweet.message)
            
            return CGSize(width: view.frame.width, height: estimatedHeight + 74)
        }
        
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    private func estimatedHeighForText (_ text: String) -> CGFloat {
        let aproximatedWithTextBio = view.frame.width - 12 - 50 - 12 - 2
        
        let size = CGSize(width: aproximatedWithTextBio, height: 1000) // a altura tem que ser um valor muito alto
        
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimatedFrame.height
    }
    
    
    //Tem que se definir sempre a dimensao do cabecalho para aparecer no ecra
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return .zero
        }
        return CGSize(width: view.frame.width, height: 50)
    }
    
    //Tem que se definir sempre a dimensao do rodape para aparecer no ecra
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
//            return CGSize(width: view.frame.width, height: 50)
            return .zero
        }
//        return CGSize(width: view.frame.width, height: 50)
        //Acrescenta-se 14 pixeis para se dar a sensacao de que as seccoes estao separadas por uma linha azul alta
        //Vai-se alterar na constraint para o texto aparecer 14 pixeis acima na constante da bottomAnchor para centrar
        //Depois acrescentar uma view com background branco que tem a altura do footer menos os 14 pixeis
        return CGSize(width: view.frame.width, height: 64)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}



