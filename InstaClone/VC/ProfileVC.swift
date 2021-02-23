//
//  ProfileVC.swift
//  InstaClone
//
//  Created by Phat Pham on 17/02/2021.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var pageWrapperV: UIView!
    @IBOutlet weak var lineWrapper: UIView!
    
//    let view = SampleView()
    
    let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    lazy var vcs: [InstaLikeBaseVC] = [Screen1VC(), Screen3VC(), Screen2VC()]
    @IBOutlet var tabV: [UIView]!
    
    @IBOutlet var tabLb: [UILabel]!
    
    let lineV = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let heightContraint = pageWrapperV.heightAnchor.constraint(equalToConstant: self.view.frame.height - 130)
        heightContraint.isActive = true
        
        addChild(pageVC)
        pageWrapperV.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.view.frame = pageWrapperV.bounds
        
        pageVC.setViewControllers([vcs.first!], direction: .forward, animated: true, completion: nil)
        
//        scrollV.isScrollEnabled = false
        
        tabV.forEach { views in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapTabView(_:)))
            views.addGestureRecognizer(tapGesture)
        }
        
        lineV.backgroundColor = .systemOrange
        lineWrapper.addSubview(lineV)
        lineV.frame = .init(x: tabLb[0].frame.minX, y: 0, width: tabLb[0].frame.width, height: lineWrapper.frame.height)
        
        //Navigation
        self.title = "Point"
        self.navigationController?.navigationBar.isTranslucent = false
        let backButton = UIBarButtonItem(title: "<", style: .plain, target: nil, action: nil)
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.masksToBounds = false
        //border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //Scroll delegate
        scrollV.delegate = self
        //pan gesture
//        let panGes = UIPanGestureRecognizer(target: self, action: #selector(onPanOnView(_:)))
        self.view.addGestureRecognizer(self.scrollV.panGestureRecognizer)
        self.scrollV.removeGestureRecognizer(self.scrollV.panGestureRecognizer)
    }
    
    @objc func onPanOnView(_ gesture: UIPanGestureRecognizer) {
        print()
    }
    
    var currentPageIndex = 0
    
    @objc func onTapTabView(_ ges: UIGestureRecognizer) {
        guard let index = self.tabV.firstIndex(of: ges.view!) else { return }
        guard currentPageIndex != index else { return }
        
        pageVC.setViewControllers([vcs[index]], direction: currentPageIndex > index ? .reverse : .forward, animated: true, completion: nil)
        currentPageIndex = index
        setLbSelect(index: index)
        moveLineTo(index: index)
    }
    
    func setLbSelect(index: Int) {
        tabLb.forEach { lb in
            let text = lb.text ?? ""
            let arrStr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 18)!])
            lb.attributedText = arrStr
        }
        let text = tabLb[index].text ?? ""
        tabLb[index].attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!])
    }
    func moveLineTo(index: Int) {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            lineV.frame = .init(x: self.tabV.first!.frame.width * CGFloat(index) + tabLb[index].frame.minX, y: 0, width: tabLb[index].frame.width, height: lineWrapper.frame.height)
        }
    }
    var lastContentOffset: CGFloat = 0
    
    func onScrollAt(y: CGFloat) {
        print(y)
        if (y >= 220 ) {
            vcs.forEach { vc in
                vc.scrollView?.isScrollEnabled = true
            }
        } else {
            vcs.forEach { vc in
                vc.scrollView?.isScrollEnabled = false
            }
        }
    }
}


extension ProfileVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? InstaLikeBaseVC,
              let index = vcs.firstIndex(of: viewController) else { return nil }
        if (index == 0) {
            return nil
        }
        let nextIndex = index - 1
        return vcs[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController as! InstaLikeBaseVC) else { return nil }
        
        if (index == vcs.count - 1) {
            return nil
        }
        let nextIndex = index + 1
        return vcs[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let lastVC = pageVC.viewControllers?.first as? InstaLikeBaseVC else { return }
        guard let index = vcs.firstIndex(of: lastVC) else { return }
        currentPageIndex = index
        setLbSelect(index: index)
        moveLineTo(index: index)
    }
}

extension ProfileVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollAt(y: scrollView.contentOffset.y)
    }
}
