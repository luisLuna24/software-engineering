//
//  Contacto.swift
//  ProAgeing
//
//  Created by Luis Luna on 9/8/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import AddressBook
import Contacts

class Contacto: NSObject, NSCoding {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var name: String!
    var email: String?
    var phone: String?
    var image: UIImage?
    var isFavorite = false
    var lastCalled = false
    
    func newLastCalled() {
        //Buscar el anterior last called en lista de todos y favoritos del usuario, verificar si existe o si es self
        
        //checar anterior contacto last called en todos
       /* for contact in appDelegate.usuario.contacts {
            if (contact.lastCalled) {
                contact.lastCalled = false
            }
        }
        //checar anterior contacto last called en favoritos
        for contact in appDelegate.usuario.favContacts {
            if (contact.lastCalled) {
                contact.lastCalled = false
            }
        }
        
        //hacer este contacto a lastcalled en todos
        
        for contact in appDelegate.usuario.contacts {
            if (contact.name == self.name && contact.phone == self.phone) {
                contact.lastCalled = true
            }
        }
        //hacer este contacto a lastcalled en favoritod
        for contact in appDelegate.usuario.favContacts {
            if (contact.name == self.name && contact.phone == self.phone) {
                contact.lastCalled = true
            }
        }*/
        
        appDelegate.usuario.setLastCalled(self)
   
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey:"name_Con")
        aCoder.encode(self.email, forKey:"email_Con")
        aCoder.encode(self.phone, forKey:"phone_Con")
        aCoder.encode(self.image, forKey:"image_Con")
        aCoder.encode(String(self.isFavorite), forKey:"isFavorite_Con")
        aCoder.encode(self.lastCalled, forKey:"lastCalled_Con")
        
       // print("ENCONDING \(self.name) IsFavorite = \(self.isFavorite)")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name_Con") as? String ?? "default"
        self.email = aDecoder.decodeObject(forKey: "email_Con") as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: "phone_Con") as? String ?? "default"
        self.image = aDecoder.decodeObject(forKey: "image_Con") as? UIImage ?? nil
        var fav = aDecoder.decodeObject(forKey: "isFavorite_Con") as? String ?? "false"
        self.isFavorite = Bool(fav)!
        
    
        //print("DECODING \(self.name) isFavorite \(self.isFavorite)")
        //print("CONTACTO last Called \(self.name) \(self.lastCalled)")
        
    }
    

    
    init(name: String, email: String?, phone: String?, image: UIImage?) {
        self.name = name
        self.email = email
        self.phone = phone
        self.image = image
    }
    
 
    init?(addressBookEntry: CNContact) {
        super.init()
        
        // get AddressBook references (old-style)
        guard let nameRef = ABRecordCopyCompositeName(addressBookEntry)?.takeRetainedValue() else { return nil }
        
        // name
        self.name = nameRef as String
        
        // emails
        if let emailsMultivalueRef = ABRecordCopyValue(addressBookEntry, kABPersonEmailProperty)?.takeRetainedValue(), let emailsRef = ABMultiValueCopyArrayOfAllValues(emailsMultivalueRef)?.takeRetainedValue() {
            let emailsArray = emailsRef as NSArray
            for possibleEmail in emailsArray { if let properEmail = possibleEmail as? String , properEmail.isEmail() { self.email = properEmail; break } }
        }
        
       
        
        
        // image
        var image: UIImage?
        if ABPersonHasImageData(addressBookEntry) {
            image = UIImage(data: ABPersonCopyImageData(addressBookEntry).takeRetainedValue() as Data)
        }
        self.image = image ?? UIImage(named: "defaultUser")
        
        // phone
        if let phonesMultivalueRef = ABRecordCopyValue(addressBookEntry, kABPersonPhoneProperty)?.takeRetainedValue(), let phonesRef = ABMultiValueCopyArrayOfAllValues(phonesMultivalueRef)?.takeRetainedValue() {
            let phonesArray = phonesRef as NSArray
            if phonesArray.count > 0 { self.phone = phonesArray[0] as? String }
        }
        
    }
    
    @available(iOS 9.0, *)
    init?(cnContact: CNContact) {
        // name
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) && !cnContact.isKeyAvailable(CNContactFamilyNameKey) { return nil }
        self.name = (cnContact.givenName + " " + cnContact.familyName).trimmingCharacters(in: CharacterSet.whitespaces)
        // image
        self.image = (cnContact.isKeyAvailable(CNContactImageDataKey) && cnContact.imageDataAvailable) ? UIImage(data: cnContact.imageData!) : nil
        // email
        if cnContact.isKeyAvailable(CNContactEmailAddressesKey) {
            for possibleEmail in cnContact.emailAddresses {
                let properEmail = possibleEmail.value as String
                if properEmail.isEmail() { self.email = properEmail; break }
            }
        }
        // phone
        if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if cnContact.phoneNumbers.count > 0 {
                let phone = cnContact.phoneNumbers.first?.value
                self.phone = phone?.stringValue
            }
        }
    }
    

}

