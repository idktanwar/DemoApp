//
//  MainViewController.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import UIKit
import Firebase
import SideMenu

class MainViewController: UIViewController, MenuControllDelegate {
    
    private var sidemenu: SideMenuNavigationController?
    private let blogVC = BlogsViewController()
    private let aboutVC = AboutUsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = MenuController(with: ["Blogs", "About Us"])
        menu.delegate  = self
        
        sidemenu = SideMenuNavigationController(rootViewController: menu)
        sidemenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sidemenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        setupUI()
        checkIfUserIsLoggedIn()
    
    }
    
    func setupUI() {
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "line.horizontal.3"), for:.normal)
        button.addTarget(self, action: #selector(didTappedMenuButton), for: .touchUpInside)
        button.frame = CGRect(x:0, y:0, width:32, height:32)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        title = "Home"
        view.backgroundColor = .white
    }
    
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                
                // UPDATE: - iOS 13 presentation fix
                navController.modalPresentationStyle = .fullScreen
                
                self.present(navController, animated: true, completion: nil)
            } catch {
                print("Failed to sign out")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func addChildViewController() {
        addChild(blogVC)
        addChild(aboutVC)
        view.addSubview(blogVC.view)
        view.addSubview(aboutVC.view)
        
        blogVC.view.frame = view.bounds
        aboutVC.view.frame = view.bounds
        
        blogVC.didMove(toParent: self)
        aboutVC.didMove(toParent: self)
        
        blogVC.view.isHidden = true
        aboutVC.view.isHidden = true

    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                
                let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
               
                let navController = UINavigationController(rootViewController: rootController)

                // UPDATE: iOS 13 presentation fix
                navController.modalPresentationStyle = .fullScreen

                self.present(navController, animated: true, completion: nil)
            }
            return
        }else {
            addChildViewController()
        }
    }
    
    @IBAction func didTappedMenuButton(_ sender: Any) {
        present(sidemenu!, animated: true)
    }
    
    func didSelectMenuItem(name: String) {
        
        self.title = name
        
        sidemenu?.dismiss(animated: true, completion: { [weak self] in
            if name == "Blogs" {
                self?.view.backgroundColor = .green
                self?.aboutVC.view.isHidden = true
                self?.blogVC.view.isHidden = false
            }
            else if name == "About Us" {
                self?.view.backgroundColor = .red
                self?.blogVC.view.isHidden = true
                self?.aboutVC.view.isHidden = false
            }
        })
    }
    
}

