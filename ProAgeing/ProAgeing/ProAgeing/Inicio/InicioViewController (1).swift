//
//  FirstViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 8/29/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit

class InicioViewController: UITableViewController {
    //public static let usuario = Usuario(name: "Juan Pérez Pérez", age: 100, image:"profileTest")
    var data: InicioTableSource!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                cell.textLabel?.numberOfLines = 1
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
       /* case 1:
            performSegue(withIdentifier: "saludSeg", sender: self)
        case 2:
            performSegue(withIdentifier: "recordatoriosSeg", sender: self)*/
        case 3:
            let seleccion = appDelegate.usuario.getLastCalled()
            var number: String? = seleccion?.phone
            if (number != nil) {
                number = number?.removingWhitespaces()
                let call = "tel://" + number!
                TelefonoViewController.open(scheme: call)
            } else {
                
                self.showMessage(text: "Llame a alguien para que aparezca aquí")
            }
            
        default:
            print("Default 142 - Inicio")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func setLastCalled () {
        
    }

    var alertController: UIAlertController!
    func showMessage(text: String) {
        
        alertController = UIAlertController(title: "", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alertController, animated: true, completion: nil)
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AllContactsTableViewController.dismissAlert), userInfo: nil, repeats: true)
        
    }
    
    @objc func dismissAlert() {
        // Dismiss the alert from here
        alertController.dismiss(animated: true, completion: nil)
        
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
            self.detail = "---"
        case .contact:
            let lastCalled: Contacto? = self.appDelegate.usuario.getLastCalled()
            self.phoneNumber = lastCalled?.phone ?? ""
            
            if phoneNumber == "" {
                self.detail = "Llame a alguien para que aparezca aquí"
            } else {
                self.detail = (lastCalled?.name)! + " " + (lastCalled?.phone)!
            }
            
            
        case.reminder:
            self.detail = "Tomar pastilla Hoy 16:30"
       
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



