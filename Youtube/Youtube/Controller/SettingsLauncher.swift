////
////  SettingsLauncher.swift
////  Youtube
////
////  Created by Nuno Pereira on 02/11/2017.
////  Copyright © 2017 Nuno Pereira. All rights reserved.
////
//
import UIKit

class Setting: NSObject {
    var name: SettingName
    var imageName: String

    init(name: SettingName , imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Settings = "Settings"
    case TermsPrivacy = "Terms & privacy policy"
    case SendFeedback = "Send Feedback"
    case Help = "Help"
    case SwichAccount = "Switch Account"
    case Cancel = "Cancel"
}



class SettingsLauncher: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource {

    var homeController: HomeController?

    override init() {
        super.init()

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        let setting = settings[indexPath.item]
        handleDismiss(setting: setting)


    }



    let cellId = "cellId"
    let cellHeight: CGFloat = 50

    var settings : [Setting] = {
        return[Setting(name: .Settings, imageName: "settings"),
               Setting(name: .TermsPrivacy, imageName: "privacy"),
               Setting(name: .SendFeedback, imageName: "feedback"),
               Setting(name: .Help, imageName: "help"),
               Setting(name: .SwichAccount, imageName: "switch_account"),
               Setting(name: .Cancel, imageName: "cancel")]
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()


    let blackView = UIView()

    func showMenu() {

        //1 passo - Escurecer o ecrã atrás
        //Não se pode adicionar à view em questão pois não vai cobrir o ecrã todo
        //Para isso tem que se adicionar ao objecto window para ocupar toda a tela
        if let window = UIApplication.shared.keyWindow {

            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            window.addSubview(blackView)


            window.addSubview(collectionView)

            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height

            //Para animar a collectionView a subir tem que se criar o inicio da frame como o fundo da tela, neste caso a altura toda da window - window.frame.height
            //E depois dentro da closure de animacao definir novamente a frame da collectionView para a posicao pretendida
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)

            ////////////////////////////////////////////////////////
            //uma forma de animacao

            //Para animar o escurecimento da tela
            //Uma vez que o alpha da blackView já é 1 vai ser alterado para zero para depois se voltar a colocar a 1 para ser essa a animação

//            blackView.alpha = 0;
//            UIView.animate(withDuration: 0.5, animations: {
//                blackView.alpha = 1
//
//                //Actualizar a frame da collectionView para a posicao final pretendida para ser animada
//                self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: self.collectionView.frame.height)
//            })

            //Para fazer o dismiss da view vai ser adicionado um gesto à mesma
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

            ////////////////////////////////////////////////
            //outra opcao de animacao
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1

                //Actualizar a frame da collectionView para a posicao final pretendida para ser animada
                self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)


        }

    }

    @objc func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            guard let window = UIApplication.shared.keyWindow else {return}

            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }) { (success) in

            //Valida/se a string vazia pois se for carregado na tela outro local fora da collectionView o metodo dismiss e chamado e mostrado um novo controller com um setting com a name vazio. O cancel e simplesmente para nao mostrar quando carregado cancel ser feito so o dismiss
//            print("CENAS: ", setting.name.rawValue)
            if setting.name != .Cancel{
                self.homeController?.showControllerForSetting(setting: setting)
            }
        }
    }

}

