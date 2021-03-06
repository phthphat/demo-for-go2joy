//
//  ContentPopUp.swift
//  InstaClone
//
//  Created by phat on 24/02/2021.
//

import Foundation
import UIKit

class ContentPopUp: BaseXibView {
    @IBOutlet weak var calendarV: FullCalendarView!
    @IBOutlet weak var dateChoosenLb: UILabel!
    @IBOutlet weak var calendarHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var fromToTimeHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var dateV: UIView!
    @IBOutlet weak var timeV: UIView!
    @IBOutlet weak var fromTimeTbV: UITableView!
    @IBOutlet weak var toTimeTbV: UITableView!
    //
    var notiSubscription: Any?
    
    var isShowingCalendar: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                if isShowingCalendar {
                    calendarHeightContraint.constant = 300
                } else {
                    calendarHeightContraint.constant = 0
                }
                self.layoutIfNeeded()
            }
        }
    }
    var isShowingFromToTime: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                if isShowingFromToTime {
                    fromToTimeHeightContraint.constant = 300
                } else {
                    fromToTimeHeightContraint.constant = 0
                }
                self.layoutIfNeeded()
                fromTimeTbV.scrollToRow(at: .init(row: selectedFromTimeInterval, section: 0), at: .top, animated: false)
                toTimeTbV.scrollToRow(at: .init(row: selectedToTimeInterval, section: 0), at: .top, animated: false)
            }
        }
    }
    var curDateChoosen: (day: Int, month: Int, year: Int) = (1, 1, 2021) {
        didSet {
            let monthDisplay = Month(rawValue: curDateChoosen.month)
            dateChoosenLb.text = "\(monthDisplay?.display ?? "Undefined") \(curDateChoosen.day)"
            dateChoosenLb.sizeToFit()
            setUpRangeTime()
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
    //MARK: Config variable
    var hourAllowStart_Config: Float = 8
    var hourAllowEnd_Config: Float = 21
    let minimunHourAllow: Int = 2
    
    //Don't config on these variables
    lazy var fromHourAllowStart: Float = hourAllowStart_Config
    lazy var fromHourAllowEnd: Float = hourAllowEnd_Config - Float(minimunHourAllow)
    
    lazy var toHourAllowStart: Float = hourAllowStart_Config + Float(minimunHourAllow)
    lazy var toHourAllowEnd: Float = hourAllowEnd_Config

    deinit {
        NotificationCenter.default.removeObserver(notiSubscription as Any)
    }
    override func initView() {
        setUpUI()
        setUpNotification()
        setUpRangeTime()
        postSetUp()
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
        
        fromTimeTbV.decelerationRate = .fast
        toTimeTbV.decelerationRate = .fast
    }
    private func setUpNotification() {
        notiSubscription = NotificationCenter.default.addObserver(forName: .dateChoice, object: nil, queue: .main, using: { [unowned self] noti in
            if let userInfo = noti.userInfo, let data = userInfo["data"] as? (day: Int, month: Int, year: Int) {
//                dateChoosenLb.text = "\(data.day)/\(data.month)"
                curDateChoosen = data
            }
        })
    }
    private func setUpRangeTime() {
        let nowComp = calendar.dateComponents([.hour, .minute, .second, .day, .month, .year], from: Date())
        if curDateChoosen == (nowComp.day!, nowComp.month!, nowComp.year!) {
            fromHourAllowStart = max(Float(nowComp.hour!) + 0.5, fromHourAllowStart)
            toHourAllowStart = max(Float(nowComp.hour!) + Float(minimunHourAllow) + 0.5, toHourAllowStart)
        } else {
            fromHourAllowStart = hourAllowStart_Config
            toHourAllowStart = hourAllowStart_Config + Float(minimunHourAllow)
        }

//        fromHourAllowStart = max(fromHourAllowStart, toHourAllowStart - Float(minimunHourAllow))
//        fromHourAllowEnd = min(fromHourAllowEnd, toHourAllowEnd - Float(minimunHourAllow))
        
        selectedFromTimeInterval = hourToInterval(hour: fromHourAllowStart)
        selectedToTimeInterval = hourToInterval(hour: toHourAllowStart)
        
//        [self.fromTimeTbV, self.toTimeTbV].forEach { $0?.reloadData() }
        fromTimeTbV.reloadData()
        fromTimeTbV.layoutIfNeeded()
        toTimeTbV.reloadData()
        toTimeTbV.layoutIfNeeded()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
            fromTimeTbV.scrollToRow(at: .init(row: selectedFromTimeInterval, section: 0), at: .top, animated: false)
            toTimeTbV.scrollToRow(at: .init(row: selectedToTimeInterval, section: 0), at: .top, animated: false)
//        }
    }
    
    private func postSetUp() {
//        let view = UIView()
//        view.backgroundColor = .red
//        view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            view.widthAnchor.constraint(equalToConstant: 70),
//            view.heightAnchor.constraint(equalToConstant: 70)
//        ])
//        whiteFrame.addViewToFrame(view)
    }
    //MARK: Logic
    private func timeIntervalToHourMin(_ interval: Int) -> (hour: Int, min: Int) {
        let hour = interval / (2 * unitTiming)
        let min = interval % (2 * unitTiming) * 30
        return (hour, min)
    }
    
    private func timeInterval(_ timeInterval: Int, withAddingValue value: Int) -> Int {
        let maxIntervalIn1Day = ((24 * 2)) * unitTiming
        var addedVal = timeInterval + value
        while addedVal < 0 {
            addedVal += maxIntervalIn1Day
        }
        return addedVal % maxIntervalIn1Day
    }
    
    private func timeIntervalToLabel(_ interval: Int) -> String {
        let time = timeIntervalToHourMin(interval)
        let hourStr = time.hour >= 10 ? "\(time.hour)" : "0\(time.hour)"
        let minStr = time.min == 30 ? "\(time.min)" : "00"
        return "\(hourStr):\(minStr)"
    }
    private func hourToInterval(hour: Float) -> Int { return Int(hour * 2 * Float(unitTiming)) }
    //MARK: Event function
//    @IBAction func onTapSampleBtn(_ sender: UIButton) {
//        whiteFrame.isShowing.toggle()
//    }
    @objc func onTapDateV(_ ges: UITapGestureRecognizer) {
        isShowingCalendar.toggle()
        isShowingFromToTime = false
    }
    @objc func onTapTimeV(_ ges: UITapGestureRecognizer) {
        isShowingCalendar = false
        isShowingFromToTime.toggle()
    }
}
extension ContentPopUp: UITableViewDataSource {
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
            let isDisable = data < hourToInterval(hour: fromHourAllowStart)
                || data > hourToInterval(hour: fromHourAllowEnd)
            if isDisable {
                cell.setState(.disable)
            } else {
                cell.setState(data == selectedFromTimeInterval ? .selected : .normal)
            }
            return cell
        }
        if tableView == self.toTimeTbV {
            let cell = tableView.dequeueCell(HourMinuteCell.self, indexPath: indexPath)
            let data = fromTimes[indexPath.row]
            cell.setTitle(timeIntervalToLabel(data))
            let isDisable = selectedFromTimeInterval % 2 != data % 2
                || data < hourToInterval(hour: toHourAllowStart)
                || data > hourToInterval(hour: toHourAllowEnd)
            
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
        if tableView == self.fromTimeTbV {
            let data = fromTimes[indexPath.row]
            let isDisable = data < hourToInterval(hour: fromHourAllowStart)
                || data > hourToInterval(hour: fromHourAllowEnd)
            return isDisable ? nil : indexPath
            
        }
        if tableView == self.toTimeTbV {
            let data = fromTimes[indexPath.row]
            let isDisable = selectedFromTimeInterval % 2 != data % 2
                || data < hourToInterval(hour: toHourAllowStart)
                || data > hourToInterval(hour: toHourAllowEnd)
            return isDisable ? nil : indexPath
        }
        return indexPath
    }
}
//MARK: UITableViewDelegate
extension ContentPopUp: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.fromTimeTbV {
            
