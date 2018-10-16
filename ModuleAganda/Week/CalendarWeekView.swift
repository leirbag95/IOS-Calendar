//
//  CalendarWeekView.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 02/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarWeekView: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var calendar_collectionView: JTAppleCalendarView!
    
    
    
    //MARK: var
    let formatter = DateFormatter()
    let grayColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar_collectionView.scrollDirection = .horizontal
        
        //Scroll to current date
        calendar_collectionView.scrollToDate(Date())
        
        /* First Initialisation */
        calendar_collectionView.minimumLineSpacing = 0
        calendar_collectionView.minimumInteritemSpacing = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calendar_collectionView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            self.formatter.dateFormat = "MMMM"
            let vc = self.parent as! Agenda
            vc.lbl_month.title = self.formatter.string(from: date)
            self.formatter.dateFormat = "yyyy"
            vc.lbl_year.title = self.formatter.string(from: date)
        }
    }
    
    func handleCellCurrentDay(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCellWeek else { return }
        
        let currentDay = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        
        let currentDateString = dateFormatter.string(from: currentDay)
        let cellStateDateString = dateFormatter.string(from: cellState.date)
        
        /*On entoure la date du jour par un cercle rouge*/
        if  currentDateString ==  cellStateDateString {
            validCell.lbl_date.layer.masksToBounds = true
            validCell.lbl_date.backgroundColor = UIColor.red
            validCell.lbl_date.layer.cornerRadius = 10
            validCell.lbl_date.textColor = UIColor.white
        } else {
            validCell.lbl_date.backgroundColor = UIColor.clear
            validCell.lbl_date.textColor = UIColor.black
        }
    }
    
}

extension CalendarWeekView : JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        /*Set segment Control on Day Segment (0) and date*/
        let vc = self.parent as! Agenda
        vc.segmentControl.selectedSegmentIndex = 0
        vc.week_view.isHidden = true
        vc.day_view.isHidden = false
        
        let vday = vc.children[0] as! CalendarDayView
        formatter.dateFormat = "EEEE-dd-MMMM yyyy"
        var currentDate = formatter.string(from: date)
        vday.currentDate = date
        vday.labelDayName.text = currentDate.components(separatedBy: "-").first
        vday.labelDayNumber.text = currentDate.components(separatedBy: "-")[1]
        vday.labelYear.text = currentDate.components(separatedBy: "-")[2]
                
        vday.initialiseArrayByIndex(currentEventArray)

    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!, numberOfRows: 1, calendar: Calendar.current, generateInDates: .forFirstMonthOnly, generateOutDates: .off, firstDayOfWeek: .monday, hasStrictBoundaries: false)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCellWeek", for: indexPath) as! CustomCellWeek
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        cell.lbl_date.text = cellState.text
        
        /*Gray Saturday and Sunday days*/
        if cellState.day == .sunday || cellState.day == .saturday {
            cell.backgroundColor = grayColor
            cell.tableview.backgroundColor = grayColor
        } else {
            cell.backgroundColor = .white
            cell.tableview.backgroundColor = .white
        }
        
        /*For date from tableview*/
        cell.date = date
        cell.tableview.reloadData()
        
        handleCellCurrentDay(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "MMMM"
        let vc = self.parent as!Agenda
        vc.lbl_month.title = self.formatter.string(from: date)
        self.formatter.dateFormat = "yyyy"
        vc.lbl_year.title = self.formatter.string(from: date)

    }
}
