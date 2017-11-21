//
//  DetalleMedicamentoViewController.swift
//  ProAgeing
//
//  Created by Luis Luna on 11/14/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit

class DetalleMedicamentoViewController: UIViewController {
    var med: Medicamento!
  
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var dosis: UILabel!
    //@IBOutlet weak var unidad: UILabel!
    @IBOutlet weak var intervalo: UILabel!
    @IBOutlet weak var proxRecordatorio: UILabel!
    @IBOutlet weak var viaAdmon: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        nombre.text = med.nombre
        dosis.text = med.dosis + " " + med.unidad
        
        intervalo.text = med.intervalo
        viaAdmon.text = med.viaAdmon
        proxRecordatorio.text = ""

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

}
