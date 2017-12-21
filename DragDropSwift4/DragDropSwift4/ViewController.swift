//
//  ViewController.swift
//  DragDropSwift4
//
//  Created by Nuno Pereira on 29/08/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDropInteractionDelegate, UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        //Saber o local onde se toca na tela
        let touchedPoint = session.location(in: view)
        //Ter acesso ao objecto tocado
        if let touchedImageView = self.view.hitTest(touchedPoint, with: nil) as? UIImageView {
            
            let touchedImage = touchedImageView.image
            //Este item Provider é a imagem ou objecto que se quer arrastar e para isso é necessário saber a sua localização
            let itemProvider = NSItemProvider(object: touchedImage!)
            
            let dragItem = UIDragItem(itemProvider: itemProvider)
            
            //Afectar a propriedade local Object vai ajudar no método previewForLifting a ter acesso a este mesmo objecto, que neste caso é acedido pelo parametro item do metodo em questao
            dragItem.localObject = touchedImageView
            
            return [dragItem]
        }
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        session.items.forEach { (dragItem) in
            if let touchedImage = dragItem.localObject as? UIView {
                touchedImage.removeFromSuperview()
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        self.view.addSubview(item.localObject as! UIView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Collage Sharing"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        //Informar que a view está apta a receber uma drop Interaction
        view.addInteraction(UIDropInteraction(delegate: self));
        
        //Informar que a view está apta a fazer uma drag Interaction
        view.addInteraction(UIDragInteraction(delegate: self));
    }
    
    @objc func handleShare() {
        
        //Passos para criar uma imagem da tela com todas as imagens arrastadas
        //1 criar um contexto grafico
        UIGraphicsBeginImageContext(view.frame.size)
        //2 fazer o render da view controller
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return}
        //Depois de criar um contexto para a imagem e importante terminar sempre o mesmo
        UIGraphicsEndImageContext()
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true, completion: nil)
    }
    
    //Metodo do delegate onde é definido se pode ou não ser feito o drop
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        //session.items  devolve um array de DragItems que correspondem aos objectos dropped
        for dragItam in session.items {
            //Ir buscar o item provider do objecto dropped, validar o seu tipo e definir o handler a ser executado quando for feito o drop
            dragItam.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {(obj, err) in
                if let error = err {
                    print("Failed to load drag item:", error);
                }
                guard let draggedImage = obj as? UIImage else {return};
         
                //Quando dá o erro da backgroud thread, é porque está a ser executado alguma coisa na background thread que devia estar a ser feito na main thread
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: draggedImage);
                    imageView.isUserInteractionEnabled = true
                    imageView.layer.borderWidth = 4
                    imageView.layer.borderColor = UIColor.black.cgColor
                    
                    //Criar uma sombra por traz da imagem em questao
                    imageView.layer.shadowRadius = 5
                    imageView.layer.shadowOpacity = 0.3
                    
                    self.view.addSubview(imageView);
                    imageView.frame = CGRect(x: 0, y: 0, width: draggedImage.size.width, height: draggedImage.size.height);
                    let centerPoint = session.location(in: self.view);
                    imageView.center = centerPoint;
                }
                
            })
        }
    }
    
    //Definir o UIDropProposal que vai ser feito no drop. Neste caso como é um drop de uma imagem do browser para a app é um copy e não um move
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy);
    }
    
    //Define se a view pode lidar com drag n drop de objectos deste tipo
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self);
    }
    
}

