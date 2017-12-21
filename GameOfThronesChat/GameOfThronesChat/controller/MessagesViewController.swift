//
//  ViewController.swift
//  GameOfThronesChat
//
//  Created by Nuno Pereira on 09/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {

    var messages = [Message]()
    let cellId = "cellId"
    var messagesDictinary = [String:Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout));
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
        
//        observeMessages()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let message = self.messages[indexPath.row]
        
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child("users-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                
                //forma correcta de fazer e segura...
                self.messagesDictinary.removeValue(forKey: chatPartnerId);
                self.attemptToReloadTable()
                
                
                //uma forma de fazer mas nao a mais segura...
                //Nao se deve remover com o delete com o indexPAth porque a qualquer momento podem estar a entrar novas mensagens e nao e seguro apagar pois pode se estar a apagar com o indice errado
                self.messages.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                
                
            })
        }
        
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("users-messages").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in

            let userId = snapshot.key
            
            Database.database().reference().child("users-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        //A app esta a observer eventos de remocao das mensagens por fontes externas como por exemplo directamente do firebase
        ref.observe(.childRemoved, with: { (snapshot) in
            print(snapshot.key)
            print(self.messagesDictinary)
            self.messagesDictinary.removeValue(forKey: snapshot.key)
            self.attemptToReloadTable()
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messageRefence = Database.database().reference().child("messages").child(messageId)
        
        messageRefence.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let message = Message(dictionary: dictionary)
//                message.fromId = dictionary["fromId"] as? String
//                message.message = dictionary["message"] as? String
//                message.timestamp = dictionary["timestamp"] as? NSNumber
//                message.toId = dictionary["toId"] as? String
                //                self.messages.append(message)
                
                
                
                if let chatPartner = message.chatPartnerId() {
                    self.messagesDictinary[chatPartner] = message;
                    
                    
                }
                
                self.attemptToReloadTable()
            }
        }, withCancel: nil)
    }
    
    private func attemptToReloadTable(){
        //O timer criado a seguir para fazer reload a tabela e cancelado
        self.timer?.invalidate()
        //O timer criado a seguir para fazer reload a tabela
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
        print("TIMER")
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        
        self.messages = Array(self.messagesDictinary.values)
        
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp!.intValue > message2.timestamp!.intValue
        })
        
        DispatchQueue.main.async {
            print("Reloanding Table...")
            self.tableView.reloadData()
        }
    }
   
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
            fetchUserAndUpdateNavBar()
        }
    }
    
    func fetchUserAndUpdateNavBar () {
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = MyUser()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                //A propriedade key do objecto snapshot e o id unico de cada um dos nos filhos (cada user)
                user.id = snapshot.key;
                self.setUpNavBarUser(user: user)
            }
        }, withCancel: nil)
    }
    
    
    func setUpNavBarUser(user: MyUser) {
        messages.removeAll()
        messagesDictinary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        
        let titleView = UIView()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleView.backgroundColor = UIColor.red
        
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        
        containerView.addSubview(profileImageView)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let profileImageUrl = user.profileImageUrl {
            
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }

        
//
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let nameLabel = UILabel()
        nameLabel.text = user.name;
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        let button : UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(MessagesViewController.showChatController), for: UIControlEvents.touchUpInside)
            return button
        }()
        titleView.addSubview(button)
        button.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: titleView.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
        self.navigationItem.titleView = titleView;
        
    }
    
    @objc func showChatController(user: MyUser) {
        
        let chatController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user;
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginViewController();
        loginController.messagesController = self;
        present(loginController, animated: true, completion: nil);
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message;
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String;
                let user = MyUser()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                //A propriedade key do objecto snapshot e o id unico de cada um dos nos filhos (cada user)
                user.id = chatPartnerId;
                self.showChatController(user: user)
            }
        }, withCancel: nil)
        
    }
}


