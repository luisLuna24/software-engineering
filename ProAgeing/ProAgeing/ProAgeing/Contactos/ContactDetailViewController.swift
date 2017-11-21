//
//  ContactDetailViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 9/15/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
   // @IBOutlet weak var viewDetail: UIView!
    
    var contacto: Contacto!
    var index: Int!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    @IBOutlet weak var addFabLabel: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgCon: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelTelefono: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* viewDetail.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        viewDetail.backgroundColor = UIColor.clear*/
       
        labelName.text = contacto.name
        labelEmail.text = contacto.email
        if contacto.image != nil {
            imgCon.image = contacto.image
        }
        labelTelefono.text = contacto.phone
        if contacto.isFavorite {
            addFabLabel.isHidden = false
        } else {
            addFabLabel.isHidden = true
        }
       

        // Do any additional setup after loading the view.
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var previewActionItems: [UIPreviewActionItem] {
        var action1: UIPreviewAction! = nil
        
        
        
        let con: Int! = appDelegate.usuario.contacts.index(of: contacto)
        
        print("El contacto \(appDelegate.usuario.contacts[con]) es favorito? = \(appDelegate.usuario.contacts[con].isFavorite)")
        
        if appDelegate.usuario.contacts[con].isFavorite {
            action1 = UIPreviewAction(title: "💔 Quitar de Favoritos", style: .default,  handler: { previewAction, viewController in
                self.appDelegate.usuario.contacts[con].isFavorite = false
                let conToDel: Int! = self.appDelegate.usuario.favContacts.index(of: self.appDelegate.usuario.contacts[con])
                self.appDelegate.usuario.favContacts.remove(at: conToDel)
            })
        } else {
            action1 = UIPreviewAction(title: "❤️ Agregar a Favoritos", style: .default,  handler: { previewAction, viewController in
                self.appDelegate.usuario.contacts[con].isFavorite = true
                self.appDelegate.usuario.favContacts.append(self.appDelegate.usuario.contacts[con])
            })
            
        }
        
        let action2 = UIPreviewAction(title: "☎️ Llamar", style: .default, handler:
        {previewAction, viewController in
            
            var number: String? = self.contacto.phone
            if (number != nil) {
                number = number?.removingWhitespaces()
                let call = "tel://" + number!
                TelefonoViewController.open(scheme: call)
            } else {
                self.showAlert(self, text: "Contacto seleccionado no tiene un número telefónico.")
            }

                    })
        
        return [action1, action2]
    }
    
    func showAlert(_ sender: Any, text: String) {
        let alertController = UIAlertController(title: "Alerta", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
