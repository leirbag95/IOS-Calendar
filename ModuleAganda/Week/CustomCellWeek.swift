//
//  CustomCell.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 02/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import Foundation
import JTAppleCalendar

class CustomCellWeek : JTAppleCell {
    
    //MARK: IBOutlet
    @IBOutlet weak var lbl_date:UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: public var
    var date:Date?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
}

extension CustomCellWeek : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMMM"
        let strDate = formatter.string(from: date!)
        
        if let arrayEvent = currentEventArray[strDate] {
            return arrayEvent.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMMM"
        let strDate = formatter.string(from: date!)
        if let arrayEvent = currentEventArray[strDate] {
            let event = arrayEvent[indexPath.row]
            cell.textLabel?.text = event.nomEvent
            if event.typeEvent == TypeCalendar.autre.rawValue {
                cell.backgroundColor = .green
            } else if event.typeEvent == TypeCalendar.ferie.rawValue {
                cell.backgroundColor = .purple
            } else if event.typeEvent == TypeCalendar.outlook.rawValue {
                cell.backgroundColor = .blue
            } else {
                cell.backgroundColor = UIColor(red: 91/255, green: 184/255, blue: 228/255, alpha: 1)
            }
        }
        return cell
    }

}
