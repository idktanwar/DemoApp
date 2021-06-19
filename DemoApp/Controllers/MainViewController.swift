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
    
    //MARK:- Properties
    
    private var sidemenu: SideMenuNavigationController?
    let blogVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlogsViewController")
    let aboutVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutUsViewController")
    @IBOutlet weak var tblView: UITableView!
    private var viewModel = ArticlesViewModel()

    //MARK:- LifeCycle
    
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
        fetchArticleData()
    }
    
    //MARK:- Helper Methods
    func setupUI() {
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "line.horizontal.3"), for:.normal)
        button.addTarget(self, action: #selector(didTappedMenuButton), for: .touchUpInside)
        button.frame = CGRect(x:0, y:0, width:32, height:32)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        title = "Blogs"
        view.backgroundColor = .white

        tblView?.delegate = self
        tblView?.estimatedRowHeight = 44
        tblView?.rowHeight = UITableView.automaticDimension
        tblView?.separatorColor = .clear
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
    
    func fetchArticleData() {
        viewModel.fetchArticleData { [weak self] in
            self?.tblView?.dataSource = self
            self?.tblView?.reloadData()
        }
    }
    
    //MARK:- Selectors
    
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
                let navController = UINavigationController(rootViewController: rootController)                
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch {
                print("Failed to sign out")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTappedMenuButton(_ sender: Any) {
        present(sidemenu!, animated: true)
    }
    
    func didSelectMenuItem(name: String) {
        
        self.title = name
        
        sidemenu?.dismiss(animated: true, completion: { [weak self] in
            if name == "Blogs" {
                self?.aboutVC.view.isHidden = true
                self?.blogVC.view.isHidden = false
            }
            else if name == "About Us" {
                self?.blogVC.view.isHidden = true
                self?.aboutVC.view.isHidden = false
            }
        })
    }
    
}

//MARK:- TableView Delegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogcell", for: indexPath) as! BlogListCell
        let article = viewModel.cellForRowAt(indexPath: indexPath)
        cell.lblTitle.text = article.title
        cell.lblDetails.text = article.articleDescription
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.cellForRowAt(indexPath: indexPath)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
        viewController.selectedItem = article
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
