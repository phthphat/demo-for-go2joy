//
//  HotelSuggestItemCell.swift
//  InstaClone
//
//  Created by Phat Pham on 17/02/2021.
//

import UIKit

class HotelSuggestItemCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
