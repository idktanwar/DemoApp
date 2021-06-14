//
//  BlogsViewController.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import UIKit

class BlogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    private var viewModel = ArticlesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupUI()
    }
    
    func setupUI() {
        tblView?.delegate = self
        tblView?.tableFooterView = UIView(frame: .zero)
        
        viewModel.fetchArticleData { [weak self] in
            self?.tblView?.dataSource = self
            //just to move focus to 1st row after for next page
            self?.tblView?.reloadData()
        }
    }

    //Table
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
}
