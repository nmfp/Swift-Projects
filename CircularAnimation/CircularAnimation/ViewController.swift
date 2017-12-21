//
//  ViewController.swift
//  CircularAnimation
//
//  Created by Nuno Pereira on 21/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        //percentagem do progresso ja feito
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        //actualizar a linha da animacao consoante a percentagem
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        label.textAlignment = .center
        label.text = "Start"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
 
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(percentageLabel)
        percentageLabel.center = view.center
   
        //Secondary method with some repeated code just for better understanding
        createMyTrackLayer()

//        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true);
        shapeLayer.path = circularPath.cgPath
        
        //Definir a posicao no centro do ecra
        shapeLayer.position = view.center
        
        //Criar uma linha da parte externa do circulo com cor vermelha e 10px
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        
        //Alterar a cor do centro do circulo, ou seja, a parte interior da Stroke
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        //Definir o aspecto das terminacoes da linha a desenhar. Por defeito as terminacoes sao rectangular, neste caso sao postas circulares
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        //ao definir esta propriedade a zero faz com que a linha desapareca do ecra para se poder fazer a animacao
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

//    let urlString = "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_5mb.mp4"
    let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    
    func beginDownloadingFile() {
        
        shapeLayer.strokeEnd = 0
        //Configuracao default para urlSession
        let configuration = URLSessionConfiguration.default
        //Criacao da queue onde a task vai executar
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else {return}
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    fileprivate func animateCircle() {
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
    
    @objc func handleTap() {
        
        beginDownloadingFile()
        
//        animateCircle()
    }

    func createMyTrackLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor(red: 160/255, green: 101/255, blue: 133/255, alpha: 1).cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.path = circularPath.cgPath
        //Definir a posicao no centro do ecra
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
    }
}

