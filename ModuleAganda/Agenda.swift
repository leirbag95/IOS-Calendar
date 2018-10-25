//
//  ViewController.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 02/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit
import EventKit

/*
 *
 *NOTE :
 * 
 */

class Agenda: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var week_view: UIView!
    @IBOutlet weak var month_view: UIView!
    @IBOutlet weak var day_view: UIView!
    @IBOutlet weak var lbl_month: UIBarButtonItem!
    @IBOutlet weak var lbl_year: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Navigation bar*/
        initNavigationController()
        /*Calendar event*/
        initCalendarFromEKEventStore()

    }
    
    
    //MARK: private
    
    private func initCalendarFromEKEventStore() {
        /*Initialise le calendrier avec des dates du calendrier d'apple*/
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (isAccept, _) in
            if isAccept {
                let calendars = eventStore.calendars(for: .event)
                
                for calendar in calendars {
                    let oneYearAgo = Date(timeIntervalSinceNow: -365*24*3600)
                    let oneYearAfter = Date(timeIntervalSinceNow: +365*24*3600)
                    let predicate = eventStore.predicateForEvents(withStart: oneYearAgo, end: oneYearAfter, calendars: [calendar])
                    let events = eventStore.events(matching: predicate)
                    for event in events {
                        let ev = Event()
                        let formatter = DateFormatter()
                        ev.title = event.title
                        //On adapte le type de l'evenement au calendrier
                        switch calendar.title {
                            case "Jours fériés français":
                                ev.type = .ferie
                            case "Found in Mail":
                                ev.type = .outlook
                            default:
                                ev.type = .autre
                        }
                        formatter.dateFormat = "yyyy dd MMMM,HH:mm"
                        ev.dateBegin = formatter.string(from: event.startDate)
                        ev.dateEnd = formatter.string(from: event.endDate)
                        formatter.dateFormat = "EEEE dd MMMM"
                        let tmpDateIndex = formatter.string(from: event.startDate)
                        if currentEventArray[tmpDateIndex] != nil {
                            currentEventArray[tmpDateIndex]?.append(ev)
                        } else {
                            currentEventArray[tmpDateIndex] = [ev]
                        }
                    }
                }
            }
        }
    }
    private func initNavigationController() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    //MARK:IBAction
    
    @IBAction func ScrollToCurrentDay(_ sender: UIBarButtonItem) {
        /*Aujourd'hui item*/
        
        var destinationController:CalendarWeekView = CalendarWeekView()
        destinationController = self.children[1] as! CalendarWeekView
        destinationController.calendar_collectionView.scrollToDate(Date())
        
        var destinationController2 = CalendarMonthView()
        destinationController2 = self.children[2] as! CalendarMonthView
        destinationController2.calendar_collectionview.scrollToDate(Date())
        
        var destinationController3 = CalendarDayView()
        destinationController3 = self.children[0] as! CalendarDayView
        let formater = DateFormatter()
        formater.dateFormat = "EEEE-dd-MMMM yyyy"
        var currentDate = formater.string(from: Date())
        destinationController3.labelDayName.text = currentDate.components(separatedBy: "-").first
        destinationController3.labelDayNumber.text = currentDate.components(separatedBy: "-")[1]
        destinationController3.labelYear.text = currentDate.components(separatedBy: "-")[2]
        destinationController3.currentDate = Date()
        destinationController3.initialiseArrayByIndex(currentEventArray)
    
    }
    
    @IBAction func SelectCalendarMode(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
        case 0:
            week_view.isHidden = true
            month_view.isHidden = true
            day_view.isHidden = false
        case 1:
            week_view.isHidden = false
            month_view.isHidden = true
            day_view.isHidden = true
        case 2:
            week_view.isHidden = true
            month_view.isHidden = false
            day_view.isHidden = true
            
        default:
            debugPrint("Error ViewController with Segmented")
        }
    }
    
}

