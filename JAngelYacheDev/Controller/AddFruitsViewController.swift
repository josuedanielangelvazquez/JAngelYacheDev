//
//  AddFruitsViewController.swift
//  JAngelYacheDev
//
//  Created by Daniel Angel on 12/03/23.
//

import UIKit

class AddFruitsViewController: UIViewController {
    var frutasviewmodel = FrutasViewModel()
    var result = Result()
    var fruta = Frutas(Id: 0, Clave: 0, Nombre: "", Imagen: "", Precio: Precios(PrecioKg: 0.0, PrecioMkg: 0.0, PrecioDocena: 0.0), FechaRegistro: "", FechaActualizacion: "")
    var idFruta = 0
    let alerttrue = UIAlertController(title: "Correcto", message: "Se guardo correctamente", preferredStyle: .alert)
    let Ok = UIAlertAction(title: "Ok", style: .default)
    let alertfalse = UIAlertController(title: "Error", message: "Ocurrio un Error", preferredStyle: .alert)
    
    
    //edicion de datepickers
    
    @IBOutlet weak var icondate1: UIImageView!
    @IBOutlet weak var icondate2: UIImageView!
    @IBOutlet weak var labelregistro: UILabel!
    @IBOutlet weak var labelatualizacion: UILabel!
    //informacion
    
    @IBOutlet weak var Actualizarbutton: UIButton!
    @IBOutlet weak var AgregarButton: UIButton!
    @IBOutlet weak var FruitImage: UIImageView!
    @IBOutlet weak var IdText: UITextField!
    @IBOutlet weak var Clavetext: UITextField!
    @IBOutlet weak var PrecioKgtext: UITextField!
    @IBOutlet weak var PrecioMKgtext: UITextField!
    @IBOutlet weak var PrecioDocenatext: UITextField!
    @IBOutlet weak var RegistroDatePicker: UIDatePicker!
    @IBOutlet weak var UltimaModificacionDatePicker: UIDatePicker!
    
    @IBOutlet weak var NombreFruittext: UITextField!

    
    
    var dateviewmodel = DateViewModel()
    override func viewDidLoad() {
        alerttrue.addAction(Ok)
        alertfalse.addAction(Ok)
        super.viewDidLoad()
        validacion()
    }
    func validacion(){
        if idFruta != 0{
            AgregarButton.isHidden = true
            Actualizarbutton.isHidden = false
            let result = frutasviewmodel.getById(IdFruta: idFruta)
            if result.Correct == true{
                fruta = result.Object as! Frutas
                IdText.text = String(fruta.Id)
                Clavetext.text = String(fruta.Clave)
                NombreFruittext.text = fruta.Nombre
                PrecioKgtext.text = String(fruta.Precio.PrecioKg)
                PrecioMKgtext.text = String(fruta.Precio.PrecioMkg)
                PrecioDocenatext.text = String(fruta.Precio.PrecioDocena)
                let fecharegistro = fruta.FechaRegistro
                let fechaDate = DateFormatter()
                fechaDate.dateFormat = "dd/MM/yyyy HH:mm"
                fechaDate.date(from: fecharegistro)!
                RegistroDatePicker.date = fechaDate.date(from: fecharegistro)!
                let fechaModificacion = fruta.FechaActualizacion
                UltimaModificacionDatePicker.date = fechaDate.date(from: fechaModificacion)!
            }
            
        }
        else{
            Actualizarbutton.isHidden = true
            AgregarButton.isHidden = false
            RegistroDatePicker.isHidden = true
            UltimaModificacionDatePicker.isHidden = true
            icondate1.isHidden = true
            icondate2.isHidden = true
            labelregistro.isHidden = true
            labelatualizacion.isHidden = true
        }
    }
    func AddorUpdate(){
        NombreFruittext.backgroundColor = .white
        Clavetext.backgroundColor = .white
        PrecioKgtext.backgroundColor = .white
        PrecioMKgtext.backgroundColor = .white
        PrecioDocenatext.backgroundColor = .white
        var nombre = ""
        if NombreFruittext.text == nil || NombreFruittext.text == ""{
            NombreFruittext.backgroundColor = .red
            return
        }
        else{
            nombre = NombreFruittext.text!
        }
        guard let clavetext = Int(Clavetext.text!) else{
            Clavetext.backgroundColor = .red
            Clavetext.placeholder = "Ingrese la clave"
            return
        }
        
        guard let preciokg = Double(PrecioKgtext.text!) else{
            PrecioKgtext.backgroundColor = .red
            return
        }
        guard let preciomkg = Double(PrecioMKgtext.text!) else{
            PrecioMKgtext.backgroundColor = .red
            return
        }
        guard let precioDocena = Double(PrecioDocenatext.text!) else{
            PrecioDocenatext.backgroundColor = .red
            return
        }
        
        let fecharegistro = dateviewmodel.getDate()
        let precios = Precios(PrecioKg: preciokg, PrecioMkg: preciomkg, PrecioDocena: precioDocena)
        
        if idFruta == 0{
            result.Object = Frutas(Id: 0, Clave: clavetext, Nombre: nombre, Imagen: "", Precio: precios, FechaRegistro: fecharegistro, FechaActualizacion: fecharegistro)
            result = frutasviewmodel.Add(frutas: result.Object as! Frutas)
            if result.Correct == true{
                print("Correc")
                self.present(alerttrue, animated: true)
            }
            else{
                print("Error")
                self.present(alertfalse, animated: true)
            }}
        else{
            result.Object = Frutas(Id: idFruta, Clave: clavetext, Nombre: nombre, Imagen: "", Precio: precios, FechaRegistro: "", FechaActualizacion: fecharegistro)
            result = frutasviewmodel.Update(fruta: result.Object as! Frutas)
            if result.Correct == true{
                print("Correc")
                let alert = UIAlertController(title: "Correct", message: "Se actualizo correctamente", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
            else{
                print("Error")
                self.present(alertfalse, animated: true)
            }
            
        }
    }
    
    @IBAction func AddAction(_ sender: Any) {
        AddorUpdate()
    }
    
    @IBAction func ActualizarAction(_ sender: Any) {
        AddorUpdate()
      }
    
}


