//
//  NuevoRecordatorioViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 11/23/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import Eureka
import EventKit
class NuevoRecordatorioViewController: FormViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var usuario: Usuario?
    var recordatorio: EKReminder?
    
    private var titulo: String!
    private var alerta: Date?
    private var notas: String? = ""
    

    
    
    private var switchIsOn: Bool! = false //controla la posicion del switch

    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section()
            <<< TextRow() {
                $0.title = "Título del Recordatorio"
                $0.placeholder = "Ir a cita médica"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                 
                }
                $0.onChange({ row in
                    self.titulo = row.value
                })
        }
        
        +++ Section()
            <<< SwitchRow() {
                $0.title = "Avisarme"
                
                $0.cellUpdate { (cell, row) in //3
                    cell.switchControl.isOn = self.switchIsOn
                    
                }
                
                $0.onChange({ row in
                    
                    self.switchIsOn = row.value!
                    
                    print("Reminder switch is \(self.switchIsOn)")
                    self.tableView.reloadData()
                    
                })
                
        }
            <<< DateTimeRow() {
                $0.title = "Recordatorio"
                $0.minuteInterval = 5
         
                $0.onChange({ row in
                    self.alerta = row.value!
                })
                $0.cellUpdate { (cell, row) in //3
                    if !self.switchIsOn {
                        cell.isHidden = true
                    } else {
                        cell.isHidden = false
                    }
                }
                
                
        }
            +++ Section()
            <<< TextRow() {
                $0.title = "Notas"
                $0.placeholder = "Descripción del recordatorio"
                
                $0.cellSetup({ (cell, row) in
                        cell.height = ({return 100})
                    })
               
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                    
                }
                $0.onChange({ row in
                    self.notas = row.value
                })
        }
            +++ Section()
            <<< ButtonRow(){ (row: ButtonRow) -> Void in
                row.title = "Agregar Recordatorio"
                row.onCellSelection { [weak self] (cell, row) in
                    print("Errores: \(String(describing: row.section?.form?.validate().count))")
                    if row.section?.form?.validate().count == 0{
                        self?.guardar()
                    }
                }
            }
            
            +++ Section()
            <<< ButtonRow(){ (row: ButtonRow) -> Void in
                row.title = "Cancelar"
                
                
                row.onCellSelection { [weak self] (cell, row) in
                    self?.dismiss(animated: true, completion: nil)
                    
                    
                }
            }
        
        
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func guardar () {
        print("Switch is on = \(self.switchIsOn)")
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
                return
            }
        }
        
        if self.switchIsOn { //Crear recordatorio
            
            
            let newReminder = EKReminder(eventStore: eventStore)
            newReminder.title = self.titulo
            //newReminder.dueDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.alerta!)
            var alarm = EKAlarm(absoluteDate: self.alerta!)
            newReminder.addAlarm(alarm)
            newReminder.calendar = myCalendar!
            
            do {
                try eventStore.save(newReminder, commit: true)
                showMessage(text: "Recordatorio Creado")
            } catch  {
                print(error)
                 showMessage(text: "Hubo un Problema al crear el recordatorio")
            }
        
            
        } else { //No necesita alarma
            
            
            let newReminder = EKReminder(eventStore: eventStore)
            newReminder.title = self.titulo
            //newReminder.dueDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.alerta!)

            newReminder.calendar = myCalendar!
            
            do {
                try eventStore.save(newReminder, commit: true)
        
                showMessage(text: "Recordatorio Creado")
                
            } catch  {
                print(error)
                showMessage(text: "Hubo un Problema al crear el recordatorio")
                
            }
            
            
            
        }
        
    }
    
    var alertController: UIAlertController!
    func showMessage(text: String) {
        
        alertController = UIAlertController(title: "", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(NuevoMedicamentoFormViewController.dismissAlert), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func dismissAlert() {
        // Dismiss the alert from here
        alertController.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
