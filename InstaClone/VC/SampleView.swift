//
//  SampleView.swift
//  InstaClone
//
//  Created by Phat Pham on 19/02/2021.
//

import UIKit

class SampleView: BaseXibView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var number: Int?
    init(number: Int) {
        super.init(frame: .zero)
        self.number = number
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
