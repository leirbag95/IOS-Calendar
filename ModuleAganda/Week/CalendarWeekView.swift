//
//  CalendarDayView.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 08/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit
import KVKCalendar

class CalendarWeekView: UIViewController {
    
    //MARK: public var
    public var strDate:String = String()
    public var currentDate:Date = Date()
    var eventArrayByIndex:[CalendarEvent] = []
    
    //MARK: const let
    let formatter = DateFormatter()
    let cellId = "cell"
    let rotationAngle:CGFloat = 90
    
    public var events = [Event]()
       
    private var selectDate: Date = {
        return Date()
    }()
       
       
    public lazy var calendarView: CalendarView = {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.monthStyle.isHiddenSeporator = true
            style.timelineStyle.widthTime = 40
            style.timelineStyle.offsetTimeX = 2
            style.timelineStyle.offsetLineLeft = 2
        } else {
            style.timelineStyle.widthEventViewer = 500
        }
        style.followInInterfaceStyle = true
        style.timelineStyle.offsetTimeY = 80
        style.timelineStyle.offsetEvent = 3
        style.timelineStyle.currentLineHourWidth = 40
        style.allDayStyle.isPinned = true
        style.startWeekDay = .monday
        style.timeHourSystem = .twentyFourHour
           
        let calendar = CalendarView(frame: view.frame, date: selectDate, style: style)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "EEEE-dd-MMMM yyyy"
        strDate = formatter.string(from: currentDate)
        calendarView.set(type: .week, date: Date())
        view.addSubview(calendarView)
    }
}

extension CalendarWeekView {
    /**
     Charge tous les evenements depuis Realm
     */
    func loadEvents(_ ev:[Event] = []) {
//        for calEvent in realm.objects(CalendarEvent.self).filter("_codeVRP == %@", currentCommercial) {
        for (_, calendar) in currentEventArray {
            for calEvent in calendar {
                let startDate = self.formatter(date: calEvent.start)
                let endDate = self.formatter(date: calEvent.end)
                    
                var event = Event()
                event.id = calEvent.id
                //Color
                event.color = EventColor(UIColor.purple)
                event.colorText = .white
                // Date & content
                event.start = startDate
                event.end = endDate
                event.isAllDay = calEvent.allDay
                event.textForMonth = calEvent.nomEvent
                event.text = "\(calEvent.nomEvent)"
                self.events.append(event)
            }
        }
//        }
        self.calendarView.reloadData()
    }
    
    func formatter(date: String) -> Date {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
           return formatter.date(from: date) ?? Date()
       }
}

extension CalendarWeekView: CalendarDelegate {
    func didSelectDate(date: Date?, type: CalendarType, frame: CGRect?) {
        selectDate = date ?? Date()
        calendarView.reloadData()
    }
}

extension CalendarWeekView: CalendarDataSource {
    func eventsForCalendar() -> [Event] {
        return events
    }
}

