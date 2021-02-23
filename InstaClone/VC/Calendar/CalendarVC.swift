//
//  CalendarVC.swift
//  InstaClone
//
//  Created by Phat Pham on 19/02/2021.
//

import UIKit

class CalendarVC: UIViewController {
    //MARK: Element
    @IBOutlet weak var calendarV: OneMonthView!
    @IBOutlet weak var dateChoosenLb: UILabel!
    @IBOutlet weak var calendarHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var fromToTimeHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var dateV: UIView!
    @IBOutlet weak var timeV: UIView!
    @IBOutlet weak var fromTimeTbV: UITableView!
    @IBOutlet weak var toTimeTbV: UITableView!
    
    var subscription: Any?
    //MARK: State
    var isShowingCalendar: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) { [unowned self] in
                if isShowingCalendar {
                    calendarHeightContraint.constant = 300
                } else {
                    calendarHeightContraint.constant = 0
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    var isShowingFromToTime: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) { [unowned self] in
                if isShowingFromToTime {
                    fromToTimeHeightContraint.constant = 300
                } else {
                    fromToTimeHeightContraint.constant = 0
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    var curDateChoosen: (day: Int, month: Int, year: Int) = (1, 1, 2021) {
        didSet {
            let monthDisplay = Month(rawValue: curDateChoosen.month)
            dateChoosenLb.text = "\(monthDisplay?.display ?? "Undefined") \(curDateChoosen.day)"
            dateChoosenLb.sizeToFit()
        }
    }
    lazy var selectedFromTimeInterval: Int = fromTimes.first!
    lazy var selectedToTimeInterval: Int = toTimes.first!
    //MARK: Other Properties
    private var calendar = Calendar(identifier: .gregorian)
    
    /**
     `unitTiming` is equivalent 30 minutes
     */
    private var unitTiming = 1
    lazy var fromTimes: [Int] = (0...24 * 2 - 1).map { $0 * unitTiming }
    lazy var toTimes = fromTimes

    deinit {
        NotificationCenter.default.removeObserver(subscription as Any)
    }
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        initState()
        setUpNotification()
    }
    
    private func initState() {
        isShowingCalendar = false
        isShowingFromToTime = false
        //date
        let dateComp = calendar.dateComponents([.day, .month, .year], from: Date())
        curDateChoosen = (dateComp.day!, dateComp.month!, dateComp.year!)
//        dateChoosenLb.text = "\(dateComp.day!)/\(dateComp.month!)"
    }
    private func setUpUI() {
        //dateView
        dateV.isUserInteractionEnabled = true
        dateV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapDateV(_:))))

        timeV.isUserInteractionEnabled = true
        timeV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapTimeV(_:))))
        
        //tableView
        fromTimeTbV.registerXibCell(HourMinuteCell.self)
        toTimeTbV.registerXibCell(HourMinuteCell.self)
//        fromTimeTbV.isPagingEnabled = true
//        toTimeTbV.isPagingEnabled = true
    }
    private func setUpNotification() {
        subscription = NotificationCenter.default.addObserver(forName: .dateChoice, object: nil, queue: .main, using: { [unowned self] noti in
            if let userInfo = noti.userInfo, let data = userInfo["data"] as? (day: Int, month: Int, year: Int) {
                dateChoosenLb.text = "\(data.day)/\(data.month)"
            }
        })
    }
    //MARK: Logic
    private func timeIntervalToHourMin(_ interval: Int) -> (hour: Int, min: Int) {
        let hour = interval / 2
        let min = interval % 2 * 30
        return (hour, min)
    }
    
    private func timeIntervalToLabel(_ interval: Int) -> String {
        let time = timeIntervalToHourMin(interval)
        let hourStr = time.hour >= 10 ? "\(time.hour)" : "0\(time.hour)"
        let minStr = time.min == 30 ? "\(time.min)" : "00"
        return "\(hourStr):\(minStr)"
    }
    
    //MARK: Event function
    @objc func onTapDateV(_ ges: UITapGestureRecognizer) {
        isShowingCalendar.toggle()
        isShowingFromToTime = false
    }
    @objc func onTapTimeV(_ ges: UITapGestureRecognizer) {
        isShowingCalendar = false
        isShowingFromToTime.toggle()
    }
}

extension CalendarVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.fromTimeTbV {
            return fromTimes.count
        }
        if tableView == self.toTimeTbV {
            return toTimes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.fromTimeTbV {
            let cell = tableView.dequeueCell(HourMinuteCell.self, indexPath: indexPath)
            let data = fromTimes[indexPath.row]
            cell.setTitle(timeIntervalToLabel(data))
            cell.setState(data == selectedFromTimeInterval ? .selected : .normal)
            return cell
        }
        if tableView == self.toTimeTbV {
            let cell = tableView.dequeueCell(HourMinuteCell.self, indexPath: indexPath)
            let data = fromTimes[indexPath.row]
            cell.setTitle(timeIntervalToLabel(data))
            let isDisable = selectedFromTimeInterval % 2 != data % 2
            if isDisable {
                cell.setState(.disable)
            } else {
                cell.setState(data == selectedToTimeInterval ? .selected : .normal)
            }
            return cell
        }
        return .init()
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView == self.toTimeTbV {
            let data = fromTimes[indexPath.row]
            let isDisable = selectedFromTimeInterval % 2 != data % 2
            return isDisable ? nil : indexPath
        }
        return indexPath
    }
}
//MARK: UITableViewDelegate
extension CalendarVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.fromTimeTbV {
            guard let cell = tableView.cellForRow(at: indexPath) as? HourMinuteCell else { return }
            selectedFromTimeInterval = fromTimes[indexPath.row]
            cell.setState(.selected)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            //For toTbV
            let needSelectedIndexPath = IndexPath(row: indexPath.row + 2, section: indexPath.section)
            //setselect
            selectedToTimeInterval = selectedFromTimeInterval + 2
            self.toTimeTbV.reloadData()
            if let cell = self.toTimeTbV.cellForRow(at: needSelectedIndexPath) as? HourMinuteCell {
                cell.setState(.selected)
                cell.setSelected(true, animated: true)
                self.toTimeTbV.selectRow(at: needSelectedIndexPath, animated: true, scrollPosition: .none)
            }
            self.toTimeTbV.scrollToRow(at: needSelectedIndexPath, at: .top, animated: true)
        }
        if tableView == self.toTimeTbV {
            guard let cell = tableView.cellForRow(at: indexPath) as? HourMinuteCell else { return }
            selectedToTimeInterval = fromTimes[indexPath.row]
            cell.setState(.selected)
            
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == self.fromTimeTbV {
            guard let cell = tableView.cellForRow(at: indexPath) as? HourMinuteCell else { return }
            cell.setState(.normal)
        }
        if tableView == self.toTimeTbV {
            guard let cell = tableView.cellForRow(at: indexPath) as? HourMinuteCell else { return }
            cell.setState(.normal)
        }
    }
    
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
