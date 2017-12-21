//
//  ViewController.swift
//  CircularAnimation
//
//  Created by Nuno Pereira on 21/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        //Secondary method with some repeated code just for better understanding
        createMyTrackLayer()
        
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        //Criar uma linha da parte externa do circulo com cor vermelha e 10px
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        
        //Alterar a cor do centro do circulo, ou seja, a parte interior da Stroke
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        //Definir o aspecto das terminacoes da linha a desenhar. Por defeito as terminacoes sao rectangular, neste caso sao postas circulares
        shapeLayer.lineCap = kCALineCapRound
        
        //ao definir esta propriedade a zero faz com que a linha desapareca do ecra para se poder fazer a animacao
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc func handleTap() {
        
        //A key que e passada e o nome da propriedade definida acima pois vai ser utilizada a linha externa do circulo
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        //Definir o fim da animacao
        basicAnimation.toValue = 1
        
        //Definir a duracao da animacao
        basicAnimation.duration = 2
        
        //Forcar a animacao nao ser removida e a linha permanecer completa no estado final
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        //Adicionar a animacao à target layer
        shapeLayer.add(basicAnimation, forKey: "cenasAnimadas")
    }

    func createMyTrackLayer() {
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor(red: 160/255, green: 101/255, blue: 133/255, alpha: 1).cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.path = circularPath.cgPath
        view.layer.addSublayer(trackLayer)
    }
}

