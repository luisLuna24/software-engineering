//
//  Medicamento.swift
//  ProAgeing
//
//  Created by Luis Luna on 10/26/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import Foundation

class Medicamento: NSObject {
    let nombre: String
    var dosis: Int
    var unidad: String
    var desde: Date
    var hasta: Date
    var intervalo: String
    
    
    init(nombre: String, dosis: Int, unidad: String, desde: Date, hasta: Date, intervalo: String) {
        
        self.nombre = nombre
        self.dosis = dosis
        self.unidad = unidad
        self.desde = desde
        self.hasta = hasta
        self.intervalo = intervalo
        
        
        
    }
    
    
    
    
    
}
