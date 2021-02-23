//
//  BaseScrollItemVC.swift
//  InstaClone
//
//  Created by Phat Pham on 17/02/2021.
//

import UIKit

//class BaseScrollItemVC: UIViewController, UIScrollViewDelegate {
//
//}

class InstaLikeBaseVC: UIViewController, UIScrollViewDelegate {
    open var scrollView: UIScrollView?
    var onScrollAtY: ((CGFloat) -> Void)?
    
    lazy var nestedScrollingDecelerator = ScrollingDecelerator(scrollView: self.scrollView!)

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        nestedScrollingDecelerator.invalidateIfNeeded()
    }
}