            selectedFromTimeInterval = fromTimes[indexPath.row]
            guard selectedFromTimeInterval + 2 * minimunHourAllow * unitTiming <= hourToInterval(hour: toHourAllowEnd)
            else { return }
            
            guard let cell = tableView.cellForRow(at: indexPath) as? HourMinuteCell else { return }
            cell.setState(.selected)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            //For toTbV
            let needSelectedIndexPath = IndexPath(row: timeInterval(selectedFromTimeInterval, withAddingValue: 2 + minimunHourAllow), section: indexPath.section)
            //setselect
            selectedToTimeInterval = timeInterval(selectedFromTimeInterval, withAddingValue: 2 + minimunHourAllow) //selectedFromTimeInterval + 2
            self.toTimeTbV.reloadData()
            if let cell = self.toTimeTbV.cellForRow(at: needSelectedIndexPath) as? HourMinuteCell {
                cell.setState(.selected)
                cell.setSelected(true, animated: true)
            }
            self.toTimeTbV.selectRow(at: needSelectedIndexPath, animated: true, scrollPosition: .top)
//            self.toTimeTbV.scrollToRow(at: needSelectedIndexPath, at: .top, animated: true)
        }
        if tableView == self.toTimeTbV {
            selectedToTimeInterval = toTimes[indexPath.row]
            guard selectedToTimeInterval - 2 * minimunHourAllow * unitTiming <= hourToInterval(hour: fromHourAllowEnd)
            else { return }
            
            guard let cell = tableView.cellForRow(at: indexPath) as? HourMinuteCell else { return }
            cell.setState(.selected)
            self.toTimeTbV.scrollToRow(at: indexPath, at: .top, animated: true)
            if selectedFromTimeInterval + minimunHourAllow >= selectedToTimeInterval {
                selectedFromTimeInterval = timeInterval(selectedToTimeInterval, withAddingValue: -2 - minimunHourAllow)
            }
            self.fromTimeTbV.reloadData()
            let needSelectedIndexPath = IndexPath(row: selectedFromTimeInterval, section: 0)
            self.fromTimeTbV.selectRow(at: needSelectedIndexPath, animated: true, scrollPosition: .top)
//            self.fromTimeTbV.scrollToRow(at: needSelectedIndexPath, at: .top, animated: true)
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

extension ContentPopUp: UIScrollViewDelegate {
    private func tableView(_ tableView: UITableView, selectAt indexPath: IndexPath) {
        if let indexPath = tableView.delegate?.tableView?(tableView, willSelectRowAt: indexPath) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let tbV = scrollView as? UITableView else { return }
        if tbV.isDecelerating { return }
        tbV.delegate?.scrollViewDidEndDecelerating?(tbV)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let tbV = scrollView as? UITableView else { return }
        if let needSelectedIndexPath = tbV.indexPathForRow(
            at: CGPoint(x: tbV.contentOffset.x, y: tbV.contentOffset.y + tbV.rowHeight / 2)
        ) {
//            tbV.scrollToRow(at: needSelectedIndexPath, at: .top, animated: true)
//            needSelectedIndexPath.row += 1
            if let indexPath = tbV.delegate?.tableView?(tbV, willSelectRowAt: needSelectedIndexPath) {
                let needDeselect = IndexPath(row:  tbV == fromTimeTbV ? selectedFromTimeInterval : selectedToTimeInterval, section: 0)
                tbV.delegate?.tableView?(tbV, didDeselectRowAt: needDeselect)
                tbV.delegate?.tableView?(tbV, didSelectRowAt: indexPath)
            }
        }
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard let tbV = scrollView as? UITableView else { return }
//        var offset = targetContentOffset.pointee
//        let index = offset.x + scrollView.contentInset.left
//        let roundedIndex = round(index)
//        offset = CGPoint(x: roundedIndex - scrollView.contentInset.left, y: -scrollView.contentInset.top)
//        targetContentOffset.pointee = offset
//
//    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard let tbV = scrollView as? UITableView else { return }
////            if scrollView == self.tableView {
//                let cellHeight: CGFloat = 48.5
//                var offset = targetContentOffset.pointee
//                print(offset)
//                let index = offset.y / cellHeight
//                let roundedIndex = round(index)
//                offset.y = roundedIndex * cellHeight
//                targetContentOffset.pointee = offset
////            }
//        }
}
