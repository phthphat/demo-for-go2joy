//
//  FullCalendarView.swift
//  InstaClone
//
//  Created by Phat Pham on 19/02/2021.
//

import UIKit

class FullCalendarView: BaseXibView {
    
    @IBOutlet weak var cltV: UICollectionView!
    private var calendar = Calendar(identifier: .gregorian)
    
    var dateInfo: DateComponents!
    
    private var subscription: Any?
    
    override func initView() {
        cltV.backgroundColor = .red

        cltV.registerXibCell(OneMonthCalendarCltVCell.self)
        cltV.isPagingEnabled = true
        if let layout = cltV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        let nowDate = Date()
        let nowComponent = calendar.dateComponents([.day, .month, .year], from: nowDate)
        if let day = nowComponent.day, let month = nowComponent.month, let year = nowComponent.year {
            currentChoice = (day, month, year)
        }
        monthArr = (-60...60).map { dateComp(nowDate, withAddingMonthValue: $0) }
        cltV.reloadData()
        cltV.layoutIfNeeded()
        cltV.scrollToItem(at: IndexPath(row: 60, section: 0), at: .top, animated: false)
        //Notification
        subscription  = NotificationCenter.default.addObserver(forName: .dateChoice, object: nil, queue: .main) { [unowned self] noti in
//            print("observed notification \(noti.userInfo)")
            if let userInfo = noti.userInfo, let data = userInfo["data"] as? (day: Int, month: Int, year: Int) {
                self.currentChoice = data
                self.cltV.reloadData()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(subscription as Any)
    }
    
    fileprivate var currentChoice: (day: Int, month: Int, year: Int)!
    
    private var monthDistance = 2
    
    private func dateComp(_ date: Date, withAddingMonthValue value: Int) -> DateComponents {
        guard let preDate = calendar.date(byAdding: .month, value: value, to: date) else { fatalError("Nothing") }
        return calendar.dateComponents([.day, .month, .year], from: preDate)
    }
    
    var monthArr: [DateComponents] = []
}

extension FullCalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        monthArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(OneMonthCalendarCltVCell.self, indexPath: indexPath)
        let data = monthArr[indexPath.row]
        if let month = data.month, let year = data.year {
            cell.setMonthYearToRender(month: month, year: year)
        } else {
            print("Invalid")
        }
        cell.setCurDateChoice(
            day: currentChoice.day,
            month: currentChoice.month,
            year: currentChoice.year
        )
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("Indexpath: \(indexPath.row) monthArr \(self.monthArr.count)")
//        guard indexPath.row == self.monthArr.count - 1 else { return }
//        monthDistance += 1
//        self.monthArr += [dateComp(Date(), withAddingMonthValue: monthDistance)]
//        print("ahihi \(monthDistance) \(self.monthArr.count)")
//        cltV.reloadData()
//    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("End displaying \(indexPath.row)")
    }
}

extension FullCalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.frame.width, height: self.frame.height)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        <#code#>
//    }
}
