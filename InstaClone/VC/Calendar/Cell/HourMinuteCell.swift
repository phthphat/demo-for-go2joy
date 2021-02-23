//
//  HourMinuteCell.swift
//  InstaClone
//
//  Created by phat on 23/02/2021.
//

import UIKit

class HourMinuteCell: UITableViewCell {

    @IBOutlet weak var lb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setState(_ state: State) {
        switch state {
        case .normal:
            lb.textColor = .black
        case .selected:
            lb.textColor = .systemOrange
        case .disable:
            lb.textColor = .gray
        }
    }
    
    func setTitle(_ str: String) {
        self.lb.text = str
    }
    
    enum State {
        case normal, selected, disable
    }
}

