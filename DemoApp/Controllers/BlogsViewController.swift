//
//  BlogsViewController.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import UIKit

class BlogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Properties
    
    @IBOutlet var tblView: UITableView!
    private var viewModel = ArticlesViewModel()
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchArticleData()
    }
    
    //MARK:- Helper Method
    
    func setupUI() {
        tblView?.delegate = self
        tblView?.tableFooterView = UIView(frame: .zero)
    }

    func fetchArticleData() {
        viewModel.fetchArticleData { [weak self] in
            self?.tblView?.dataSource = self
            self?.tblView?.reloadData()
        }
    }
    
    
    //MARK:- TableView Delegate
    
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
