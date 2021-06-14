//
//  SignUpViewController.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import UIKit
import Firebase


class SignUpViewController: UITableViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConPassword: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgProfile.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)
        
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    //MARK:- Selectors
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.openGallery()
    }
    
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        //        let imgSystem = UIImage(systemName: "person.crop.circle.badge.plus")
        
        if let email = txtEmail.text, let password = txtPassword.text, let username = txtUsername.text, let conPassword = txtConPassword.text{
            if username == ""{
                print("Please enter username")
            }else if !email.validateEmailId(){
                openAlert(title: "Alert", message: "Please enter valid email", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                print("email is not valid")
            }else if !password.validatePassword(){
                print("Password is not valid")
            } else{
                if conPassword == ""{
                    print("Please confirm password")
                }else{
                    if password == conPassword{
                        //Save the user to firebase DB
                        // navigation code main screen
                        
                        
                        // properties
                        guard let email = txtEmail.text else { return }
                        guard let password = txtPassword.text else { return }
                        guard let username = txtUsername.text?.lowercased() else { return }
                        
                        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                            
                            // handle error
                            if let error = error {
                                print("DEBUG: Failed to create user with error: ", error.localizedDescription)
                                self.openAlert(title: "Error", message: error.localizedDescription, alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                                    print("Okay clicked!")
                                }])
                                return
                            }
                            
                            guard let profileImg = self.imgProfile.image else { return }
                            guard let uploadData = profileImg.jpegData(compressionQuality: 0.3) else { return }
                            
                            let filename = NSUUID().uuidString
                            
                            // UPDATE: - In order to get download URL must add filename to storage ref like this
                            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
                            
                            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                
                                // handle error
                                if let error = error {
                                    print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
//                                    self.openAlert(title: "Error", message: error.localizedDescription, alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
//                                        print("Okay clicked!")
//                                    }])
                                    return
                                }
                                
                                // UPDATE: - Firebase 5 must now retrieve download url
                                storageRef.downloadURL(completion: { (downloadURL, error) in
                                    guard let profileImageUrl = downloadURL?.absoluteString else {
                                        print("DEBUG: Profile image url is nil")
                                        return
                                    }

                                    // user id
                                    guard let uid = authResult?.user.uid else { return }
                                    guard let fcmToken = Messaging.messaging().fcmToken else { return }

                                    let dictionaryValues = ["fcmToken": fcmToken,
                                                            "username": username,
                                                            "profileImageUrl": profileImageUrl]

                                    let values = [uid: dictionaryValues]

                                    // save user info to database
                                    USER_REF.updateChildValues(values, withCompletionBlock: { (error, ref) in

                                        guard let mainVC = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else { return }

                                        // configure view controllers in maintabvc
    
                                        // dismiss login controller
                                        self.dismiss(animated: true, completion: nil)
                                    })
                                })
                            })
                        }
                    }else{
                        print("password does not match")
                    }
                }
            }
        }else{
            print("Please check your details")
        }
        
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- ImagePickerController

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage{
            imgProfile.image = img
        }
        dismiss(animated: true)
    }
}
