//
//  SideMenu.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import Foundation
import UIKit

protocol MenuControllDelegate {
    func didSelectMenuItem(name: String)
}

class MenuController: UITableViewController {
    
    var delegate: MenuControllDelegate?
    private let menuitems: [String]
    private let darkColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    init(with menuItems: [String]) {
        self.menuitems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell" )
        
        tableView.tableFooterView  = UIView.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = darkColor
        view.backgroundColor = darkColor
    }
    //TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuitems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuitems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = darkColor
        cell.contentView.backgroundColor = darkColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuitems[indexPath.row]
        delegate?.didSelectMenuItem(name: selectedItem)
        
    }
}
