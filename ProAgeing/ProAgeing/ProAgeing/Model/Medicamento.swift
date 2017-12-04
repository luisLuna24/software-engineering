//
//  Medicamento.swift
//  ProAgeing
//
//  Created by Luis Luna on 10/26/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import EventKit


class Medicamento: NSObject, NSCoding {
    
    //static let api: String = "http://localhost/xtechmx.tk/Proageing/API/new_medicine.php" //test
    static let api: String = "http://xtechmx.tk/Proageing/API/new_medicine.php" //funcional
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    let nombre: String
    var dosis: String
    var unidad: String
    var desde: Date?
    var hasta: Date?
    var intervalo: String?
    var needsToBeReminded: Bool
    let viaAdmon: String
    private var alreadyInDB = false
    
    //var notificationTrigguer: UNTimeIntervalNotificationTrigger?
    
 
    
    init(nombre: String, dosis: String, unidad: String, desde: Date?, hasta: Date?, intervalo: String?, needsToBeReminded: Bool, viaAdmon: String) {
        
        self.nombre = nombre
        self.dosis = dosis
        self.unidad = unidad
        self.desde = desde
        self.hasta = hasta
        self.intervalo = intervalo
        self.needsToBeReminded = needsToBeReminded
        self.viaAdmon = viaAdmon
     
  
        
    }
    
   
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.nombre, forKey:"nombreMed")
        aCoder.encode(self.dosis, forKey:"dosisMed")
        print("DDDDDOOOOOSSSSSIIIIIISSSS \(self.dosis)")
        aCoder.encode(self.unidad, forKey:"unidadMed")
        aCoder.encode(self.desde, forKey:"desdeMed")
        aCoder.encode(self.hasta, forKey:"hastaMed")
        aCoder.encode(self.intervalo, forKey:"intervaloMed")
        aCoder.encode(self.needsToBeReminded, forKey:"needsToBeRemindedMed")
        aCoder.encode(self.viaAdmon, forKey: "viaAdmonMed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.nombre = aDecoder.decodeObject(forKey: "nombreMed") as? String ?? ""
        self.dosis = aDecoder.decodeObject(forKey: "dosisMed") as? String ?? "Dosis def"
        self.unidad = aDecoder.decodeObject(forKey: "unidadMed") as? String ?? ""
        self.desde = aDecoder.decodeObject(forKey: "desdeMed") as? Date ?? Date()
        self.hasta = aDecoder.decodeObject(forKey: "hastaMed") as? Date ?? Date()
        self.intervalo = aDecoder.decodeObject(forKey: "intervaloMed") as? String ?? ""
        self.needsToBeReminded = aDecoder.decodeObject(forKey: "needsToBeRemindedMed") as? Bool ?? false
        self.viaAdmon = aDecoder.decodeObject(forKey: "viaAdmonMed") as? String ?? ""
    }
    
    func saveInDB() {
        if alreadyInDB {
            print("Medicine \(self.nombre) already in DB")
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var from = "", to = "", interval = ""
        if self.desde != nil {
            from = formatter.string(from: self.desde!)
        }
        if self.hasta != nil {
            to = formatter.string(from: self.hasta!)
        }
        if self.intervalo != nil {
            interval = self.intervalo!
        }
        
        
        let parameters: [String: String]!  = ["usuario": String(describing: self.appDelegate.usuario.id), "nombre": self.nombre, "dosis": String(self.dosis), "unidad": self.unidad, "desde": from, "hasta": to, "intervalo": interval, "viaAdmon": self.viaAdmon, "needsToBeReminded": String(self.needsToBeReminded)]
        
        print("Parameters before request: \(parameters)")
        
        Alamofire.request(NuevoMedicamentoFormViewController.api, method: .post , parameters: parameters, encoding:  JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
 
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                self.alreadyInDB = true
               
            } else {
                self.alreadyInDB = false
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf16) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
        }

    }
    
    func setUpReminders() {
        
        if !needsToBeReminded {
            return
        }
        let calendar = Calendar.current
        let eventStore = EKEventStore()
        var myCalendar: EKCalendar?
        
        let calendars = eventStore.calendars(for: .reminder)
        
        for cal in calendars {
            if cal.title == "ProAgeing" {
                myCalendar = cal as EKCalendar
                print("CALENDAR FOUND")
                break
            }
        }
        
        if myCalendar == nil {
            let nc = EKCalendar(for: .reminder, eventStore: eventStore)
            nc.title = "ProAgeing"
            nc.source = eventStore.defaultCalendarForNewReminders().source
            do {
                try eventStore.saveCalendar(nc, commit: true)
                myCalendar = nc
            } catch {
                print(error)
                print("####No se creo Calendario####")
            }
        }
        
        
        let newReminder = EKReminder(eventStore: eventStore)
        
        newReminder.title = "Tomar " + self.nombre
        newReminder.notes = self.dosis + " " + self.unidad + ", Via Administración: " + self.viaAdmon
        //newReminder.startDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.desde!)
        newReminder.dueDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.hasta!)
        var alarm = EKAlarm(absoluteDate: self.desde!)
    
        newReminder.addAlarm(alarm)
        newReminder.recurrenceRules = [getRecurring()]
        
        newReminder.calendar = myCalendar!
        do {
        try eventStore.save(newReminder, commit: true)
            print("RECORDATORIO CREADO")
        } catch  {
            print(error)
            print("RECORDATORIO NOOOOOOOO CREADO")
        }
        

    }
    
    func getRecurring() -> EKRecurrenceRule {
        var rule: EKRecurrenceRule!
        
        if self.intervalo == "1 hora" || self.intervalo == "4 horas" || self.intervalo == "6 horas" || self.intervalo == "8 horas" || self.intervalo == "12 horas" || self.intervalo == "24 horas"{
        
         rule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: EKRecurrenceEnd(end:self.hasta!))
        }
        else if self.intervalo == "2 días" {
            rule = EKRecurrenceRule(recurrenceWith: .daily, interval: 2, end: EKRecurrenceEnd(end:self.hasta!))
            
        }  else if self.intervalo == "1 semnana" {
            rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: EKRecurrenceEnd(end:self.hasta!))
            
        }  else if self.intervalo == "15 días" {
            rule = EKRecurrenceRule(recurrenceWith: .daily, interval: 15, end: EKRecurrenceEnd(end:self.hasta!))
            
        }  else if self.intervalo == "1 mes" {
            rule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, end: EKRecurrenceEnd(end:self.hasta!))
            
        }
    
        
    
        
        return rule
    }
    

    
    
    
}
