//
//  NuevoMedicamentoFormViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 10/1/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import EventKit

class NuevoMedicamentoFormViewController: FormViewController {
    static let api: String = "http://localhost/xtechmx.tk/Proageing/API/new_medicine.php" //test
    //static let api: String = "http://xtechmx.tk/Proageing/API/new_medicine.php" //funcional
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    var usuario: Usuario?
    let medIntervals = ["1 hora","4 horas","6 horas","8 horas","12 horas","24 horas","2 días","1 semana","15 días","1 mes"]
    let viasAdmin = ["Oral", "Cutanea", "Subcutanea", "Sublingual", "Intravenosa", "Rectal"]
    let unidades = ["Pastilla(s)", "ml", "g", "mg", "Unidades", "UI", "Cucharada(s)"]
    

    
    
    
    

    private var nombre: String!
    private var dosis: String!
    private var unidad: String!
    private var desde: Date?
    private var hasta: Date?
    private var intervalo: String?
    private var viaAdmon: String!
    
    private var edition = false
    
    var medicamento: Medicamento? // if is null is new, else is edit
    
    
    private var switchIsOn: Bool! //controla la posicion del switch
    
    private var canSaveReminder: Bool!
    
    convenience init (usuario: Usuario) {
        self.init(usuario: usuario)
       
        self.usuario = usuario
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        if medicamento != nil {
            edition = true
            switchIsOn = self.medicamento!.needsToBeReminded
            print("This med needs to be reminded: \(switchIsOn)")
        } else {
            switchIsOn = true
            print("Switch has to be on: \(switchIsOn)")
            
        }
        
    
        self.navigationController?.navigationBar.barTintColor = UIColor.white

        
        form
            +++ Section()
                <<< TextRow() {
                    $0.title = "Nombre del medicamento"
                    if edition {
                        $0.value = self.medicamento?.nombre
                        self.nombre = self.medicamento?.nombre
                        
                    }
                    
                    $0.placeholder = "e.g. Naproxeno"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    $0.cellUpdate { (cell, row) in //3
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                        if self.edition {
                            cell.isUserInteractionEnabled = false
                        }
                    }
                    $0.onChange({ row in
                        self.nombre = row.value
                    })
                }
                <<< IntRow() {
                    $0.title = "Dosis"
                    if edition {
                        $0.value = Int((self.medicamento?.dosis)!)
                        self.dosis = self.medicamento?.dosis
                    }
                    $0.placeholder = "100"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    $0.cellUpdate { (cell, row) in //3
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                    }
                    $0.onChange({ row in
                        if row.value != nil {
                            self.dosis = String(describing: row.value!)
                        }
                    })
                
                }
            
            
            <<< AlertRow<String>() {
                $0.title = "Unidad"
                if edition {
                    $0.value = self.medicamento?.unidad
                    self.unidad = self.medicamento?.unidad
                }
                $0.options = self.unidades
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
                $0.onChange({ row in
                    self.unidad = row.value
                })
            }
            
            <<< AlertRow<String>() {
                $0.title = "Vía de Administración"
                if edition {
                    $0.value = self.medicamento?.viaAdmon
                    self.viaAdmon =  self.medicamento?.viaAdmon
                }
                $0.options = self.viasAdmin
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                    if self.edition {
                        cell.isUserInteractionEnabled = false
                    }
                }
                $0.onChange({ row in
                    self.viaAdmon = row.value
                })
            }
         
            +++ Section()
            <<< SwitchRow() {
                $0.title = "Recordatorios"
               
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
                $0.title = "Desde"
                $0.minuteInterval = 5
                if edition {
                    $0.value = self.medicamento?.desde
                    if self.medicamento?.desde != nil {
                        self.desde = self.medicamento?.desde
                    }
                    
                }
                $0.onChange({ row in
                    self.desde = row.value!
                })
                $0.cellUpdate { (cell, row) in //3
                    if !self.switchIsOn {
                        cell.isHidden = true
                    } else {
                        cell.isHidden = false
                    }
                }
                
                
            }
            <<< DateTimeRow() {
                $0.title = "Hasta"
                $0.minuteInterval = 5;
                if edition {
                    $0.value = self.medicamento?.hasta
                    if self.medicamento?.hasta != nil {
                        self.hasta = self.medicamento?.hasta
                    }
                    
                }
                $0.onChange({ row in
                    self.hasta = row.value!
                })
                $0.cellUpdate { (cell, row) in //3
                    if !self.switchIsOn {
                        cell.isHidden = true
                    } else {
                        cell.isHidden = false
                    }
                }
                
            }
            <<< ActionSheetRow<String>() {
                $0.title = "Intervalo"
                if edition {
                    $0.value = self.medicamento?.intervalo
                    if self.medicamento?.intervalo != nil {
                        self.intervalo = self.medicamento?.intervalo
                    }
                   
                   
                }
                $0.options = self.medIntervals
                $0.onChange({ row in
                    self.intervalo = row.value!
                })
                $0.cellUpdate { (cell, row) in //3
                    
                    if self.edition {
                        cell.detailTextLabel?.isEnabled = false
                        
                    }
                    
                    if !self.switchIsOn {
                        cell.isHidden = true
                    } else {
                        cell.isHidden = false
                    }
                }
            }

