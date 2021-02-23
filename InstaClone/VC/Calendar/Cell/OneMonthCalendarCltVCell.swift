//
//  OneMonthCalendarCltVCell.swift
//  InstaClone
//
//  Created by Phat Pham on 20/02/2021.
//

import UIKit

class OneMonthCalendarCltVCell: UICollectionViewCell {

    @IBOutlet weak var calendarV: OneMonthView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setMonthYearToRender(month: Int, year: Int) {
        self.calendarV.setMonthYearToRender(month: month, year: year)
    }
    func setCurDateChoice(day: Int, month: Int, year: Int) {
        calendarV.curChoiceDate = (day, month, year)
    }
}
