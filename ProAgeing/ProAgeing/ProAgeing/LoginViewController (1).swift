//
//  LoginViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 8/31/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration
import Eureka

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    private var email: String!
    private var password: String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //static let api = "http://localhost/xtechmx.tk/Proageing/API/login.php?" //PRUEBA
    static let api = "http://xtechmx.tk/Proageing/API/login.php?"  //FUNCIONAL
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tapGestureRecognizer: UITapGestureRecognizer
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        userTxt.delegate = self
        passTxt.delegate = self
        userTxt.tag = 0
        passTxt.tag = 1
        passTxt.isSecureTextEntry = true
        userTxt.setBottomLine(borderColor: .gray)
        passTxt.setBottomLine(borderColor: .gray)
       
       

        //tableView.backgroundView = UIImageView(image: UIImage(named: "640x1136.png"))
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if appDelegate.userSavedInDefaults() {
            appDelegate.readUserFromDefaults()
            goToHome()
            
            
        }
    }
    
    func goToHome() {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    func dismissKeyBoard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            login()
        }
        // Do not add a line break
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loginBtn(_ sender: Any) {
        self.email = userTxt.text
        self.password = passTxt.text
        
        
        if self.email != "" || self.password != "" {
            if self.email == "admin" && self.password == "admin" {
               let defUS = Usuario(id: 117, email: "default@mymail.com", pass: "Hh@", padecimientos: "Artritis", name: "Juan Pérez Pérez", fNacimiento: "1954-08-24", sex: "M", image: "defaultUser", medicamento: "Naproxeno", tipoSangre: "A+", altura: 160.0, peso: 64.500)
                appDelegate.usuario = defUS
                performSegue(withIdentifier: "loginSegue", sender: self)
               
            }

            login()
        } else {
            self.showMessage(text: "Escriba su usuario y contraseña")
        }
        
        
        
    }
    func login() {
        if !internetConnected() {
            showMessage(text: "Verifique su conexión a internet")
            return
        }
        var id: Int!
        var contrasena: String!
        var email: String!
        var padecimientos: String!
        var nombre: String!
        var nacimiento: String!
        var sexo: String!
        var imagen: String!
        var medicamento: String!
        var sangre: String!
        var altura: Double!
        var peso: Double!
        var loginError: Bool!
    
        
        let complete = LoginViewController.api + "email=" + self.email + "&pass=" + self.password
        
        let jsonData: NSData! =  NSData(contentsOf: NSURL(string: complete)! as URL)
        if (jsonData == nil) {
            showMessage(text: "Servidor no disponible")
            return
        }
        
        let response: JSON! = try! JSON(data: jsonData as Data)
        
       // print("RESPONSE ARRAY: \(response.arrayValue)")
        
            print("RESPONSE IS NULL \(response == JSON.null)")
            if(response == JSON.null) {
                
                self.showMessage(text: "RESPONSE IN NIL :(")
                return
            }
        
       let dicUser = response.arrayValue
            
        print("Array Value: \(dicUser)")
        for (key, value) in response.dictionary! {
            
            switch key {
            case "Email":
                
                email = String(describing: value)
                print("Im on email and is: \(email)")
            case "Medicamento":
                medicamento = String(describing: value)
                print("Im on medicamento and is: \(medicamento)")
                
            case "Sexo":
                sexo = String(describing: value)
                print("Im on sexo and is: \(sexo)")
                
            case "Altura":
                altura = Double(String(describing: value))
                print("Im on altura and is: \(altura)")
            
            case "Contrasena":
                contrasena = String(describing: value)
                print("Im on contrasena and is: \(contrasena)")
                
            case "Id":
                id = Int(String(describing: value))
                print("Im on id and is: \(id)")
                
            case "Nacimiento":
                nacimiento = String(describing: value)
                print("Im on nacimiento and is: \(nacimiento)")
                
            case "Padecimientos":
                padecimientos = String(describing: value)
                print("Im on padecimientos and is: \(padecimientos)")
            
            case "Sangre":
                sangre = String(describing: value)
                print("Im on sangre and is: \(sangre)")
            case "Peso":
                peso = Double(String(describing: value))
                print("Im on peso and is: \(peso)")
            case "Imagen":
                imagen = String(describing: value)
                print("Im on imagen and is: \(imagen)")
            case "Nombre":
                nombre = String(describing: value)
                print("Im on nombre and is: \(nombre)")
            case "loginError":
                loginError = Bool(String(describing: value))
                print("Im on loginError and is: \(loginError)")
                
            default:
            print("Im on default \(key)")
        }
            
           
        }
        
        if loginError {
            self.showMessage(text: "Usuario o contraseña incorrectos")
            self.email = ""
            self.password = ""
            self.userTxt.text = ""
            self.passTxt.text = ""
            return
        }
        
        let user = Usuario(id: id, email: email, pass: contrasena, padecimientos: padecimientos, name: nombre, fNacimiento: nacimiento, sex: sexo, image: imagen, medicamento: medicamento, tipoSangre: sangre, altura: altura, peso: peso)
        
        appDelegate.usuario = user
        
        performSegue(withIdentifier: "loginSegue", sender: self)
        
            

        
                
    }
    
    func showMessage(text: String) {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: "", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    func internetConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    

    
    
    
    
}
