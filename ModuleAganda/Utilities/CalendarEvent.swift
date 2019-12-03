//
//  CalendarEvent.swift
//  IsoSales-PreProd
//
//  Created by Axel Fabre on 06/11/2019.
//  Copyright © 2019 Isotoner. All rights reserved.
//

import Foundation
//import RealmSwift

class CalendarEvent {
    
    @objc private dynamic var _id:String = String() //Concaténation de plusieurs propriété
    @objc private dynamic var _typeEvent = String() //Si plusieurs évènements, séparé par un @
    @objc private dynamic var _nomEvent = String()
    @objc private dynamic var _saison = String()
    /**Date de début*/
    @objc private dynamic var _start = String()
    /**Date de fin*/
    @objc private dynamic var _end = String()
    @objc private dynamic var _allDay = Bool()
    @objc private dynamic var _codeVRP = String()
    @objc private dynamic var _codeInvite = String()
    @objc private dynamic var _tiers = String()
    @objc private dynamic var _eventIndex = String()
    @objc private dynamic var _commentaire = String()
    @objc private dynamic var _estEnvoye = false

    //Modification du nom des données pour l'envoi au format JSON conformément au WebService
    enum CodingKeys: String, CodingKey {
        case _id = "Identifiant"
        case _typeEvent = "TypeEvenement"
        case _nomEvent = "NomEvenement"
        case _saison = "Saison"
        case _start = "DateDeb"
        case _end = "DateFin"
        case _codeVRP = "CodeVRP"
        case _codeInvite = "CodeInvite"
        case _tiers = "Tiers"
        case _commentaire = "Commentaire"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(typeEvent, forKey: ._typeEvent)
        try container.encode(nomEvent, forKey: ._nomEvent)
        try container.encode(saison, forKey: ._saison)
        try container.encode(start, forKey: ._start)
        try container.encode(end, forKey: ._end)
        try container.encode(codeVRP, forKey: ._codeVRP)
        try container.encode(codeInvite, forKey: ._codeInvite)
        try container.encode(tiers, forKey: ._tiers)
        try container.encode(commentaire, forKey: ._commentaire)

    }
    
//    override static func primaryKey() -> String {
//           return "_id"
//    }
//
//    override static func ignoredProperties() -> [String]{
//        return ["id", "eventIndex","typeEvent","nomEvent","saison","dateDeb","dateFin","codeVRP","codeInvite","tiers","commentaire","estEnvoye"]
//    }
//
//
    var id:String {
        get {
            return _id
        } set {
//            realm?.beginWrite()
            _id = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-id suivante est survenue : \(err)")
//            }
        }
    }
    
    /**
     Permet d'identifier le type d'event par la date
     */
    var eventIndex:String {
           get {
               return _eventIndex
           } set {
//               realm?.beginWrite()
               _eventIndex = newValue
//               do{
//                   try realm?.commitWrite()
//               }catch let err as NSError{
//                   debugPrint("L'erreur pour CalendarEvent-id suivante est survenue : \(err)")
//               }
           }
       }
    
    var typeEvent:String {
        get {
            return _typeEvent
        } set {
//            realm?.beginWrite()
            _typeEvent = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-typeEvent suivante est survenue : \(err)")
//            }
        }
    }
    
    var nomEvent:String {
        get {
            return _nomEvent
        } set {
//            realm?.beginWrite()
            _nomEvent = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-nomEvent suivante est survenue : \(err)")
//            }
        }
    }
    
    var saison:String {
        get {
            return _saison
        } set {
//            realm?.beginWrite()
            _saison = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-saison suivante est survenue : \(err)")
//            }
        }
    }
    
    /**
     Retourne vrai l'evenement dure toute la journée
     */
    var allDay:Bool {
           get {
               return _allDay
           } set {
//               realm?.beginWrite()
               _allDay = newValue
//               do{
//                   try realm?.commitWrite()
//               }catch let err as NSError{
//                   debugPrint("L'erreur pour CalendarEvent-saison suivante est survenue : \(err)")
//               }
           }
       }
    
    var start:String {
        get {
            return _start
        } set {
//            realm?.beginWrite()
            _start = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-dateDeb suivante est survenue : \(err)")
//            }
        }
    }
    
    var end:String {
        get {
            return _end
        } set {
//            realm?.beginWrite()
            _end = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-dateFin suivante est survenue : \(err)")
//            }
        }
    }
    
    var codeVRP:String {
        get {
            return _codeVRP
        } set {
//            realm?.beginWrite()
            _codeVRP = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-codeVRP suivante est survenue : \(err)")
//            }
        }
    }
    
    var codeInvite:String {
        get {
            return _codeInvite
        } set {
//            realm?.beginWrite()
            _codeInvite = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-codeInvite suivante est survenue : \(err)")
//            }
        }
    }
    
    var tiers:String {
        get {
            return _tiers
        } set {
//            realm?.beginWrite()
            _tiers = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-tiers suivante est survenue : \(err)")
//            }
        }
    }
    
    var commentaire:String {
        get {
            return _commentaire
        } set {
//            realm?.beginWrite()
            _commentaire = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-commentaire suivante est survenue : \(err)")
//            }
        }
    }
    var estEnvoye:Bool {
        get {
            return _estEnvoye
        } set {
//            realm?.beginWrite()
            _estEnvoye = newValue
//            do{
//                try realm?.commitWrite()
//            }catch let err as NSError{
//                debugPrint("L'erreur pour CalendarEvent-estEnvoye suivante est survenue : \(err)")
//            }
        }
    }
    
    /**
     *Affecte et retourne l'id de l'évènement composé de "tiers,codeVRP,saison,dateDec"
     *- Returns: ID
     */
    public func setGetID()->String{
        _id = "\(_tiers)\(_codeVRP)\(_saison)\(start)"
        return _id
    }
    
    /**
     *Permet d'obtenir la date de début d'évènement en string
     *Fonction servant pour trouver la clé du dictionnaire currentEventArray [date:[self]]
     *-Parameters: format => le format de la clé
     *-Returns : la date en chaine sous le format choisi ou par défaut dd-MM-YYYY,HH:mm
     */
    public func getDate(format:String = "dd-MM-yyyy,HH:mm")->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter.string(from: dateFormatter.date(from: start)!)
    }
    
    
}
