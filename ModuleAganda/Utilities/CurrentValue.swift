//
//  CurrentValue.swift
//  ModuleAganda
//
//  Created by Gabriel Elfassi on 09/10/2018.
//  Copyright © 2018 Gabriel Elfassi. All rights reserved.
//

import Foundation
import UIKit

//MAIN
var currentEventArray:[String:[CalendarEvent]] = [:]

enum TypeCalendar : String {
    case calendar = "Calendrier"
    case ferie = "Jour Férié"
    case outlook = "Outlook"
    case autre = "Autre"
}
