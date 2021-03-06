//
//  LoginViewController.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import UIKit
import Firebase

class LoginViewController: UITableViewController {

    //MARK:- Properties
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK:- Selector
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        ValidationCode()
    }
    
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        if let signupVC = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController{
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
}

//MARK:-  TableView
extension LoginViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)
        
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

//MARK:- Helper
extension LoginViewController{
    fileprivate func ValidationCode() {
        if let email = txtEmail.text, let password = txtPassword.text{
            if !email.validateEmailId(){
                openAlert(title: "Alert", message: "Email address not found.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
            }else if !password.validatePassword(){
                openAlert(title: "Alert", message: "Please enter valid password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
            }else{
                // Navigation - Home Screen
                // properties
                guard
                    let email = txtEmail.text,
                    let password = txtPassword.text else { return }
                
                // sign user in with email and password

                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    
                    // handle error
                    if let error = error {
                        print("Unable to sign user in with error", error.localizedDescription)
                        return
                    }
                    
                    guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
                        return
                    }
                    
                    let navigationController = UINavigationController(rootViewController: rootVC)
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }else{
            openAlert(title: "Alert", message: "Please add detail.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                print("Okay clicked!")
            }])
        }
    }
}
