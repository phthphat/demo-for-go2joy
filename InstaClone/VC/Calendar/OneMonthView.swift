//
//  CalendarView.swift
//  InstaClone
//
//  Created by Phat Pham on 19/02/2021.
//

import UIKit

class OneMonthView: BaseXibView {
    @IBOutlet weak var cltV: UICollectionView!

    private var calendar = Calendar(identifier: .gregorian)
    
    override func initView() {
        cltV.registerXibCell(CalendarItemCltVCell.self)
        self.cltV.contentInset = .init(top: 30, left: 0, bottom: 0, right: 0)
        cltV.backgroundColor = .red
    }
    
    var curChoiceDate: (day: Int, month: Int, year: Int)?
    
    //set date
    func setDateToRender(date: Date) {
        let dateComp = calendar.dateComponents([.month, .year], from: date)
        guard let month = dateComp.month, let year = dateComp.year else { return }
        self.monthYearInfo = (month, year)
        self.cltV.reloadData()
    }
    func setMonthYearToRender(month: Int, year: Int) {
        self.monthYearInfo = (month, year)
        self.cltV.reloadData()
    }
    func getMonthMetaData(month: Int, year: Int) throws -> MonthMetaData {
        var dateComponent = DateComponents()
        dateComponent.month = month
        dateComponent.year = year
        dateComponent.day = 1
        
        guard let date = calendar.date(from: dateComponent),
              let numberOfDay = calendar.range(of: .day, in: .month, for: date)?.count
        else { fatalError("Error in date data") }
        let weekDay = calendar.component(.weekday, from: date)
        //last weekday
        dateComponent.day = numberOfDay
        guard let lastDate = calendar.date(from: dateComponent)
        else { fatalError("Error in date data") }
        
        let lastWeekDay = calendar.component(.weekday, from: lastDate)
        return .init(monthNumber: month, numberOfDay: numberOfDay, firstWeekDay: weekDay, lastWeekDay: lastWeekDay)
    }
    var monthYearInfo: (month: Int, year: Int) = (2,2021) {
        didSet {
            monthInfo = try! getMonthMetaData(month: monthYearInfo.month, year: monthYearInfo.year)
            arrDays = (1...monthInfo.numberOfDay).map { $0 }
            for weekDayIndex in (1...7) {
                if monthInfo.firstWeekDay == weekDayIndex {
                    break
                }
                print("\(monthInfo.firstWeekDay) \(weekDayIndex)")
                arrDays = [0] + arrDays
            }
            if monthInfo.lastWeekDay != 7 {
                for index in (1...7) {
                    if (index > monthInfo.lastWeekDay) {
                        arrDays += [0]
                    }
                }
            }
        }
    }
    var monthInfo: MonthMetaData!
    var arrDays: [Int] = []

    private func isDateComp(_ dc1: DateComponents, beforeDateComponent dc2: DateComponents) -> Bool {
//        let dc2 = calendar.dateComponents([.day, .month, .year], from: Date())
        if dc1.year! > dc2.year! { return false}
        else if dc1.year! < dc2.year! { return true}
        else {
            if dc1.month! > dc2.month! { return false }
            else if dc1.month! < dc2.month! { return true}
            else { return dc1.day! < dc2.day! }
        }
    }

    private func isDayBeforeToDay(day: Int, month: Int, year: Int) -> Bool {
        let nowComp = calendar.dateComponents([.day, .month,.year], from: Date())
        var customComponent = DateComponents()
        customComponent.day = day; customComponent.month = month; customComponent.year = year
        return isDateComp(customComponent, beforeDateComponent: nowComp)
    }
}

extension OneMonthView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CalendarItemCltVCell.self, indexPath: indexPath)
        let day = arrDays[indexPath.row]
        cell.setData(text: day == 0 ? "" : "\(day)")

        if let curMYChoice = self.curChoiceDate,
           curMYChoice.month == monthYearInfo.month,
           curMYChoice.year == monthYearInfo.year,
           curMYChoice.day == arrDays[indexPath.row]{
            cell.setHighlight(isEnable: true)
        } else {
            cell.setHighlight(isEnable: false)
            
            var cellDateComponent = DateComponents()
            cellDateComponent.day = arrDays[indexPath.row]; cellDateComponent.month = monthYearInfo.month; cellDateComponent.year = monthYearInfo.year
            
            var choiceDateComponent = DateComponents()
            if let choice = curChoiceDate {
                choiceDateComponent.day = choice.day
                choiceDateComponent.month = choice.month
                choiceDateComponent.year = choice.year
            }

            let isDayBefore = isDayBeforeToDay(day: arrDays[indexPath.row], month: monthYearInfo.month, year: monthYearInfo.year)
                || isDateComp(cellDateComponent, beforeDateComponent: choiceDateComponent)
            cell.setPassedDay(isDayBefore)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = arrDays[indexPath.row]
        if var curChoiceDate = curChoiceDate {
            curChoiceDate.day = day
            curChoiceDate.month = monthYearInfo.month
            curChoiceDate.year = monthYearInfo.year
            print(curChoiceDate)
            NotificationCenter.default.post(name: .dateChoice, object: nil, userInfo: [
                "data": curChoiceDate
            ])
        }
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let day = arrDays[indexPath.row]
        let month = monthYearInfo.month
        let year = monthYearInfo.year
        if day == 0 { return false }
        return !isDayBeforeToDay(day: day, month: month, year: year)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

extension OneMonthView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return .init(width: self.frame.width / 7.0, height: 40)
        return .init(width: 30, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

struct MonthMetaData {
    var monthNumber: Int
    var numberOfDay: Int
    var firstWeekDay: Int
    var lastWeekDay: Int
}

enum DayOfWeek {
    case mon, tue, web, thu, fri, sat, sun
}

extension NSNotification.Name {
    static var dateChoice: NSNotification.Name = .init(rawValue: "date_choice")
}
