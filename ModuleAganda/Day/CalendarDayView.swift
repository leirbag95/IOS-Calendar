//
//  CalendarDayView.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 08/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import UIKit


class CalendarDayView: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var labelDayName: UILabel!
    @IBOutlet weak var labelDayNumber: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var calendar_collectionview: UICollectionView!
    @IBOutlet weak var viewDetails: UIView!
    
    //MARK: public var
    public var strDate:String = String()
    public var currentDate:Date = Date()
    var eventArrayByIndex:[Event] = []
    
    //MARK: const let
    let formatter = DateFormatter()
    let cellId = "cell"
    let rotationAngle:CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar_collectionview.delegate = self
        calendar_collectionview.dataSource = self
        
        formatter.dateFormat = "EEEE-dd-MMMM yyyy"
        strDate = formatter.string(from: currentDate)
        labelDayName.text = strDate.components(separatedBy: "-").first
        labelDayNumber.text = strDate.components(separatedBy: "-")[1]
        labelYear.text = strDate.components(separatedBy: "-")[2]
        
        initialiseArrayByIndex(currentEventArray)
        
    }
    
    //MARK: public
    public func initialiseArrayByIndex(_ cEventArray: [String:[Event]]) {
       
        viewDetails.isHidden = true
        eventArrayByIndex = []
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE dd MMMM"
        let strDate = formatter.string(from: currentDate)
        
        if let arrayEvent = cEventArray[strDate] {
            eventArrayByIndex = arrayEvent
        }
        calendar_collectionview.reloadData()
    }
    
    //MARK: IBAction
    
   
}

extension CalendarDayView : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDetails.isHidden = false
        
        var detailCalendar:CalendarDetailTableViewController = self.children.last as!  CalendarDetailTableViewController
        let eventSelected = eventArrayByIndex[indexPath.row]
        detailCalendar.lbl_type.text = eventSelected.type.rawValue
        detailCalendar.lbl_title.text = eventSelected.title
        detailCalendar.lbl_dateBegin.text = eventSelected.dateBegin
        detailCalendar.lbl_dateEnd.text = eventSelected.dateEnd
        detailCalendar.lbl_note.text = eventSelected.comment
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventArrayByIndex.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomDayCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMMM"
        let strDate = formatter.string(from: currentDate)
        
        cell.lbl_title.text = eventArrayByIndex[indexPath.row].title
        cell.lbl_h1.text = eventArrayByIndex[indexPath.row].dateBegin.components(separatedBy: ",").last
        cell.lbl_h2.text = eventArrayByIndex[indexPath.row].dateEnd.components(separatedBy: ",").last
        return cell
    }
    
    
}

