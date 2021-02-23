//
//  Screen2VC.swift
//  InstaClone
//
//  Created by Phat Pham on 17/02/2021.
//

import UIKit

class Screen2VC: InstaLikeBaseVC {
    override var scrollView: UIScrollView? {
        get { return self.scrV }
        set { fatalError("Cant set scrollView") }
    }
    @IBOutlet weak var scrV: UIScrollView!
    @IBOutlet weak var stV: UIStackView!
    
    var itemView: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemView = [UIView(), UIView(), UIView()]
        
        itemView.forEach { v in
            v.heightAnchor.constraint(equalToConstant: 80).isActive = true
            v.backgroundColor = .red
            v.layer.cornerRadius = 10
            stV.insertArrangedSubview(v, at: stV.arrangedSubviews.count)
        }
    }
}
