//
//  ChatLogController.swift
//  GameOfThronesChat
//
//  Created by Nuno Pereira on 14/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cellId = "cellId"
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    var user: MyUser? {
        didSet {
            navigationItem.title = user!.name;
            
            observeUserMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeUserMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {return}
        let userMessagesRef = Database.database().reference().child("users-messages").child(uid).child(toId)

        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String : AnyObject]{
                    let message = Message(dictionary: dictionary)
//                    message.fromId = dictionary["fromId"] as? String
//                    message.message = dictionary["message"] as? String
//                    message.toId = dictionary["toId"] as? String
//                    message.timestamp = dictionary["timestamp"] as? NSNumber
//                    message.imageUrl = dictionary["imageUrl"] as? String
//                    message.imageWidth = dictionary["imageWidth"] as? CGFloat
//                    message.imageHeight = dictionary["imageHeight"] as? CGFloat
                    
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0);
                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //coloca uma margem de 8 pixeis em cima na collectionView
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.keyboardDismissMode = .interactive
        
//        setupInputComponents()
//
        setUpKeyboardObservers()
    }
    
    lazy var inputContainerView: ChatInputContainerView = {
        
        
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50));
        chatInputContainerView.chatLogController = self;
        return chatInputContainerView
        
//        let containerView = UIView()
//        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//        containerView.backgroundColor = UIColor.white
        
        
        
        
//        return containerView
    }()
    
    @objc func handleUploadTap() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        present(picker, animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    func setUpKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0);
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
        
            if let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            
                //Elevar a constraint para o topo da frame do teclado
                containerViewBottomAnchor?.constant = -keyboardFrame.height
                UIView.animate(withDuration: keyboardDuration, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
    
        if let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            
            //Voltar a por a frame no fundo da tela
            containerViewBottomAnchor?.constant = 0
            UIView.animate(withDuration: keyboardDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
//    func setupInputComponents() {
//
//        
//        let containerView = UIView();
//        containerView.backgroundColor = UIColor.white
//        containerView.translatesAutoresizingMaskIntoConstraints = false;
//        
////        containerView.backgroundColor = UIColor.red
//        view.addSubview(containerView)
//        
//        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        
//        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        containerViewBottomAnchor?.isActive = true
//        
//        
//        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        containerView.addSubview(sendButton)
//        
//        
//        
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        
//        
//        
//        containerView.addSubview(inputTextField)
//        
//        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
//        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        
//        let separatorLineView = UIView()
//        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
//        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
//        containerView.addSubview(separatorLineView)
//        
//        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        separatorLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        
//    }
    

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
       
        //PRO TIP: dont put lots of logic on a view class
        cell.chatLogContoller = self;
        
        
        
        
        let message = messages[indexPath.item]
        cell.message = message
        
        
        cell.textView.text = message.message
        
        setUpCell(cell: cell, message: message)
        
        if let text = message.message {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(string: text).width + 32
            cell.textView.isHidden = false
        }
        else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        cell.playButton.isHidden = message.videoUrl == nil;
        
        return cell
    }
    
    func setUpCell(cell: ChatMessageCell, message: Message) {
        
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        

        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing messages / blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        }
        else {
            //incoming messages / grey
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        }
        else {
            cell.messageImageView.isHidden = true
            //            cell.bubbleView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        
        let message = messages[indexPath.item]
        
        if let text = message.message {
            height = estimateFrameForText(string: text).height + 20
        }
        else if let imageWith = message.imageWidth?.doubleValue, let imageHeight = message.imageHeight?.doubleValue {
            
            //geometria - 2 rectangulos
            //h1 / w1 = h2 / w2
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWith) * 200
        }
        let width = UIScreen.main.bounds.width;
        
        return CGSize(width: width, height: height)
        
//        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(string: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: string).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            handleVideoSelectedFromUrl(url: videoUrl)
        }
        else {
            handleSelectedImageFromInfo(info: info)
        }
        dismiss(animated: true, completion: nil)

    }
    
    private func handleVideoSelectedFromUrl(url: URL) {
        let filename = UUID().uuidString
        
        let uploadTask = Storage.storage().reference().child("messages_movies").child("\(filename).mov").putFile(from: url, metadata: nil, completion: { (metadata, err) in
            if err != nil {
                print(err)
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                
                if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url) {
                
                    //we are missing the imageURL
                    //"imageUrl": imageUrl,
                    //solved with the insertion of completion
                    
                    self.uploadToFirebaseUsingImage(selectedImage: thumbnailImage, completion: { (imageUrl) in
                        
                        let properties = ["imageUrl": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoUrl": videoUrl] as [String: AnyObject]
                        self.sendMessageWithProperties(properties: properties)
                    })
                    
                    
                }
            }
        })
        
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
    }
    
    private func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage?  {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    private func handleSelectedImageFromInfo(info: [String: Any]) {
        var imageSelected : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            imageSelected = editedImage
            
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageSelected = originalImage
        }
        
        if let selectedImage = imageSelected {
            uploadToFirebaseUsingImage(selectedImage: selectedImage, completion: { (imageUrl) in
                self.sendImageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
            })
        }
    }
    
    private func uploadToFirebaseUsingImage(selectedImage: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("messages_images").child("\(imageName).png")
        
        if let imageData = UIImageJPEGRepresentation(selectedImage, 0.2) {
            ref.putData(imageData, metadata: nil, completion: { (metadata, err) in
                if err != nil {
                    print(err)
                    return
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    print(imageUrl)
                    completion(imageUrl)
//                    self.sendImageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
                }
                
            })
        }
        
        
    }
    
    private func sendImageWithImageUrl(imageUrl: String, image: UIImage) {
       
        
        
        let properties = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String: AnyObject]
        
        
        sendMessageWithProperties(properties: properties)
        
    }
    
    @objc func handleSend() {
        
        let properties = ["message": inputContainerView.inputTextField.text!] as [String: AnyObject]
        
        
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties: [String: AnyObject]) {
        //Vai criar um novo node com nome "messages" para guardar as mensagens
        let ref = Database.database().reference().child("messages")
        //Cria sempre um novo node filho com o id unico
        let childRef = ref.childByAutoId()
        
        let toId = user!.id!;
        let fromId = Auth.auth().currentUser!.uid;
        //        let timestamp = Int(NSDate().timeIntervalSince1970);
        let timestamp:NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        var values = ["toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : AnyObject]
        //Faz update ao node criado com os valores do dicionario
        properties.forEach {values[$0] = $1}
        
        childRef.updateChildValues(values) { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            
            self.inputContainerView.inputTextField.text = nil;
            
            let userMessagesRef = Database.database().reference().child("users-messages").child(fromId).child(toId)
            let messageKey = childRef.key
            
            userMessagesRef.updateChildValues([messageKey:1])
            
            let recipientUserMessagesRef = Database.database().reference().child("users-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageKey:1])
        }
    }
    
    
    var startingFrame: CGRect?
    var backgroundView: UIView?
    var startingImageView: UIImageView?
    
    //perfrom zoom logic
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        print("performing zoom logic")
        
        //Corrige no zoom out havia sempre a fotografia original por de tras da imagem com zoom que esta a encolher
        self.startingImageView = startingImageView;
        self.startingImageView?.isHidden = true;
        
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            
            let zoomingImageView = UIImageView(frame: startingFrame!)
            zoomingImageView.backgroundColor = UIColor.red
            zoomingImageView.isUserInteractionEnabled = true
            zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
            
            if let keyWindow = UIApplication.shared.keyWindow {
                backgroundView = UIView(frame: keyWindow.frame)
                backgroundView?.backgroundColor = UIColor.black
                //Comeca a 0 para dar aspecto de fade
                backgroundView?.alpha = 0
                
                keyWindow.addSubview(backgroundView!)
                keyWindow.addSubview(zoomingImageView)
                
                zoomingImageView.image = startingImageView.image;
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    //termina a 1 ficando tudo preto quando a imagem clicada ja esta no centro
                    self.backgroundView?.alpha = 1
                    
                    //esconde a textfield do texto inserido
                    self.inputContainerView.alpha = 0
                    
                    //math
                    //h1 / w1 = h2 / w2
                    //h2 = h1 / w1 * w2
                    
                    let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    
                    zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                        
                        zoomingImageView.center = keyWindow.center
                }, completion: nil)
            
            
        }
    }
    
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            
            //Corrige no zoom out havia um glitch do rectangulo a encolher e depois a ficar como o original de cantos curvos
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.layer.masksToBounds = true
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.backgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                
                //Corrige no zoom out havia sempre a fotografia original por de tras da imagem com zoom que esta a encolher, e assim a imagem volta a ficar no ecra
                self.startingImageView?.isHidden = false
            })
        }
    }
}
























