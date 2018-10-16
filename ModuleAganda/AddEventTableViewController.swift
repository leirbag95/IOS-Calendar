//
//  AddEventTableViewController.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 08/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit

class AddEventTableViewController: UITableViewController {

    //MARK: IBOutlet
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var switchAllDay: UISwitch!
    @IBOutlet weak var dateBegin: UIDatePicker!
    @IBOutlet weak var dateEnd: UIDatePicker!
    @IBOutlet weak var txt_comment: UITextField!
    @IBOutlet weak var lblDateBegin: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    
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
   
    
    //MARK: IBAction
    @IBAction func AddEvent(_ sender: UIBarButtonItem) {
        if !txt_title.text!.isEmpty {
            let event = Event()
            event.type = .calendar
            event.title = txt_title.text!
            /*
            * You have to check if there is no event
            * all the day before
            */
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
    
    
    @IBAction func didValueSwitched(_ sender: UISwitch) {
        if sender.isOn {
            formatter.dateFormat = "EEEE dd MMMM"
            dateBegin.datePickerMode = .date
            dateEnd.datePickerMode = .date
            lblDateEnd.text = formatter.string(from: Date())
        } else {
            formatter.dateFormat = "EEEE dd MMMM,HH:mm"
            dateBegin.datePickerMode = .dateAndTime
            dateEnd.datePickerMode = .dateAndTime
            lblDateEnd.text = formatter.string(from: Date() + hourInSec)
            dateEnd.date = dateBegin.date + hourInSec
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

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
