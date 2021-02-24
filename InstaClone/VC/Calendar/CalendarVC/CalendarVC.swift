//
//  CalendarVC.swift
//  InstaClone
//
//  Created by Phat Pham on 19/02/2021.
//

import UIKit

class CalendarVC: UIViewController {
    //MARK: Element

    lazy var whiteFrame = DownPopUp(target: self, tapBlackViewToDismiss: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentView = ContentPopUp()
        whiteFrame.addViewToFrame(contentView)
    }
    
    //MARK: Event function
    @IBAction func onTapSampleBtn(_ sender: UIButton) {
        whiteFrame.isShowing.toggle()
    }
//    @objc func onTapDateV(_ ges: UITapGestureRecognizer) {
//        isShowingCalendar.toggle()
//        isShowingFromToTime = false
//    }
//    @objc func onTapTimeV(_ ges: UITapGestureRecognizer) {
//        isShowingCalendar = false
//        isShowingFromToTime.toggle()
//    }
}

enum Month: Int {
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    var display: String {
        switch self {
        case .jan: return "January"
        case .feb: return "February"
        case .mar: return "March"
        case .apr: return "April"
        case .may: return "May"
        case .jun: return "June"
        case .jul: return "July"
        case .aug: return "August"
        case .sep: return "September"
        case .oct: return "October"
        case .nov: return "November"
        case .dec: return "December"
        }
    }
}
