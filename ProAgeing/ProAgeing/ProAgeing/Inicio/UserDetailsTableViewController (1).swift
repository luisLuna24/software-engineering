//
//  UserDetailsTableViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 10/18/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit

class UserDetailsTableViewController: UITableViewController {
    
    var titulo = ["Nombre", "Email","Contraseña", "Fecha de Nacimiento", "Edad", "Género", "Padecimientos", "Tipo de Sangre", "Altura", "Peso", "Medicamentos"]
    var userData = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        loadArray()
        
        print(userData)
        
        
        //tableView.addSubview(item)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userData.count
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
       
        return true
    }
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        //if action == @selector(edit)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetail", for: indexPath)
        cell.textLabel?.text = titulo[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Avenir-Heavy", size: 20.0)
        
        cell.detailTextLabel?.text = userData[indexPath.row]
        cell.detailTextLabel?.font = UIFont(name:"Avenir", size: 16.0)
        cell.canPerformAction(#selector(editarUser), withSender: self)
        print(userData[indexPath.row])
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seleccion = titulo[indexPath.row]
        self.showMessage(text: seleccion)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
     */
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadArray() {
        let user: Usuario! = appDelegate.usuario
        
        //userData.append(String(describing: user.id!))
        userData.append(user.nombre)
        userData.append(user.email)
        userData.append(user.pass)
        userData.append(user.fNacimiento)
        userData.append(String(user.edadAnios()))
        //userData["Imagen"]
        userData.append(user.sexo)
        userData.append(String(describing: user.padecimientos!))
        userData.append(user.sangre)
        userData.append(String(user.altura))
        userData.append(String(user.peso))
        userData.append("--")
        
        
    }
    
    @objc func editarUser() {
        showMessage(text: "Editing")
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








