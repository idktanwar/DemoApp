//
//  BlogListCell.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import UIKit

class BlogListCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
