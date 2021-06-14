//
//  BlogDetailViewController.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import UIKit

class BlogDetailViewController: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var selectedItem: Article?
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:-  Helper methods
    
    func setupUI() {
        self.title = "Blog Details"
        self.lblDesc.text = selectedItem?.articleDescription
        self.lblTitle.text = selectedItem?.title
        self.lblDate.text = "Publised Date : " + Helper.app.convertDateFormater(selectedItem?.publishedAt)
        getDisplayImage(withPosterPath: selectedItem?.urlToImage)
    }
    
    // MARK: - Web Service Call
    
    private func getDisplayImage(withPosterPath posterString: String?){
        if let posterString = posterString, posterString.count > 0 {
            guard let posterImageURL = URL(string: posterString) else {
                self.imgArticle.image = UIImage(named: "noImageAvailable")
                return
            }
            
            // Before we download the image we remove old image
            self.imgArticle.image = nil
            getImageDataFrom(url: posterImageURL)
        }
        
    }
    
    private func getImageDataFrom(url: URL) {
        WebService().getImageDataFrom(url: url) { [weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self!.imgArticle.image = image
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self!.imgArticle.image = UIImage(named: "noImageAvailable")
            }
        }
    }
    
}
