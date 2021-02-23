//
//  BaseXibView.swift
//  InstaClone
//
//  Created by Phat Pham on 17/02/2021.
//

import Foundation
import UIKit

class BaseXibView: UIView {
    
    override var backgroundColor: UIColor? {
        didSet {
            view?.backgroundColor = backgroundColor
        }
    }
    
    private var view : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view?.frame = bounds
        addSubview(view ?? UIView())
        view?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        initView()
    }
    
    func initView() {}
}

