//
//  ExtraViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 9/3/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import WatchConnectivity
import HealthKit


class ExtraViewController: UITableViewController {

    
    //uber, calculadora de propinas, enviar ubicacion,
    let healthStore = HKHealthStore()
    var dataSource = ExtraDataSource()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    return dataSource.examples.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    
    let sample = dataSource.examples[indexPath.row]
    cell.textLabel?.text = sample.title
    cell.detailTextLabel?.text = sample.description
    //cell.textLabel?.font = UIFont(name: "Avenir Heavy", size: CGFloat(30))
    //cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(21))
    cell.detailTextLabel?.numberOfLines = 3
    
    return cell
}
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0;//Choose your custom row height
    }

// MARK: UITableViewDelegate

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let seleccion = dataSource.examples[indexPath.row]
   /* if let controller = sample.controller {
        navigationController?.pushViewController(controller, animated: true)
    }*/
    if seleccion.title == "Salir" { //Regresar a pagina de login
        self.appDelegate.deleteUserFromDefaults()
        self.appDelegate.usuario = nil
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "login")
       // navigationController?.pushViewController(destination, animated: true)
        navigationController?.showDetailViewController(destination, sender: Any?.self)
    } else if seleccion.title == "🚙 Pedir Uber" {
        self.open(scheme: "uber://", appTitle: "Uber")
    } else if seleccion.title == "🗺 ¿Dónde estoy?" {
        self.open(scheme: "comgooglemaps://", appTitle: "Google Maps")
    } else if seleccion.title == "❤️ Medir frecuencia cardiaca" {
        
        
        self.startWatchApp()
        
        
    }
    

    else if seleccion.title == "🥇 Comparte ProAgeing" {
        let textToShare = "ProAgeing es increible!  Te invito a conocer más sobre esta applicación!"
        
        if let myWebsite = NSURL(string: "http://xtechmx.tk/Proageing/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //activityVC.popoverPresentationController?.sourceView = self
            self.present(activityVC, animated: true, completion: nil)
        }
    } else if seleccion.title == "⚙️ Ajustes" {
        self.open(scheme: UIApplicationOpenSettingsURLString, appTitle:"Configuración")
    } else if seleccion.title == "⚓️ Soporte" {
        self.open(scheme: "http://xtechmx.tk/Proageing/", appTitle: "Safari")
    }
    
    
    tableView.deselectRow(at: indexPath, animated: true)
    }
    func open(scheme: String, appTitle: String) {
        var succ: Bool!
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                if success == false {
             
                     self.showMessage(text: "Instale la app de " + appTitle + " primero")
                }
                print("Open \(scheme): \(success)")
            })
        }
       
    }
    
    var alertController: UIAlertController!
    func showMessage(text: String) {
        
        alertController = UIAlertController(title: "", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertController, animated: true, completion: nil)
        
        _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(AllContactsTableViewController.dismissAlert), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func dismissAlert() {
        // Dismiss the alert from here
        alertController.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
    func startWatchApp() {
        let wc: HKWorkoutConfiguration = HKWorkoutConfiguration()
        wc.activityType = .walking
        print("method called to open app ")
        
        getActiveWCSession { (wcSession) in
            print(wcSession.isComplicationEnabled, wcSession.isPaired)
            if wcSession.activationState == .activated && wcSession.isWatchAppInstalled {
                print("starting watch app")
                
                self.healthStore.startWatchApp(with: wc, completion: { (success, error) in
                    // Handle errors
                })
            }
                
            else{
                print("watch not active or not installed")
            }
        }
        
    }
    
    func getActiveWCSession(completion: @escaping (WCSession)->Void) {
        guard WCSession.isSupported() else { return }
        
        let wcSession = WCSession.default()
       // wcSession.delegate = SaludTableViewController.type
        
        if wcSession.activationState == .activated {
            completion(wcSession)
        } else {
            wcSession.activate()
           // wcSessionActivationCompletion = completion
        }
    }
}

struct ExtraStuff {
    var title: String
    let description: String
    let storyboardName: String
    let controllerID: String?
    
    init(title: String, description: String, storyboardName: String, controllerID: String? = nil) {
        self.title = title
        self.description = description
        self.storyboardName = storyboardName
        self.controllerID = controllerID
    }
    
    var controller: UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController: UIViewController?
        if let controllerID = controllerID {
            viewController = storyboard.instantiateViewController(withIdentifier: controllerID)
        }
        else {
            viewController = storyboard.instantiateInitialViewController()
        }
        viewController?.title = title
        return viewController
    }
}

struct ExtraDataSource {
    lazy var examples: [ExtraStuff] = [ExtraStuff(title: "🚙 Pedir Uber",
                                            description: "Pide un Uber para llegar a donde quieras.",
                                            storyboardName: "CoreML"),
                                    ExtraStuff(title: "🗺 ¿Dónde estoy?",
                                            description: "Toca aquí para dirigirte a Google Maps y mostrarte tus alrededores.",
                                            storyboardName: "Vision"),
                                    ExtraStuff(title: "❤️ Medir frecuencia cardiaca",
                                               description: "Si cuentas con un Apple Watch usa esta opción para conocer tu frecuencia cardiaca.",
                                               storyboardName: ""),
                                    ExtraStuff(title: "⚙️ Ajustes",
                                            description: "Cambia y administra la forma en que accedemos a tu información.",
                                            storyboardName: "ARKit"),
                                    ExtraStuff(title: "⚓️ Soporte",
                                            description: "¿Tienes alguna duda o sugerencia sobre esta app? No dudes en compartirla con nosotros.",
                                            storyboardName: "DragAndDrop"),
                                    ExtraStuff(title: "🥇 Comparte ProAgeing",
                                            description: "No esperes más cuéntales a tus familiares y amigos lo increible que es esta app!",
                                            storyboardName: "MapKit"),
                                   
                                    ExtraStuff(title: "Salir",
                                            description: "Cerrar Sesión",
                                            storyboardName: "Main")]
}

