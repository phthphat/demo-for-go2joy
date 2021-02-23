//
//  TestVC.swift
//  InstaClone
//
//  Created by Phat Pham on 22/02/2021.
//

import UIKit

class TestVC: UIViewController {

    @IBOutlet weak var cltV: UICollectionView!
    
    var colors: [UIColor] = [.systemGreen, .systemBlue, .systemOrange, .systemRed, .systemYellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cltV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "id")
    }

}

extension TestVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
}

extension TestVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.cltV.frame.width / 2, height: 40)
    }
}
