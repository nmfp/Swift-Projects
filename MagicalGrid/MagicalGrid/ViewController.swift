//
//  ViewController.swift
//  MagicalGrid
//
//  Created by Nuno Pereira on 15/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let numberOfRows = 15
    
    var cells = [String: UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let number = 40
        let width = view.frame.width / CGFloat(numberOfRows)
        
        for j in 0...number {
            for i in 0...numberOfRows {
                let v = UIView(frame: CGRect(x: CGFloat(i) * width, y: CGFloat(j) * width, width: width, height: width))
                v.backgroundColor = randomColor()
                v.layer.borderWidth = 0.5
                v.layer.borderColor = UIColor.black.cgColor
                v.addGestureRecognizer(UIPanGestureRecognizer(target: self, action:#selector(handlePan)))
                view.addSubview(v)
                //Guardar a posiçao da celula num dicionario
                let key = "\(i)|\(j)"
                cells[key] = v
            }
        }
        
        
    }
    
    var selectedCell: UIView?
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        print(location)
        
        //Saber a largura da celula para saber a posicao desta com base na location
        //e assim descobrir qual e do dicionario
        let width = view.frame.width / CGFloat(numberOfRows)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        let key = "\(i)|\(j)"
        guard let cellView = cells[key] else {return}
        
        
        if selectedCell != cellView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //Retorna a célula à sua escala inicial
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
        selectedCell = cellView
        
        //Põe à frente da view principal a view em questão neste caso da célula
        view.bringSubview(toFront: cellView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //Aumenta a escála do tamanho da célula
            cellView.layer.transform = CATransform3DMakeScale(3, 3, 3)
        }, completion: nil)
        
        //Se o gestio terminou coloca-se a célula no seu tamanho horiginal
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                //Retorna a célula à sua escala inicial
                cellView.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }


    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }


}

