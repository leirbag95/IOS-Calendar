import UIKit
import JTAppleCalendar

class CustomMonthCell: JTAppleCell, UITableViewDataSource, UITableViewDelegate {
    
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
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMMM"
        let strDate = formatter.string(from: date!)
        if let arrayEvent = currentEventArray[strDate] {
            let event = arrayEvent[indexPath.row]
            cell.textLabel?.text = event.title
            switch event.type {
            case .autre:
                cell.backgroundColor = .green
            case .ferie:
                cell.backgroundColor = .purple
            case .outlook:
                cell.backgroundColor = .blue
            case .calendar: break
                //Nothing
            }
        } else {
            //cell.textLabel?.text = ""
        }
        return cell
    }
    
}
