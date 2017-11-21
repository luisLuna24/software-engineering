//
//  RegistroFormController.swift
//  ProAgeing
//
//  Created by Luis Luna on 9/29/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//


import UIKit
import Eureka
import SwiftyJSON
import Alamofire


class RegistroFormController: FormViewController {
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var id = Int()
    var nombre: String! = ""
    var email: String! = ""
    //var usuario: String! = ""
    var contra: String! = ""
    var nacimiento: Date!
    var genero: String! = ""
    var sangre: String! = ""
    var peso: Double! = 0.0
    var altura: Int! = 0
    var padec: String! = ""
    var ready = false
    
    //static let api: String = "http://localhost/xtechmx.tk/Proageing/API/register.php" //PRUEBA
    static let api = "http://xtechmx.tk/Proageing/API/register.php"  //FUNCIONAL

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.barTintColor = UIColor.blue
      
        //self.initialize()
        form
            +++ Section()
            
       
        
            <<< NameRow() {
                $0.title = "Nombre"
                $0.placeholder = "Juan Pérez Pérez"
                //$0.value = appDelegate.usuario.nombre
                $0.onChange { [unowned self] row in
                    self.nombre = row.value
                }
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    } else {
                        self.ready = true
                    }
                }
            }
            
            +++ EmailRow() {
                $0.title = "Email"
                $0.placeholder = "email@ejemplo.com"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.onChange { [unowned self] row in
                    self.email = row.value
                }
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            }
            
            
        
        +++ Section()
            <<< PasswordRow () {
                $0.title = "Contraseña"
                $0.placeholder = "*******"
                $0.add(rule: RuleRequired())
                $0.onChange { [unowned self] row in
                    self.contra = row.value
                }
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            }
            <<< PasswordRow () {
                $0.title = "Repite la contraseña"
                $0.placeholder = "*******"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid || row.value != self.contra && self.contra.count > 0 {
                        cell.titleLabel?.textColor = .red
                        print("diferente")
                    }
                    
                   
                }
              
            }
            
        +++ Section()
            <<< AlertRow<String>() {
                $0.title = "Tipo de Sangre"
                $0.options = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.onChange { [unowned self] row in
                    self.sangre = row.value
                }
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        //cell.detailTextLabel?.textColor = .red
                    }
                }
                
            }
            
            <<< IntRow() {
               $0.title = "Peso"
               $0.placeholder = "KG"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.onChange({ row in
                    if row.value != nil {
                        self.peso = Double(row.value!)
                    }
                })
                
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                
                
            }
            
            <<< IntRow() {
                $0.title = "Altura"
                $0.placeholder = "CM"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.onChange({ row in
                    self.altura = row.value
                })
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                
                
            }


        
        +++ Section()
            <<< DateRow() {
                $0.title = "Fecha de Nacimiento"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.onChange { [unowned self] row in
                    self.nacimiento = row.value
                }
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        
                        //cell.detailTextLabel?.textColor = .red
                    }
                }
                
                
            }
            <<< AlertRow<String>() {
                $0.title = "Género"
                $0.options = ["Masculino 👱", "Femenino 👩‍💼", "Otro 🌈"]
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.onChange { [unowned self] row in
                    self.genero = row.value
                }
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        //cell.detailTextLabel?.textColor = .red
                    }
                }
                
            }
            
        form +++
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Enfermedades Degenerativas",
                               footer: "Puede agregar tantos padecimientos como sea necesario") {
                
                                
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Agregar Padecimiento"
                                        
                                        
                                    }
                                }

                                $0.multivaluedRowToInsertAt = { index in
                                   
                                    AlertRow<String>() {
                                        $0.title = "Nombre del Padecimiento:"
                                        $0.options = ["Diebetes", "Hipertensión Arterial", "Artritis", "Osteoporosis", "Alz-Heimer", "Parkinson", "Demencia", "Sordera"]
                                        $0.onChange({ row in
                                            self.padec = self.padec + row.value! + ", "
                                            print(self.padec)
                                        })
                                        
                                    }
                               
                                }
                                
                                print("FORMMMMM >>>>>>>>>> \(form.values())")
                                
                              /*  $0 <<< NameRow() {
                                    $0.title = "Enferdddd"
                                
                                }*/
                                
                                
            }
            
       /* form +++
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Medicamentos",
                               footer: "Puede agregar tantos medicamentos como sea necesario") {
                                
                                
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Agregar Medicamento"
                                    }
                                }
                                
                                
                                
                                
                                $0.multivaluedRowToInsertAt = { index in
                                    
                                 
                                    return NameRow() {
                                        $0.placeholder = "Nombre"
                                    }
                                    
                                }
                                
                                /*  $0 <<< NameRow() {
                                 $0.title = "Enferdddd"
                                 
                                 }*/
                                
                                
            }*/
            
        
        +++ Section()
            <<< ButtonRow(){ (row: ButtonRow) -> Void in
                row.title = "Crear Cuenta"
                
                    row.onCellSelection { [weak self] (cell, row) in
                        print("Errores: \(String(describing: row.section?.form?.validate().count))")
                        if row.section?.form?.validate().count == 0{
                            self?.registrar()
                        }
                }
        }
        
                
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    private func initialize() {
        /*let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonPressed(_:)))*/
        let back = UIBarButtonItem(title: "Cancelar", style: .plain, target: nil, action: #selector(cancelButtonPressed(_:)))
        
        navigationItem.leftBarButtonItem = back
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        view.backgroundColor = .white
    }
    
    @objc func cancelButtonPressed(_ sender: Any) {
       

    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        print("Cancel Button Pressed")
       /* let loginView = UIViewController() as! LoginViewController
        
        self.navigationController?.popToViewController(loginView, animated: true)*/
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registroVC = storyBoard.instantiateViewController(withIdentifier: "login") as!
        LoginViewController
        
        present(registroVC, animated: true, completion: nil)
     
        
        
    }
    
    func saveButtonPressed(_ sender: UIBarButtonItem) {
        if form.validate().isEmpty {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    
    func registrar() {
        var saveToDB = true
        var created = false
        if !appDelegate.internetConnected() {
            showMessage(text: "En este momento no está conectado a internet 🌎☹️" + "\n" + "Conéctese a internet y pruebe de nuevo", caso: .noInternet)
            saveToDB = false
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let fechaNac = formatter.string(from: self.nacimiento)
        
        switch self.genero {
            case "Masculino 👱": self.genero = "M"
            case "Femenino 👩‍💼": self.genero = "F"
            case "Otro 🌈": self.genero = "O"
            default: print("default genero")
        }
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters: [String: String]! = ["email": self.email, "pass": self.contra, "name": self.nombre, "birth": fechaNac, "sex": self.genero, "image":"", "blood":self.sangre, "height": String(self.altura), "weight": String(self.peso), "padec": self.padec]
        
        print("Parameters before request \(parameters)")
        
        Alamofire.request(RegistroFormController.api, method: .post, parameters: parameters, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)") // response serialization result
            
            let a = String(describing: response.result)
            
            if a != "SUCCESS" {
                self.showMessage(text: "Parece que nuestro servidor no está respondiendo en este momento 😥" + "\n" + "Intente de nuevo más tarde.", caso: .noServidor)
                return
            }

            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let jsonDict = response.result.value as? [String:String]
                if jsonDict!["status"]! == "alreadyExits" {
                    self.showMessage(text: "El email ya se encuentra en nuestros registros 😳, inicia sesión o recupera tu contraseña.", caso: .noServidor)
                    return
                }
                
               
                self.showMessage(text: "Cuenta Creada 🙌", caso: .exito)
                //self.performSegue(withIdentifier: "loginSeg", sender: self)

                
            } else {
                self.showMessage(text: "Parece que nuestro servidor no está respondiendo en este momento 😥" + "\n" + "Intente de nuevo más tarde.", caso: .noServidor)
            }
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
        }
        print("CREATED \(created)")
     

    }
    
    
    
    var alertController: UIAlertController!
    func showMessage(text: String, caso: Registro) {
        
        alertController = UIAlertController(title: "", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        
        if caso == .noInternet || caso == .noServidor {
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: "Más Información", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                //UIApplication.shared.openURL(URL(string: "http://xtechmx.tk/Proageing/help"), options:nil, completio)
                UIApplication.shared.open(URL(string: "http://xtechmx.tk/Proageing/help")!, options: ["fromApp": true], completionHandler: nil)
                print("redirect to xtechmx.tk")
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(NuevoMedicamentoFormViewController.dismissAlert), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func dismissAlert() {
        // Dismiss the alert from here
        alertController.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        
    }

    
}


enum Registro {
    case exito
    case noInternet
    case noServidor
}

