//
//  ExtraViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 9/3/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit

class ExtraViewController: UITableViewController {
    //uber, calculadora de propinas, enviar ubicacion,
    
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
    cell.textLabel?.font = UIFont(name: "Avenir", size: CGFloat(28))
    cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(13))
    
    return cell
}
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }

// MARK: UITableViewDelegate

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let seleccion = dataSource.examples[indexPath.row]
   /* if let controller = sample.controller {
        navigationController?.pushViewController(controller, animated: true)
    }*/
    if seleccion.title == "Salir" { //Regresar a pagina de login
        self.appDelegate.deleteUserFromDefaults()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "login")
       // navigationController?.pushViewController(destination, animated: true)
        navigationController?.showDetailViewController(destination, sender: Any?.self)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
}
}

struct ExtraStuff {
    let title: String
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
    lazy var examples: [ExtraStuff] = [ExtraStuff(title: "🤖 Extra 1",
                                            description: "Descripción",
                                            storyboardName: "CoreML"),
                                    ExtraStuff(title: "👀 Extra 2",
                                            description: "Descripción",
                                            storyboardName: "Vision"),
                                    ExtraStuff(title: "🚀 Extra 3",
                                            description: "Descripción",
                                            storyboardName: "ARKit"),
                                    ExtraStuff(title: "👆Extra 4",
                                            description: "Descripción",
                                            storyboardName: "DragAndDrop"),
                                    ExtraStuff(title: "🗺 Extra 5",
                                            description: "Descripción",
                                            storyboardName: "MapKit"),
                                   
                                    ExtraStuff(title: "Salir",
                                            description: "Terminar Sesión",
                                            storyboardName: "Main")]
}

