//
//  ViewController.swift
//  FirstApp
//
//  Created by Hebert Fronza on 14/12/16.
//  Copyright © 2016 Hebert Fronza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //COMPONENTES PRINCIPAIS
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnTip1: UIButton!
    @IBOutlet weak var btnTip2: UIButton!
    @IBOutlet weak var btnTip3: UIButton!
    @IBOutlet weak var btnTip4: UIButton!
    @IBOutlet weak var btnTip5: UIButton!
    @IBOutlet weak var lblTitulo: UILabel!
    
    //VIEW TIP E SEUS COMPONENTES
    @IBOutlet weak var viewTip: UIView!
    @IBOutlet weak var btnVoltar: UIButton!
    @IBOutlet weak var lblTip: UILabel!
    
    var allTips : [Tip]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TIPS
        let tip0 = Tip(titulo: "Como limpar mancha de gordura?", descricao: "Basta cobrir a mancha com giz e depois de alguns minutos, limpe o giz com uma toalha úmida.")
        let tip1 = Tip(titulo: "Como secar rápido seus tenis?", descricao: "Basta colocar folhas de jornais ou daqueles anúncios que jogam na sua casa. Seu sapato vai secar rapidamente.")
        let tip2 = Tip(titulo: "Como remover manchas do carpete?", descricao: "Encha uma garrafa spray com água e vinagre. Pulverize o local e, em seguida, coloque um pano úmido sobre ele. Passe um ferro à vapor quente sobre o pano por cerca de 1 minuto.")
        let tip3 = Tip(titulo: "Como Limpar uma lava-louça?", descricao: "Basta deixar uma tigela cheia de vinagre branco na prateleira superior e executá-lo o ciclo mais quente possível da máquina.")
        let tip4 = Tip(titulo: "Como desentupir a pia?", descricao: "Basta você jogar 4 comprimidos daqueles que se dissolvem em água e 1 xícara de vinagre em água fervente e jogar na pia e você terá seu problema resolvido.")
       
        allTips = [tip0, tip1, tip2, tip3, tip4]
        tipsCria()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTip1Action(_ sender: Any) {
        desabilitaBotoes()
        lblTip.text = allTips[0].tipDescricao
        
    }

    @IBAction func btnTip2Action(_ sender: Any) {
        desabilitaBotoes()
        lblTip.text = allTips[1].tipDescricao
        
    }
   
    @IBAction func btnTip3Action(_ sender: Any) {
        desabilitaBotoes()
        lblTip.text = allTips[2].tipDescricao
        
    }
    
    @IBAction func btnTip4Action(_ sender: Any) {
        desabilitaBotoes()
        lblTip.text = allTips[3].tipDescricao
        
    }
    
    @IBAction func btnTip5Action(_ sender: Any) {
        desabilitaBotoes()
        lblTip.text = allTips[4].tipDescricao
        
    }
    
    @IBAction func btnVoltarAction(_ sender: Any) {
        viewTip.isHidden = true
        btnTip1.isEnabled = true
        btnTip2.isEnabled = true
        btnTip3.isEnabled = true
        btnTip4.isEnabled = true
        btnTip5.isEnabled = true
    }
   
    func desabilitaBotoes (){
        //Desabilita todos os botões para que não possa clicar 2 vezes
        btnTip1.isEnabled = false
        btnTip2.isEnabled = false
        btnTip3.isEnabled = false
        btnTip4.isEnabled = false
        btnTip5.isEnabled = false
        
        viewTip.isHidden = false //Mostra a view de Tip
    }

    func tipsCria (){
        //Criar os botoes com as TIPS
        btnTip1.setTitle(allTips[0].tipTitulo, for: UIControlState.normal)
        btnTip2.setTitle(allTips[1].tipTitulo, for: UIControlState.normal)
        btnTip3.setTitle(allTips[2].tipTitulo, for: UIControlState.normal)
        btnTip4.setTitle(allTips[3].tipTitulo, for: UIControlState.normal)
        btnTip5.setTitle(allTips[4].tipTitulo, for: UIControlState.normal)
    }
    
}

