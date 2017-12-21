//
//  LoginController+handlers.swift
//  GameOfThronesChat
//
//  Created by Nuno Pereira on 13/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectProfileImageView() {
        print("123")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var imageSelected : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            imageSelected = editedImage
            dismiss(animated: true, completion: nil)
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageSelected = originalImage
            dismiss(animated: true, completion: nil)
        }
        
        profileImageView.image = imageSelected;
        print(info)
    }
    
    func handleRegister(){
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if err != nil {
                print(err?.localizedDescription)
            }
            
            guard let uid = user?.uid else {return}
            print("User authenticated successfully!")
            
            let imageViewUuid = UUID().uuidString;
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageViewUuid).png")
            
            if let profileImage = self.profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            
            
            //apesar de fazer compressao nao e a forma de comprimir mais
//            if let imadeData = UIImagePNGRepresentation(self.profileImageView.image!) {
            
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        print(err)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl":profileImageUrl];
                        self.handleRegisterInDbWithUUID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        }
    }
    
    private func handleRegisterInDbWithUUID(uid: String, values: [String:AnyObject]){
        let ref = Database.database().reference()
        let usersRef = ref.child("users").child(uid);
         
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("error saving user in db")
                return
            }
            print("Saved user in db")
            
//            self.messagesController?.fetchUserAndUpdateNavBar()
//            self.messagesController?.navigationItem.title = values["name"] as? String
            
            let user = MyUser()
            user.name = values["name"] as? String
            user.email = values["email"] as? String
            user.profileImageUrl = values["profileImageUrl"] as? String
            self.messagesController?.setUpNavBarUser(user: user)
            self.dismiss(animated: true, completion: nil)
        })
    }
}
