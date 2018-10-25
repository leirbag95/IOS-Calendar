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

    //MARK: IBOutlet
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var switchAllDay: UISwitch!
    @IBOutlet weak var dateBegin: UIDatePicker!
    @IBOutlet weak var dateEnd: UIDatePicker!
    @IBOutlet weak var txt_comment: UITextField!
    @IBOutlet weak var lblDateBegin: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    @IBOutlet weak var lbl_type: UILabel!
    
    //MARK: private var
    var indexSelected = -1
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
    
    //MARK: private func
    override func viewWillAppear(_ animated: Bool) {
        lbl_type.text = typeEvent.rawValue
    }
    
    //MARK: IBAction
    
    @IBAction func dismissCurrentView(_ sender:UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddEvent(_ sender: UIBarButtonItem) {
        if !txt_title.text!.isEmpty {
            let event = Event()
            event.type = typeEvent
            event.title = txt_title.text!
            event.comment = txt_comment.text!
            
            formatter.dateFormat = "yyyy dd MMMM,HH:mm"
            event.dateBegin = formatter.string(from: dateBegin.date)
            event.dateEnd = formatter.string(from: dateEnd.date)
            //Ce formatter nous permettera d'acceder par la suite au elements du dictionnaire
            formatter.dateFormat = "EEEE dd MMMM"
            if !isEventExist() {
                let refDateBegin = formatter.string(from: dateBegin.date)
                if let _ = currentEventArray[refDateBegin] {
                    currentEventArray[refDateBegin]?.append(event)
                } else {
                    currentEventArray[refDateBegin] = [event]
                }
                dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Impossible d'ajouter l'évenement", message: "Les dates choisies existent déjà.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
                present(alert, animated: true, completion: nil)
            }
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
    
    //Si on selectionne la journée
    @IBAction func didValueSwitched(_ sender: UISwitch) {
        if sender.isOn {
            formatter.dateFormat = "EEEE dd MMMM"
            dateBegin.datePickerMode = .date
            dateEnd.datePickerMode = .date
            dateBegin.date = dateBegin.calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
            dateEnd.date = dateEnd.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
            lblDateEnd.text = formatter.string(from: Date())
        } else {
            formatter.dateFormat = "EEEE dd MMMM,HH:mm"
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
    
    //MARK: private
    private func isEventExist() -> Bool {
        let refDateBegin = formatter.string(from: dateBegin.date)
        if let events = currentEventArray[refDateBegin] {
            for event in events {
                
                let dateBeginFromString = convertStringToDate(event.dateBegin)
                let dateEndFromString = convertStringToDate(event.dateEnd)
                
                let case1 = dateBegin.date >= dateBeginFromString && dateEnd.date <= dateEndFromString
                let case2 = dateBegin.date <= dateBeginFromString && dateEnd.date <= dateEndFromString && dateEnd.date > dateBeginFromString
                let case3 = dateBegin.date >= dateBeginFromString && dateBegin.date < dateEndFromString && dateEnd.date >= dateEndFromString
                let case4 = dateBegin.date <= dateBeginFromString  && dateEnd.date >= dateEndFromString
                print(case1, case2, case3, case4)
                return case1 || case2 || case3 || case4
            }
        }
        return false
    }
    
    private func convertStringToDate(_ date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy dd MMMM,HH:mm"
        let date = dateFormatter.date(from:date)!
        
        return date
    }
    
    
    //MARK: tableview function
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
