//
//  RecordatoriosTableViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 11/12/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import EventKit

class RecordatoriosTableViewController: UITableViewController {
    
    let eventStore = EKEventStore()
    var proCal: EKCalendar?
    var calendars: [EKCalendar]?
    
    var reminders = [EKReminder]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tableData = NSArray()

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
            self.loadReminders()
            self.refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("No hay acceso a calendario")
            self.requestAccessToCalendarsAfterDenied()
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let status = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            self.requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            print("Autorización de acceso a recordatorios exitosa")
            self.loadReminders()
            self.refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("No hay acceso a calendario")
            self.requestAccessToCalendarsAfterDenied()
            
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    
            return self.reminders.count
      
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "dd/MMMM/yyy HH:mm"
        
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        
      
        
        let title = reminders [indexPath.row].title
        
        
        
        let dueStr = formatter.string(from: (reminders[indexPath.row].dueDateComponents?.date!)!)
        
        let detail = dueStr + " " + reminders[indexPath.row].notes!
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        cell.detailTextLabel?.numberOfLines = 3
   
        
        return cell
        
        
        // Configure the cell...

      
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let predicado = eventStore.predicateForReminders(in: [proCal!])
        eventStore.fetchReminders(matching: predicado) { reminders in
            for r in reminders! {
                if r.title == self.reminders[indexPath.row].title && r.dueDateComponents == self.reminders[indexPath.row].dueDateComponents {
                    
                    do {
                       try self.eventStore.remove(r, commit: true)
                        self.reminders.remove(at: indexPath.row)
                    } catch {
                        print("Error al eliminar: \(error)")
                    }
                }
                
                
                
            }
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
           // eventStore.delet
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func loadReminders() {
        self.calendars = eventStore.calendars(for: EKEntityType.reminder)
       
        
        for cal in calendars! {
            if cal.title == "ProAgeing" {
                proCal = cal
                print("Calendar FOUND")
                break
            }
        }
        
        if proCal == nil {
            let nc = EKCalendar(for: .reminder, eventStore: eventStore)
            nc.title = "ProAgeing"
            nc.source = eventStore.defaultCalendarForNewReminders().source
            do {
                try eventStore.saveCalendar(nc, commit: true)
                proCal = nc
            } catch {
                print(error)
                print("####No se creo Calendario####")
            }
        }
        
        let predicado = eventStore.predicateForReminders(in: [proCal!])
        eventStore.fetchReminders(matching: predicado) { reminders in
            self.reminders.removeAll()
            for reminder in reminders! {
                
                self.reminders.append(reminder)
                print("Reminder: \(reminder)")
                
            }
            }
            
        
       
        print("Numero de recordatorios: \(self.reminders.count)")
        
    }
    
    func refreshTableView() {
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    var alertController: UIAlertController!
    func showMessage(text: String) {
        
        alertController = UIAlertController(title: "", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AllContactsTableViewController.dismissAlert), userInfo: nil, repeats: true)
        
        
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
    
    func requestAccessToCalendar() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadReminders()
                    self.tableView.reloadData()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    
                    self.tableView.reloadData()
                    
                })
            }
        })
    }
  
        
        @objc func dismissAlert() {
            // Dismiss the alert from here
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            
        }

    }


