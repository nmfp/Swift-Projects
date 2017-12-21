////
////  VideoLaucher.swift
////  Youtube
////
////  Created by Nuno Pereira on 06/11/2017.
////  Copyright © 2017 Nuno Pereira. All rights reserved.
////
//
import UIKit
import AVFoundation

class VideoPlayerView: UIView {


    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
       aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()

    //View que vai ter todos os controls do video
    let controlsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()

    let pausePlayButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //Faz o mesmo que o rendering - .withRenderingMode(.alwaysOriginal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        //Por defeito o botao aparece escondido pois so faz sentido ser visivel quando o video esta a dar
        button.isHidden = true
        return button
    }()


    //variavel auxiliar que indica no inicio que o video nao esta a correr
    var isPlaying = false

    @objc func handlePause() {
        print("pausing player...")
        //como o player e criado dentro do metodo setupPlayerView nao existe referencia
        //para este fora desse metodo. Para isso e necessario criar uma referencia para este
        //fora do metodo
//        player?.pause()

        let imageName = isPlaying ? "play" : "pause"

        pausePlayButton.setImage(UIImage(named: imageName), for: .normal)

        if isPlaying {
            player?.pause();
        }
        else {
            player?.play()
        }

        isPlaying = !isPlaying
    }


    var player: AVPlayer?

    func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"

        if let url =  URL(string: urlString) {
            player = AVPlayer(url: url)

            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame

            player?.play()

            //Tem que se adicionar um observer para saber quando o video esta pronto a comecar
            //quando se adiciona um observar e necessario fazer override ao metodo observeValue(forKeyPath keyPath
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)


            //Track player progress
            let interval = CMTime(value: 1, timescale: 2);
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in

                let seconds = CMTimeGetSeconds(progressTime)
//                print("PROGRESS: ", seconds)

                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds) / 60)

                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"

                //let's move the slider thumb
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration);
                    self.videoSlider.value = Float(seconds / durationSeconds);
                }
            })
        }
    }

    let videoLengthLabel: UILabel = {
       let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textAlignment = .right
        return label
    }()

    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.maximumTrackTintColor = .white
        slider.translatesAutoresizingMaskIntoConstraints = false;

        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()

    @objc func handleSliderChange() {
        print("Slider Value: ", videoSlider.value)

        //Como calcular o value??

        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)

            let value = Float64(videoSlider.value) * totalSeconds
            //CMTime no parametro value recebe um Int64, e o CMTimeValue e um typealias para Int64
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)

            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //perhaps do something later here
            })
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //Quando for true significa que o video esta pronto e pode-se parar a animacao do spinner
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()

            controlsContainerView.backgroundColor = .clear

            pausePlayButton.isHidden = false
            isPlaying = true


            //Saber a duracao do video
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)

                let secondsText = Int(seconds) % 60
                //Forma de os minutos serem 2 zeros quando os minutos = zero
                let minutesText = String(format: "%02d", Int(seconds) / 60)

                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)

        setupGradientLayer()

        //Uma vez que a controlsContainerView vai ter os controls do video vai ter que
        //aparecer por cima da view do player por isso a controlsContainerView tem que
        //ser adicionado em ultimo

        setupPlayerView()

        controlsContainerView.frame = frame
        addSubview(controlsContainerView)

        backgroundColor = .black

        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true


        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor,  constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true


        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true


    }

    func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()

        //Frame especifica onde comeca e termina a gradientLayer
        //bounds especifica as margens da view
        gradientLayer.frame = bounds

        //Definir a ordem das cores do gradient
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

        //É necessário definir a localização do gradient para aparecer
        //O valor zero começa no topo da view em causa
        //O valor 1 é o fim da view em causa, neste caso 1.2 já é para
        //além da view não ficando assim o fim da view completamente preto
        gradientLayer.locations = [0.7, 1.2]

        controlsContainerView.layer.addSublayer(gradientLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {

    func showVideoPlayer() {
        print("Showing video player animation...")

        //Adicionar a view que vai representar o video ao ecra
        //Como esta class extende de NSObject nao ha acesso a nenhum objecto do UIkit (views por exemplo)
        //Acede-se a keywindow

        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white

            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.width - 10, width: 10, height: 10 )

            //aspect ratio 16:9
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)

            keyWindow.addSubview(view)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                //maybe do something here later

                UIApplication.shared.setStatusBarHidden(true, with: .fade)


            })
        }

    }

}


