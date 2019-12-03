//
//  EventTypeTableViewController.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 25/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit

class EventTypeTableViewController: UITableViewController {

    // MARK: - Tableview data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            typeEvent = .calendar
        } else {
            switch indexPath.row {
            case 0:
                typeEvent = .ferie
            case 1:
                typeEvent = .outlook
            case 2:
                typeEvent = .autre
            default:
                break
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

}
