//
//  HomeViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 10/12/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let secciones = ["", "Resúmenes"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resosurces that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //secciones.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* if secciones[section] == "" { //Perfil
            return 1
        } else {
        return 3 //ultima lectura de HR, Proximo recordatorio, ultimo contacto llamado.
            
        }*/
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        switch(indexPath.item) {
        case 1:
            cell.textLabel?.text = appDelegate.usuario.nombre
            cell.detailTextLabel?.text = String(describing: appDelegate.usuario.edadAnios())
            cell.imageView?.image = appDelegate.usuario.imagen
            cell.textLabel?.font = UIFont(name: "Avenir", size: CGFloat(28))
            cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(18))
            
        
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "resumeCell", for: indexPath)
            cell.textLabel?.text = "Resumen 1"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
