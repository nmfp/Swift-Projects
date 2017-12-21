//
//  ViewController.swift
//  CircularAnimation
//
//  Created by Nuno Pereira on 21/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        label.textAlignment = .center
        label.text = "Start"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
 
    var shapeLayer: CAShapeLayer?
    var pulsatingLayer: CAShapeLayer?
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func handleEnterForeground() {
        animatePulsatingLayer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        
        //como as animacoes tem um bug em que quando a aplicacao e posta em background e em seguida em foreground a animacao deixa de funcionar
        //coloca-se um observer a escuta de quando a aplicacao entra em foreground e em seguida da inicio a animacao novamente
        setupNotificationObservers()
        
        ////////Pulsating Layer/////////
        pulsatingLayer = createMyCircularLayer(strokeColor: UIColor.clear, fillColor: UIColor.pulsatingFillColor)
        guard let pulsatingLayer = pulsatingLayer else {return}
        view.layer.addSublayer(pulsatingLayer)
        
         animatePulsatingLayer()
        ////////////////////////////////
        
        let trackLayer = createMyCircularLayer(strokeColor: UIColor.trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createMyCircularLayer(strokeColor: UIColor.outlineStrokeColor, fillColor: .clear)

        guard let shapeLayer = self.shapeLayer else {return}
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        //ao definir esta propriedade a zero faz com que a linha desapareca do ecra para se poder fazer a animacao
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addSubview(percentageLabel)
        percentageLabel.center = view.center
    }
    
    func animatePulsatingLayer() {
        //A key que define que a animacao consiste numa alteracao da escala
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        //Tipo de timming da animacao, neste caso, rapido no inicio e lento no fim
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        //Define que a animacao tambem acontece no sentido inverso
        animation.autoreverses = true
        //Define que a animacao ocorre infinitamente
        animation.repeatCount = Float.infinity
        
        pulsatingLayer?.add(animation, forKey: "pulsing")
    }

    let urlString = "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_5mb.mp4"
    
    func beginDownloadingFile() {
        guard let shapeLayer = self.shapeLayer else {return}
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
        guard let shapeLayer = self.shapeLayer else {return}
        shapeLayer.add(basicAnimation, forKey: "cenasAnimadas")
    }
    
    @objc func handleTap() {
        beginDownloadingFile()
//        animateCircle()
    }

    func createMyCircularLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer{
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        //Criar uma linha da parte externa do circulo com cor vermelha e 10px
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        //Alterar a cor do centro do circulo, ou seja, a parte interior da Stroke
        layer.fillColor = fillColor.cgColor
        //Definir o aspecto das terminacoes da linha a desenhar. Por defeito as terminacoes sao rectangular, neste caso sao postas circulares
        layer.lineCap = kCALineCapRound
        //Definir a posicao no centro do ecra
        layer.position = view.center
        return layer
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let shapeLayer = shapeLayer else {return}
        //percentagem do progresso ja feito
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        //actualizar a linha da animacao consoante a percentagem
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            shapeLayer.strokeEnd = percentage
        }
    }
}

