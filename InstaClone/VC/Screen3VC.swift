//
//  Screen3VC.swift
//  InstaClone
//
//  Created by Phat Pham on 17/02/2021.
//

import UIKit

class Screen3VC: InstaLikeBaseVC {

    override var scrollView: UIScrollView? {
        get { return tbV }
        set { fatalError("Cant set scrollView") }
    }
    
    var data = Array(0...10)

    @IBOutlet weak var tbV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tbV.registerXibCell(HotelSuggestItemCell.self)
    }
}

extension Screen3VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(HotelSuggestItemCell.self, indexPath: indexPath)
        return cell
    }
}