            <<< ButtonRow(){ (row: ButtonRow) -> Void in
                row.title = "Agregar Medicamento"
                row.cellUpdate { (cell, row) in //3
                    if self.edition {
                        cell.isHidden = true
                    } else {
                        cell.isHidden = false
                    }
                }
                
                row.onCellSelection { [weak self] (cell, row) in
                    print("Errores: \(String(describing: row.section?.form?.validate().count))")
                    if row.section?.form?.validate().count == 0{
                        self?.guardar()
                    }
                }
        }
            
            <<< ButtonRow(){ (row: ButtonRow) -> Void in
                row.title = "Actualizar Medicamento"
                row.cellUpdate { (cell, row) in //3
                    if self.edition {
                        cell.isHidden = false
                        cell.textLabel?.textColor = .blue
                    } else {
                        cell.isHidden = true
                    }
                }
                
                row.onCellSelection { [weak self] (cell, row) in
                    print("Errores: \(String(describing: row.section?.form?.validate().count))")
                    if row.section?.form?.validate().count == 0{
                        self?.actualizar()
                    }
                }
            }
        
            <<< ButtonRow(){ (row: ButtonRow) -> Void in
                row.title = "Eliminar Medicamento"
                row.cellUpdate { (cell, row) in //3
                    if self.edition {
                        cell.isHidden = false
                        cell.textLabel?.textColor = .red
                    } else {
                        cell.isHidden = true
                    }
                }
              
                row.onCellSelection { [weak self] (cell, row) in
                    print("Errores: \(String(describing: row.section?.form?.validate().count))")
                    self?.eliminar()
                }
        }
        
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
    

    
    func guardar() {
        if switchIsOn == true {
            if self.desde == nil || self.hasta == nil || self.intervalo == nil {
                self.showError(text: "Llena todos los campos primero.")
                return
            }
        }
        
        
        
        let newMed = Medicamento(nombre: self.nombre, dosis: self.dosis, unidad: self.unidad, desde: self.desde, hasta: self.hasta, intervalo: self.intervalo, needsToBeReminded: switchIsOn, viaAdmon: self.viaAdmon)
        
        if appDelegate.usuario.addMedicine(med: newMed) {
            newMed.setUpReminders()
            self.appDelegate.saveUserInDefaults()
            showMessage(text: "Medicamento agregado correctamente 🙌")
            //self.dismiss(animated: false, completion: nil)
            
        } else {
            showMessage(text: "Hubo un problema al agregar este medicamento 😳 Tal vez ¿Ya existe? 🤔")
        }
        
        
        
        
        //newMed.saveInDB()

        
    }
    
    func actualizar() {
        self.medicamento?.dosis = self.dosis
        self.medicamento?.unidad = self.unidad
        self.medicamento?.desde = self.desde
        self.medicamento?.hasta = self.hasta
        self.medicamento?.dosis = self.dosis
        self.medicamento?.intervalo = self.intervalo
        //self.medicamento?.viaAdmon = self.viaAdmon
        self.medicamento?.needsToBeReminded = self.switchIsOn
        self.appDelegate.saveUserInDefaults()
        showMessage(text: "Medicamento actualizado correctamente 🙌")
        
    }
    
    func eliminar() {
        if self.medicamento == nil {
            return
        }
        print("Med: \(self.nombre) \(self.dosis)")
        
        appDelegate.usuario.deleteMedicine(name: self.nombre!, dosis: self.dosis!)
        self.appDelegate.saveUserInDefaults()
        self.showMessage(text: "Medicamento eliminado")
        
        
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
    
    func showError(text: String) {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: "", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ofk", style: .default, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
        
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
