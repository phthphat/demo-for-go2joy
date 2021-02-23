//
//  CalendarItemCltVCell.swift
//  InstaClone
//
//  Created by Phat Pham on 19/02/2021.
//

import UIKit

class CalendarItemCltVCell: UICollectionViewCell {
    @IBOutlet weak var wrapperV: UIView!
    @IBOutlet weak var lb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        wrapperV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lb.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lb.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //Bad code here
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
            wrapperV.layer.cornerRadius = wrapperV.frame.height / 2
        }
    }
    
    func setHighlight(isEnable: Bool) {
        if isEnable {
            lb.textColor = .white
            wrapperV.isHidden = false
        } else {
            lb.textColor = .black
            wrapperV.isHidden = true
        }
    }
    func setData(text: String) {
        self.lb.text = text
        setHighlight(isEnable: isHighlighted)
    }
    func setPassedDay(_ active: Bool) {
        self.lb.textColor = active ? .gray : self.lb.textColor
    }
    var isChosen = false {
        didSet {
            setHighlight(isEnable: isChosen)
        }
    }
}
