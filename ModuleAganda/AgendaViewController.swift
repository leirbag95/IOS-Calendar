//
//  ViewController.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 02/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit
import EventKit
import KVKCalendar

/*
 *
 *NOTE :
 * 
 */

class AgendaViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var week_view: UIView!
    @IBOutlet weak var month_view: UIView!
    @IBOutlet weak var day_view: UIView!
    @IBOutlet weak var lbl_month: UIBarButtonItem!
    @IBOutlet weak var lbl_year: UIBarButtonItem!
    @IBOutlet weak var btn_addEvent: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_addEvent.addTarget(self, action: #selector(presentAsPopOver), for: .touchUpInside)
       
        
        /*Navigation bar*/
        initNavigationController()
        /*Calendar event*/
        initCalendarFromEKEventStore()
    }
    
    
    //MARK: private functions
    
    private func initCalendarFromEKEventStore() {
        /*Initialise le calendrier avec des dates du calendrier d'apple*/
        let eventStore = EKEventStore()
        
        let queue = DispatchGroup()
        queue.enter()
        eventStore.requestAccess(to: .event) { (isAccept, _) in
            if isAccept {
                let calendars = eventStore.calendars(for: .event)
                for calendar in calendars {
                    let oneYearAgo = Date(timeIntervalSinceNow: -365*24*3600)
                    let oneYearAfter = Date(timeIntervalSinceNow: +365*24*3600)
                    let predicate = eventStore.predicateForEvents(withStart: oneYearAgo, end: oneYearAfter, calendars: [calendar])
                    let events = eventStore.events(matching: predicate)
                    for event in events {
                        let ev = CalendarEvent()
                        let formatter = DateFormatter()
                        ev.nomEvent = event.title
                        //On adapte le type de l'evenement au calendrier
                        if calendar.title == "Jours fériés français" {
                            ev.typeEvent = TypeCalendar.ferie.rawValue
                        } else if calendar.title == "Found in Mail" {
                            ev.typeEvent = TypeCalendar.outlook.rawValue
                        } else {
                            ev.typeEvent = TypeCalendar.autre.rawValue
                        }
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        ev.start = formatter.string(from: event.startDate)
                        ev.end = formatter.string(from: event.endDate)
                        ev.allDay = true
                        formatter.dateFormat = "dd/MM/yyyy"
                        let tmpDateIndex = formatter.string(from: event.startDate)
                        if currentEventArray[tmpDateIndex] != nil {
                            currentEventArray[tmpDateIndex]?.append(ev)
                        } else {
                            currentEventArray[tmpDateIndex] = [ev]
                        }
                    }
                }
            }
            queue.leave()
        }
        
        queue.notify(queue: DispatchQueue.main) {
            // on reload les calendar Week et Day
            var destinationController:CalendarWeekView = CalendarWeekView()
            destinationController = self.children[1] as! CalendarWeekView
            destinationController.loadEvents()
            destinationController.calendarView.reloadData()
            
            var destinationController3 = CalendarDayView()
            destinationController3 = self.children[0] as! CalendarDayView
            destinationController3.loadEvents()
            destinationController3.calendarView.reloadData()
        }
    }
    
    /**
     Design de la navigation bar
     */
    private func initNavigationController() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    //MARK: - IBAction
    
    @IBAction func ScrollToCurrentDay(_ sender: UIBarButtonItem) {
        /*Aujourd'hui item*/
        
        var destinationController:CalendarWeekView = CalendarWeekView()
        destinationController = self.children[1] as! CalendarWeekView
        destinationController.calendarView.scrollToDate(date: Date())
        
        var destinationController2 = CalendarMonthView()
        destinationController2 = self.children[2] as! CalendarMonthView
        destinationController2.calendar_collectionview.scrollToDate(Date())
        
        var destinationController3 = CalendarDayView()
        destinationController3 = self.children[0] as! CalendarDayView
        destinationController3.calendarView.scrollToDate(date: Date())
    
    }
    
    @IBAction func SelectCalendarMode(_ sender: UISegmentedControl) {
        day_view.isHidden = !(sender.selectedSegmentIndex == 0)
        week_view.isHidden = !(sender.selectedSegmentIndex == 1)
        month_view.isHidden = !(sender.selectedSegmentIndex == 2)
    }
}

protocol DateProtocol {
    func dismissDateProtocol(event:CalendarEvent)
}

extension AgendaViewController: UIPopoverPresentationControllerDelegate, DateProtocol {

    
    func dismissDateProtocol(event: CalendarEvent) {
        // une fois l'événement crée, on reload les calendriers
        var destinationController:CalendarWeekView = CalendarWeekView()
        destinationController = self.children[1] as! CalendarWeekView
        var destinationController2 = CalendarMonthView()
        destinationController2 = self.children[2] as! CalendarMonthView
        var destinationController3 = CalendarDayView()
        destinationController3 = self.children[0] as! CalendarDayView
        
        let startDate = destinationController.formatter(date: event.start)
        let endDate = destinationController.formatter(date: event.end)
            
        var ev = Event()
        ev.id = event.id
        //Color
        ev.color = EventColor(UIColor.purple)
        ev.colorText = .white
        // Date & content
        ev.start = startDate
        ev.end = endDate
        ev.isAllDay = event.allDay
        ev.textForMonth = event.nomEvent
        ev.text = "\(event.nomEvent)"

        destinationController.events.append(ev)
        destinationController.calendarView.reloadData()
        destinationController2.calendar_collectionview.reloadData()
        destinationController3.events.append(ev)
        destinationController3.calendarView.reloadData()
    }
    
    @objc func presentAsPopOver(_ sender:UIButton) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "addEvent") as! AddEventTableViewController
        
         let nav = UINavigationController(rootViewController: popoverContent)
         nav.modalPresentationStyle = UIModalPresentationStyle.popover
         let popover = nav.popoverPresentationController
         popover?.delegate = self
         popoverContent.delegateDateProtocol = self
        if sender.tag == 0 {
            popover?.permittedArrowDirections = .up
        } else if sender.tag == 1 {
            popover?.permittedArrowDirections = .right
//            popoverContent.currentEvent = currentEventSelection
        }
         popover?.sourceView = sender
         popover?.sourceRect = sender.bounds
         
         self.present(nav, animated: true, completion: nil)
    }
        
}
