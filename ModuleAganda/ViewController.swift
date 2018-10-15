//
//  ViewController.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 02/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit

/*
 *
 *NOTE :
 * https://www.youtube.com/watch?v=Qd_Gc67xzlw
 */

class ViewController: UIViewController {
    
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

