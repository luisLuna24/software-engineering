//
//  FirstViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 8/29/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import EventKit

class InicioViewController: UITableViewController {
    //public static let usuario = Usuario(name: "Juan Pérez Pérez", age: 100, image:"profileTest")
    var data: InicioTableSource!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            self.requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            print("Autorización de acceso a recordatorios exitosa")
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("No hay acceso a calendario")
            self.requestAccessToCalendarsAfterDenied()
            
        }
        
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.prefersLargeTitles = true
        data = InicioTableSource()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: UITableViewDataSource
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String!
        var cell: UITableViewCell!
        
        switch (indexPath.item) {
        case 0: //perfil
                cellIdentifier = "profileCell"
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                
                cell.textLabel?.text = appDelegate.usuario.nombre
                //cell.textLabel?.numberOfLines = 0
                //cell.textLabel?.font = UIFont(name: "Avenir-Heavy", size: CGFloat(50))
                cell.detailTextLabel?.text = String(describing: appDelegate.usuario.edadAnios())  + " Años"
                //cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(25))
                //cell.imageView?.image = appDelegate.usuario.imagen
                
                
                cell.textLabel?.font = UIFont(name: "Avenir", size: CGFloat(28))
                cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(22))
        case 1: //Frecuencia
            cellIdentifier = "heartCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = data.other[0].title
            cell.detailTextLabel?.text = data.other[0].detail
            cell.detailTextLabel?.numberOfLines = 3
            cell.textLabel?.numberOfLines = 1
            //cell.imageView?.image = appDelegate.usuario.imagen
            //cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
            //cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
        case 2: //Recordatorio
            cellIdentifier = "heartCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = data.other[1].title
            cell.detailTextLabel?.text = data.other[1].detail
            
            //cell.imageView?.image = appDelegate.usuario.imagen
            //cell.textLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
            //cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
            //cell.detailTextLabel?.numberOfLines = 0
        case 3: //Contacto
            cellIdentifier = "contactCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            
            
            cell.textLabel?.text = data.other[2].title
            cell.detailTextLabel?.numberOfLines = 1
            
            let lastCalled: Contacto? = self.appDelegate.usuario.getLastCalled()
            var detail: String!
            let phoneNumber = lastCalled?.phone ?? ""
            
            if phoneNumber == "" {
                detail = "Llame a alguien para que aparezca aquí"
            } else {
                detail = (lastCalled?.name)! + " " + (lastCalled?.phone)!
            }
            cell.detailTextLabel?.text = detail
            cell.detailTextLabel?.numberOfLines = 0
            //cell.imageView?.image = appDelegate.usuario.imagen
            //cell.textLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
            //cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
            
        default:
            cellIdentifier = "heartCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = data.other[1].title
            cell.detailTextLabel?.text = data.other[1].detail
            //cell.imageView?.image = appDelegate.usuario.imagen
            //cell.textLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
            //cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
        }
        

        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let sample = data.user[indexPath.row]
        /*  if let controller = sample.controller {
         navigationController?.pushViewController(controller, animated: true)
         }*/
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showDetail", sender: self)
        case 1:
            self.showRate(rate: self.appDelegate.usuario.getLastHearthRate())
            //self.tableView.reloadData()
            self.viewDidLoad()
            
        case 2:
            self.tabBarController?.selectedIndex = 1
           // performSegue(withIdentifier: "showReminders", sender: self)
            
            
        case 3:
            let seleccion = appDelegate.usuario.getLastCalled()
            var number: String? = seleccion?.phone
            if (number != nil) {
                number = number?.removingWhitespaces()
                let call = "tel://" + number!
                TelefonoViewController.open(scheme: call)
            } else {
                
                self.showMessage(text: "Llame a alguien para que aparezca aquí", interval: 2.0)
            }
            
        default:
            print("Default 142 - Inicio")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func setLastCalled () {
        
    }

    var alertController: UIAlertController!
    func showMessage(text: String, interval: Double) {
        
        alertController = UIAlertController(title: "", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alertController, animated: true, completion: nil)
        
        _ = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(AllContactsTableViewController.dismissAlert), userInfo: nil, repeats: true)
        
    }
    
    @objc func dismissAlert() {
        // Dismiss the alert from here
        alertController.dismiss(animated: true, completion: nil)
        
    }
    
    func showRate(rate: Double?) {
        
        if rate == nil {
            self.showMessage(text: "Aún no se ha tomado la frecuencia cardiaca", interval: 4.0)
            return
            
        }
        let title1 = "La última frecuencia registrada es:"
        
        let alert = UIAlertController(title: title1, message: String(describing: rate!), preferredStyle: UIAlertControllerStyle.alert)
        //alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSFontAttributeName : UIFont(name: "Avenir Heavy", size: 22.0), NSForegroundColorAttributeName : UIColor.black]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSFontAttributeName : UIFont(name: "Avenir Book", size: 20.0), NSForegroundColorAttributeName : UIColor.black]), forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)
    }
    
    func requestAccessToCalendar() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                   
                })
            } else {
                DispatchQueue.main.async(execute: {
                    
                   
                    
                })
            }
        })
    }
    
    func requestAccessToCalendarsAfterDenied() {
        var alertController: UIAlertController!
        
        let text = "Para permitir el acceso a calendarios dirígete a configuración y activa el acceso para ProAgeing."
        
        alertController = UIAlertController(title: "ProAgeing necesita acceder al calendario", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cambiar Configuración", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: {(success)
                in
                print("Opening Settings \(success)")
            })
            print("redirect to xtechmx.tk")
        }))
        
        
        self.present(alertController, animated: true, completion: nil)
    
        
        
    }
}

struct HomeResumes {
    let title: String
    var detail: String!
    var phoneNumber = String() //Solo para .contact
    let identifier: Character
    let action: Actions
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    init(title: String, identifier: Character, action: Actions) {
        self.title = title
        self.identifier = identifier
        self.action = action
        details()
    }
    
    mutating func details () {
        switch (self.action) {
        case .heart:
           detail = "Presione aquí para conocerla"
        case .contact:
            let lastCalled: Contacto? = self.appDelegate.usuario.getLastCalled()
            self.phoneNumber = lastCalled?.phone ?? ""
            
            if phoneNumber == "" {
                self.detail = "Llame a alguien para que aparezca aquí"
            } else {
                self.detail = (lastCalled?.name)! + " " + (lastCalled?.phone)!
            }
            
            
        case.reminder:
            self.detail = "Toque aquí para ver"
       
        }
    }
    
    
}

struct InicioTableSource {
   // let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var other: [HomeResumes] = [HomeResumes(title: "Última frecuancia registrada ❤️",
                                                  identifier: "H",
                                                  action: .heart),
                                     HomeResumes(title: "Próximo recordatorio 🗓",
                                                 identifier: "R",
                                                 action: .reminder),
                                       HomeResumes(title: "Último contacto llamado ☎️",
                                                  identifier: "C",
                                                  action: .contact)]
}

enum Actions {
    case heart
    case contact
    case reminder
}



