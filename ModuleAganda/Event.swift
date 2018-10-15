//
//  Event.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 09/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import Foundation

class Event {
    
    private var _id : Int = 0
    private var _title : String = ""
    private var _type : String = ""
    private var _dateBegin:String?
    private var _dateEnd:String?
    private var _comment:String = ""
    
    var id:Int {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var title:String {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var type:String {
        get {
            return _type
        }
        set {
            _type = newValue
        }
    }
    
    var dateBegin:String {
        get {
            return _dateBegin!
        }
        set {
            _dateBegin = newValue
        }
    }
    
    var dateEnd:String {
        get {
            return _dateEnd!
        }
        set {
            _dateEnd = newValue
        }
    }
    
    var comment:String {
        get {
            return _comment
        }
        set {
            _comment = newValue
        }
    }
}
