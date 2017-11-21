//
//  MedicamentosTableViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 11/6/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit

class MedicamentosTableViewController: UITableViewController {
    var medicineToEdit: Medicamento!
    static var medicineToView: Medicamento!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var addMedBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Notificator.initialize()
        tableView.rowHeight = 80.0
        addMedBarBtn.width = 80.0
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       // showMessage(text: String(appDelegate.usuario.medicamentos.count))
        return appDelegate.usuario.medicamentos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medCell", for: indexPath)
        cell.textLabel?.text = appDelegate.usuario.medicamentos[indexPath.row].nombre
        cell.detailTextLabel?.text = String(describing: appDelegate.usuario.medicamentos[indexPath.row].dosis) + " " + appDelegate.usuario.medicamentos[indexPath.row].unidad

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let med = self.appDelegate.usuario.medicamentos[indexPath.row]
        MedicamentosTableViewController.medicineToView = med
        Notificator.notificateMedicine(med: med)
      /*  var details : DetalleMedicamentoViewController = self.storyboard?.instantiateViewController(withIdentifier: "detalleMed") as! DetalleMedicamentoViewController
        details.med = self.medicineToView
        
        self.navigationController?.pushViewController(details, animated: true)*/
        self.navigationController?.performSegue(withIdentifier: "detailsMed", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Eliminar"
    }

    
    // Override to support editing the table view.    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Editar") { action, index in
            
            
            self.medicineToEdit = self.appDelegate.usuario.medicamentos[indexPath.row]
            self.performSegue(withIdentifier: "toEditVC", sender: self)
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Eliminar") { action, index in
            let name = self.appDelegate.usuario.medicamentos[indexPath.row].nombre
            let dosis = self.appDelegate.usuario.medicamentos[indexPath.row].dosis
            
            
            self.appDelegate.usuario.deleteMedicine(name: name, dosis: dosis)
            self.showMessage(text: "Medicamento eliminado correctamente")
            self.tableView.deleteRows(at: [indexPath], with: .fade)
 
            
        }
        return [delete, edit]
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toEditVC" {
            let editVC = segue.destination as! NuevoMedicamentoFormViewController
             editVC.medicamento = self.medicineToEdit
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
        
}

extension UINavigationController {
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsMed" {
            let detailVC = segue.destination as! DetalleMedicamentoViewController
            print("MEDICINE TO VIEW \(MedicamentosTableViewController.medicineToView)")
            detailVC.med = MedicamentosTableViewController.medicineToView
        }
    }
}
