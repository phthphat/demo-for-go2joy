//
//  Screen1VC.swift
//  InstaClone
//
//  Created by Phat Pham on 17/02/2021.
//

import UIKit

class Screen1VC: InstaLikeBaseVC {
    
    override var scrollView: UIScrollView? {
        get { return tableV }
        set { fatalError("Cant set scrollView") }
    }
    
    @IBOutlet weak var tableV: UITableView!
    
    let data = [1,4,2,4,5,6,3,5,6,3,5,23,1,4,53,1,23,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableV.registerXibCell(HistoryItemCell.self)
    }
}

extension Screen1VC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(HistoryItemCell.self, indexPath: indexPath)
        return cell
    }
}

extension UITableView {
    func register(_ classType: UITableViewCell.Type) {
        let className = String(describing: classType.self)
        self.register(classType, forCellReuseIdentifier: className)
    }
    func registerXibCell(_ classType: UITableViewCell.Type) {
        let className = String(describing: classType.self)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellReuseIdentifier: className)
    }
    func dequeueCell<T: UITableViewCell>(_ classType: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: classType.self)
        return self.dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
}

extension UICollectionView {
    func register(_ classType: UICollectionViewCell.Type) {
        let className = String(describing: classType.self)
        self.register(classType, forCellWithReuseIdentifier: className)
    }
    func registerXibCell(_ classType: UICollectionViewCell.Type) {
        let className = String(describing: classType.self)
        let nib = UINib(nibName: className, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: className)
    }
    func dequeueCell<T: UICollectionViewCell>(_ classType: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: classType.self)
        return self.dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as! T
    }
}
