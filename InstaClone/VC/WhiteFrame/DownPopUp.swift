//
//  WhiteFrame.swift
//  InstaClone
//
//  Created by phat on 24/02/2021.
//

import Foundation
import UIKit

class DownPopUp {
    let view = UIView()
    
    private var bottomContraint: NSLayoutConstraint!
    private var topContraint: NSLayoutConstraint!
    //MARK: State
    var isShowing = false {
        didSet {
            isShowing ? show() : hide()
        }
    }
    
    let blackView = UIView()
    
    let target: UIViewController
    
    private var animationInterval: TimeInterval = 0.3
    
    init(target: UIViewController, tapBlackViewToDismiss: Bool = false) {
        self.target = target
        target.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: target.view.widthAnchor).isActive = true
        
        topContraint = view.topAnchor.constraint(equalTo: target.view.bottomAnchor)
        bottomContraint = view.bottomAnchor.constraint(equalTo: target.view.bottomAnchor, constant: 5)
        
        topContraint.isActive = true
        //black view
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        if tapBlackViewToDismiss {
            blackView.isUserInteractionEnabled = true
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapDismissBlackview(_:))))
        }
        //whiteframeview
        view.backgroundColor = .blue
        view.layer.cornerRadius = 20
    }
    
    @objc private func onTapDismissBlackview(_ ges: UITapGestureRecognizer) {
        isShowing = false
    }
    
    func show() {
        //Full screen with blackview
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .allowUserInteraction, animations: { [unowned self] in
            topContraint.isActive = false
            bottomContraint.isActive = true

            target.view.layoutIfNeeded()
        })
        
        blackView.frame = target.view.bounds
        target.view.insertSubview(blackView, belowSubview: self.view)
        blackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    func hide() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .allowUserInteraction, animations: { [unowned self] in
                        
            topContraint.isActive = true
            bottomContraint.isActive = false
            target.view.layoutIfNeeded()
        })
        //Remove full screen
        blackView.removeFromSuperview()
    }
    
    func addViewToFrame(_ mainView: UIView) {
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
    }
}
