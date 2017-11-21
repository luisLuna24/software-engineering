//
//  AllContactsTableViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 9/20/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import Contacts
/* No buscar otra vez en los contactos del telefono crear un arreglo especial para favoritos en contactos y leerlo,
 * Cuando se agregue un favorito hacer un append a ese arreglo
 * Para ver si ya es favorito checar si existe en el arreglo de favoritos
 *
 *
 */

class FavoritosTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UISearchBarDelegate {
    
    var contactStore = CNContactStore()
    var contacts = [Contacto]()
    var filteredContacts = [Contacto]()
    let searchController = UISearchController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        tableView.rowHeight = 120.0
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contacts = appDelegate.usuario.favContacts
        tableView.reloadData()
        
       /* requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    self.tableView.isHidden = !success
                    
                    //self.showAlert(self, text: "Exito obteniendo contactos")
                    
                    if success  {
                        self.contacts = contacts!
                        self.tableView.reloadData()
                        
                    } else {
                        
                        self.showAlert(self, text: "No fue posible obtener sus contactos")
                        
                    }
                })
            }
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 1
     }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isSearching {
            return filteredContacts.count
        }
        return contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactosTableViewCell
        
        let entry: Contacto!
        if (isSearching) {
            entry = filteredContacts[(indexPath as NSIndexPath).row]
        } else {
            
            entry = contacts[(indexPath as NSIndexPath).row]
        }
        cell.configureWithContactEntry(entry)
        cell.layoutIfNeeded()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var seleccion: Contacto!
        if isSearching {
            seleccion = filteredContacts[indexPath.row]
        } else {
            seleccion = contacts[indexPath.row]
        }
        
        var number: String? = seleccion.phone
        if (number != nil || number == "default") {
            seleccion.newLastCalled()
            number = number?.removingWhitespaces()
            let call = "tel://" + number!
            TelefonoViewController.open(scheme: call)
        } else {
            self.showAlert(self, text: "Contacto seleccionado no tiene un número telefónico.")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            editingStyle
            if (!isSearching) {
            
                // Delete the row from the data source
                appDelegate.usuario.contacts[indexPath.row].isFavorite = false
                let conToDel: Int! = appDelegate.usuario.favContacts.index(of: appDelegate.usuario.favContacts[indexPath.row])
            
                appDelegate.usuario.favContacts.remove(at: conToDel)
            
                self.showMessage(text: "Contacto eliminado de favoritos")
            
                self.tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                contacts.remove(at: indexPath.row)
                self.tableView.endUpdates()
            
            } else if isSearching {
                let temp = self.filteredContacts[indexPath.row]
                
                let c: Contacto! = appDelegate.usuario.contacts.first(where: {$0.name == temp.name} )
                let pos: Int! = appDelegate.usuario.contacts.index(of: c!)
                
                
                appDelegate.usuario.contacts[pos].isFavorite = false
                
                let conToDel: Int! = appDelegate.usuario.favContacts.index(of: c)
                
                appDelegate.usuario.favContacts.remove(at: conToDel)
                self.tableView.reloadData()
                self.showMessage(text: "Contacto eliminado de favoritos")
                self.tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                contacts.remove(at: indexPath.row)
                self.tableView.endUpdates()
            }
            
            
        } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue" ,
            let nextScene = segue.destination as? ContactDetailViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedVehicle = contacts[indexPath.row]
            nextScene.contacto = selectedVehicle
        }
    }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    
    
  /*  override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        var favorite: UITableViewRowAction!
        
        if (!isSearching) {
            
            
                favorite = UITableViewRowAction(style: .normal, title: "💔 Quitar Favorito") { action, index in
                    
                    appDelegate.usuario.contacts[editActionsForRowAt.row].isFavorite = false
                    let conToDel: Int! = appDelegate.usuario.favContacts.index(of: appDelegate.usuario.favContacts[editActionsForRowAt.row])
                    
                    appDelegate.usuario.favContacts.remove(at: conToDel)

                    self.showMessage(text: "Contacto eliminado de favoritos")
                   
                    
                 
                }
           
                
            
        } else if (isSearching) { //SEARCH BAR IN USER
            let temp = self.filteredContacts[editActionsForRowAt.row]
            let c: Contacto! = appDelegate.usuario.contacts.first(where: {$0.name == temp.name} )
            let pos: Int! = appDelegate.usuario.contacts.index(of: c!)
            
            
                favorite = UITableViewRowAction(style: .normal, title: "💔 Quitar Favorito") { action, index in
                    favorite.backgroundColor = UIColor.darkGray
                    
                    appDelegate.usuario.contacts[pos].isFavorite = false
                    
                    let conToDel: Int! = appDelegate.usuario.contacts.index(of: c)
                    
                    appDelegate.usuario.favContacts.remove(at: conToDel)
                    self.tableView.reloadData()
                    self.showMessage(text: "Contacto eliminado de favoritos")
      
                }

        }
 
        
        favorite.backgroundColor = UIColor.purple
        
        return [favorite]
    }*/
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
                return nil }
        print("IndexPath: " + String(indexPath.item))
        
        guard let detailViewController =
            storyboard?.instantiateViewController(
                withIdentifier: "ContactDetail") as?
            ContactDetailViewController else { return nil }
        
        if isSearching {
            detailViewController.contacto = filteredContacts[(indexPath as NSIndexPath).row]
        } else {
            detailViewController.contacto = contacts[(indexPath as NSIndexPath).row]
        }
        
        
        
        print("Contacto: " + contacts[(indexPath as NSIndexPath).row].name)
        detailViewController.preferredContentSize =
            CGSize(width: 0.0, height: 600)
        
        previewingContext.sourceRect = cell.frame
        
        
        
        
        return detailViewController
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
  /*  func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [Contacto]?) -> Void) {
        var contacts = [Contacto]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = Contacto(cnContact: cnContact) { if (contact.isFavorite) {contacts.append(contact)} }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }*/
    
    func showAlert(_ sender: Any, text: String) {
        let alertController = UIAlertController(title: "Alerta", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private instance methods SEARCH
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            
            tableView.reloadData()
        } else {
            isSearching = true
            filteredContacts = contacts.filter({( contact : Contacto) -> Bool in
                var a: Bool = contact.name.lowercased().contains(searchText.lowercased())
                
                return a })
            
            tableView.reloadData()
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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



