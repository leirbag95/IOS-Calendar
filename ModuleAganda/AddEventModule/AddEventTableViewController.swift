//
//  AddEventTableViewController.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 08/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit

//Type Protocol
var typeEvent:TypeCalendar = .calendar


class AddEventTableViewController: UITableViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var switchAllDay: UISwitch!
    @IBOutlet weak var dateBegin: UIDatePicker!
    @IBOutlet weak var dateEnd: UIDatePicker!
    @IBOutlet weak var txt_comment: UITextField!
    @IBOutlet weak var lblDateBegin: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    @IBOutlet weak var lbl_type: UILabel!
    
    //MARK: - var
    var indexSelected = -1
    /**
     Destiné au appliquer une action liée au popover
     */
    var delegateDateProtocol:DateProtocol?
    
    //MARK: - let
    let hourInSec = TimeInterval(3600)
    let dayInSec = 86400
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //First Settings
        formatter.dateFormat = "EEEE dd MMMM, HH:mm"
        lblDateBegin.text = formatter.string(from: Date())
        dateBegin.date = Date()
        lblDateEnd.text = formatter.string(from: Date() + hourInSec)
        dateEnd.date = dateBegin.date + hourInSec
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lbl_type.text = typeEvent.rawValue
    }
    
    //MARK: - IBAction
    
    @IBAction func dismissCurrentView(_ sender:UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddEvent(_ sender: UIBarButtonItem) {
        if !txt_title.text!.isEmpty {
            let event = CalendarEvent()
            event.typeEvent = typeEvent.rawValue
            event.nomEvent = txt_title.text!
            event.commentaire = txt_comment.text!
            event.allDay = switchAllDay.isOn
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            event.start = formatter.string(from: dateBegin.date)
            event.end = formatter.string(from: dateEnd.date)
            //Ce formatter nous permettera d'acceder par la suite au elements du dictionnaire
            formatter.dateFormat = "dd/MM/yyyy"
            let refDateBegin = formatter.string(from: dateBegin.date)
            if let _ = currentEventArray[refDateBegin] {
                currentEventArray[refDateBegin]?.append(event)
            } else {
                currentEventArray[refDateBegin] = [event]
            }
            delegateDateProtocol?.dismissDateProtocol(event: event)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Impossible d'ajouter l'évenement", message: "Information(s) manquante(s).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func didChangeBeginDate(_ sender: UIDatePicker) {
        lblDateBegin.text = formatter.string(from: sender.date)
        if switchAllDay.isOn {
            //si un jour entier est activé
            lblDateEnd.text = formatter.string(from: sender.date)
        }
        
        dateEnd.date = dateBegin.date + hourInSec
        lblDateEnd.text = formatter.string(from: sender.date + hourInSec)
    }
    
    @IBAction func didChangeEndDate(_ sender: UIDatePicker) {
        lblDateEnd.text = formatter.string(from: sender.date)
    }
    
    /**
     Si on selectionne la journée
     */
    @IBAction func didValueSwitched(_ sender: UISwitch) {
        if sender.isOn {
            formatter.dateFormat = "EEEE dd MMMM"
            dateBegin.datePickerMode = .date
            dateEnd.datePickerMode = .date
            dateBegin.date = dateBegin.calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            dateEnd.date = dateEnd.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
            lblDateEnd.text = formatter.string(from: Date())
        } else {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateBegin.datePickerMode = .dateAndTime
            dateEnd.datePickerMode = .dateAndTime
            dateBegin.date = Date()
            dateEnd.date = dateBegin.date + hourInSec
            lblDateEnd.text = formatter.string(from: Date() + hourInSec)
        }
        lblDateBegin.text = formatter.string(from: Date())
        //Hide End Date
        indexSelected = -1
        tableView.reloadData()
    }
    
    //MARK: - private function

    
    private func convertStringToDate(_ date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:date)!
        
        return date
    }
    
    //MARK:  - Tableview functions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Select date begin
        if indexPath.section == 1 && indexPath.row == 1 {
            indexSelected = indexPath.row + 1
        } else if indexPath.section == 1 && indexPath.row == 3 && !switchAllDay.isOn {
            indexSelected = indexPath.row + 1
        } else {
            indexSelected = -1
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Set height of cell for date picker
        if indexSelected == indexPath.row && indexPath.section == 1 {
            return 180
        } else if (indexPath.row == 2 || indexPath.row == 4)  && indexPath.section == 1 {
            return 0
        } else if indexPath.section == 3  {
            //for comment
            return 150
        }
        return 44
    }
}
