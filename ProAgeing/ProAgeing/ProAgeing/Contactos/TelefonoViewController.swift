//
//  TelefonoViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 9/3/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit

class TelefonoViewController: UITableViewController, UIViewControllerPreviewingDelegate{
    
    var dataSource = TelefonoTableSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.prefersLargeTitles = true
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }

        
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
        cell.imageView?.image = sample.icon
        cell.textLabel?.font = UIFont(name: "Avenir", size: CGFloat(28))
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(15))
        cell.accessibilityHint = sample.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0; //Choose your custom row height
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seleccion = dataSource.examples[indexPath.row]
      /*  if let controller = sample.controller {
            navigationController?.pushViewController(controller, animated: true)
        }*/
        switch seleccion.title {
        
        case "Favoritos":
            self.performSegue(withIdentifier: "favoriteContacts", sender: AnyObject!.self)
        
        case "SOS":
            TelefonoViewController.open(scheme: "tel://911")
            break
        case "Todos":
            self.performSegue(withIdentifier: "todosContactos", sender: AnyObject!.self)
            break
        default:
             tableView.deselectRow(at: indexPath, animated: true)
        }
  
     
       
        
    }
    
   
    
    public static func open(scheme: String) {
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(scheme): \(success)")
            })
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
                return nil }
        print("IndexPath: " + String(indexPath.item))
        var detailViewController: UIViewController!
        
        
        switch indexPath.row {
        case 0:
            detailViewController = storyboard?.instantiateViewController(withIdentifier: "contactosFav") as! FavoritosTableViewController
        case 1:
            detailViewController = storyboard?.instantiateViewController(withIdentifier: "todosContactos") as! AllContactsTableViewController
    
        default:
            print("Default Preview")
        }
        
        
        detailViewController.preferredContentSize =
            CGSize(width: 0.0, height: 600)
        
        previewingContext.sourceRect = cell.frame
        
        return detailViewController
        
        
        
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    
}



struct TelefonoSource {
    let title: String
    let description: String
    let storyboardName: String
    let controllerID: String?
    let icon: UIImage
    
    
    init(title: String, description: String,
         storyboardName: String,
         controllerID: String? = nil, icon: UIImage) {
        self.title = title
        self.description = description
        self.storyboardName = storyboardName
        self.controllerID = controllerID
        self.icon = icon
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

struct TelefonoTableSource {
    lazy var examples: [TelefonoSource] = [TelefonoSource(title: "Favoritos",
                                            description: "Lista de sus contactos favoritos",
                                            storyboardName: "",
                                            icon: UIImage(named: "heart")!
                                            ),
                             
                                    TelefonoSource(title: "Todos",
                                            description: "Vea todos sus contactos",
                                            storyboardName: "",
                                            icon: UIImage(named: "contacts")!
                                            ),
                                    TelefonoSource(title: "SOS",
                                                   description: "Llamar al 911",
                                                   storyboardName: "",
                                                   icon: UIImage(named: "sos")!
                                        
                                        
                                        
                                    ),]
}

