//
//  LoginViewController.swift
//  GameOfThronesChat
//
//  Created by Nuno Pereira on 09/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var messagesController: MessagesViewController?
    
    var inputsContainerView : UIView = {
        let view = UIView();
        view.backgroundColor = UIColor.white;
        view.translatesAutoresizingMaskIntoConstraints = false; // necessario afectar para as views aparecerem uma vez que foram definidas constraints
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true; //necessario fazer senao o corner radius nao tem efeito
        return view;
    }()
    
    var loginRegisterButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16);
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return btn
    }()
    
    var nameTextField : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Name"
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt;
    }()
    
    var passwordTextField : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Password"
        //Faz com que o texto fique oculto
        txt.isSecureTextEntry = true
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt;
    }()
    
    var emailTextField : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email address"
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt;
    }()
    
    var separatorView : UIView = {
        let view = UIView();
        view.backgroundColor = UIColor.lightGray;
        view.translatesAutoresizingMaskIntoConstraints = false; // necessario afectar para as views aparecerem uma vez que foram definidas constraints
        return view;
    }()
    
    var emailSeparatorView : UIView = {
        let view = UIView();
        view.backgroundColor = UIColor.lightGray;
        view.translatesAutoresizingMaskIntoConstraints = false; // necessario afectar para as views aparecerem uma vez que foram definidas constraints
        return view;
    }()
    
    lazy var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "wolf");
        imageView.contentMode = .scaleAspectFit;
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView;
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        var sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false;
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleRegisterLoginChange), for: .valueChanged)
        return sc;
    }()
    

    @objc func handleRegisterLoginChange () {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputsContainerHeighAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150;
        
        nameTextFieldHeighAnchor?.isActive = false
        nameTextFieldHeighAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeighAnchor?.isActive = true
        
        emailTextFieldHeighAnchor?.isActive = false;
        emailTextFieldHeighAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeighAnchor?.isActive = true;
        
        passwordTextFieldHeighAnchor?.isActive = false;
        passwordTextFieldHeighAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeighAnchor?.isActive = true;
    }
    
    

    
    func handleLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if err != nil {
                print(err)
                return
            }
            
            self.messagesController?.fetchUserAndUpdateNavBar()
            
            //user logged in successfully
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleLoginRegister () {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else {
            handleRegister()
        }
    }
    
    var inputsContainerHeighAnchor: NSLayoutConstraint?
    var nameTextFieldHeighAnchor: NSLayoutConstraint?
    var emailTextFieldHeighAnchor: NSLayoutConstraint?
    var passwordTextFieldHeighAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        
        
        
        
        
        
        view.addSubview(inputsContainerView);
        view.addSubview(loginRegisterButton);
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(separatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)

        setUpInputsContainerView();
        setUpNameTxtField()
        setUpNameSeparatorView()
        setUpEmailTxtField()
        setUpEmailSeparatorView()
        setUpPasswordTxtField()
        handleLoginRegisterButton()
        handleProfileImageView()
        setupLoginRegisterSegmentedControl()
    }

    func setupLoginRegisterSegmentedControl(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    func handleProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor).isActive = true;
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    func handleLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true;
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
    }
    
    func setUpPasswordTxtField() {
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true;
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        passwordTextFieldHeighAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeighAnchor?.isActive = true;
    }
    func setUpNameSeparatorView() {
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        separatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true;
        separatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpEmailSeparatorView() {
        emailSeparatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true;
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpEmailTxtField() {
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        emailTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        emailTextFieldHeighAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            emailTextFieldHeighAnchor?.isActive = true;
    }
    
    func setUpNameTxtField() {
        //Define a constreaint do eixo do XX's no centro de ecrã
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        //Define a constreaint do eixo dos YY's como o topo da superview onde este foi adicicionada neste caso a inputsContainerView
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true;
        //Define a constreaint da largura como o da superview
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        //Define a constreaint da altura que neste caso será um terço da altura da superview
        nameTextFieldHeighAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeighAnchor?.isActive = true;
    }
    
    func setUpInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        //A constante é -24 porque retira 12 pixeis de cada lado
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true;
        inputsContainerHeighAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150);
        inputsContainerHeighAnchor?.isActive = true
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        UIApplication.shared.statusBarStyle = .lightContent;
//    }
//
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .lightContent;
//    }

}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1);
    }
}
