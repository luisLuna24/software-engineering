//
//  NuevoMedicamentoFormViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 10/1/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import Eureka

class NuevoMedicamentoFormViewController: FormViewController {
    
    var usuario: Usuario?
    

    private var nombre: String!
    private var dosis: Int!
    private var unidad: String!
    private var desde: Date!
    private var hasta: Date!
    private var intervalo: String!
    private var viaAdmon: String!
    
    private var edition = false
    
    var medicamento: Medicamento? // if is null is new, else is edit
    
    private var reminder = false
    
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
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        form
            +++ Section()
                <<< TextRow() {
                    $0.title = "Nombre del medicamento"
                    $0.placeholder = "e.g. Naproxeno"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    $0.cellUpdate { (cell, row) in //3
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                    }
                    $0.onChange({ row in
                        self.nombre = row.value
                    })
                }
                <<< IntRow() {
                    $0.title = "Dosis"
                    $0.placeholder = "100"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    $0.cellUpdate { (cell, row) in //3
                        if !row.isValid {
                            cell.titleLabel?.textColor = .red
                        }
                    }
                    $0.onChange({ row in
                        self.dosis = row.value
                    })
                
                }
            
            
            <<< AlertRow<String>() {
                $0.title = "Unidad"
                $0.options = ["Pastilla(s)", "ml", "g", "mg", "Unidades", "UI", "Cucharada"]
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
                $0.options = ["Oral", "Cutanea", "Subcutanea", "Sublingual", "Intravenosa", "Rectal"]
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
                $0.onChange({ row in
                    self.viaAdmon = row.value
                })
            }
         
            +++ Section()
            <<< SwitchRow() {
                $0.title = "Recordatorios"
                $0.onChange({ row in
                    self.reminder = row.value!
                    self.tableView.reloadData()
                    print("Reminder is \(self.reminder)")
                })
                
                
            }
            
            
            <<< DateTimeRow() {
                $0.title = "Desde"
                $0.onChange({ row in
                    self.desde = row.value
                })
                $0.cellUpdate { (cell, row) in //3
                    if !self.reminder {
                        cell.isHidden = true
                    } else {
                        cell.isHidden = false
                    }
                }
                
                
            }
            <<< DateTimeRow() {
                $0.title = "Hasta"
                $0.onChange({ row in
                    self.hasta = row.value
                })
                $0.cellUpdate { (cell, row) in //3
                    if !self.reminder {
                        cell.isHidden = true
                    } else {
                        cell.isHidden = false
                    }
                }
                
            }
            <<< ActionSheetRow<String>() {
                $0.title = "Intervalo"
                $0.options = ["30 minutos","1 hora","4 horas","6 horas","8 horas","12 horas","24 horas","2 días","1 semana","15 días","1 mes"]
                $0.onChange({ row in
                    self.intervalo = row.value
                })
                $0.cellUpdate { (cell, row) in //3
                    if !self.reminder {
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
                        cell.textLabel?.textColor = .red
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
                    if row.section?.form?.validate().count == 0{
                        self?.guardar()
                    }
                }
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func guardar() {
        

    }
    
    func actualizar() {
        
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
