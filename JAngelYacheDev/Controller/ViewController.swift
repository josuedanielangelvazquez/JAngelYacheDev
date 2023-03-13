//
//  ViewController.swift
//  JAngelYacheDev
//
//  Created by Daniel Angel on 11/03/23.
//

import UIKit
import SwipeCellKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    var frutasviewmodel = FrutasViewModel()
    var result = Result()
    var dateviewmodel = DateViewModel()
    var frutas = [Frutas]()
    var idFruta = 0
    @IBOutlet weak var SearchText: UITextField!
    
    @IBOutlet weak var FrutasTablewView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FrutasTablewView.delegate = self
        FrutasTablewView.dataSource = self
        view.addSubview(FrutasTablewView)
    self.FrutasTablewView.register(UINib(nibName: "FrutasTableViewCell", bundle: .main), forCellReuseIdentifier: "Frutascell")
   
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loaddatabyname(){
        if SearchText.text != nil || SearchText.text != ""{
            result = frutasviewmodel.GetByNombre(nombreFruta: SearchText.text!)
            if result.Correct!{
                frutas = result.Objects! as! [Frutas]
                FrutasTablewView.reloadData()
            }}
        else{
            SearchText.placeholder = "Ingrese una fruta valida"
        }
    }
    func loadData(){
         result = frutasviewmodel.getAll()
         if result.Correct!{
             frutas = result.Objects! as! [Frutas]
             FrutasTablewView.reloadData()
         }
         else{
             print("error")
             print(result.ErrorMessage)

         }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        frutas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Frutascell", for: indexPath as IndexPath) as! FrutasTableViewCell
        cell.delegate = self
        cell.idFruitlbl.text = String(frutas[indexPath.row].Id)
        cell.clavefruitlbl.text = "Clave:  \(frutas[indexPath.row].Clave)"
        cell.Nombrelbl.text = "Fruta:  \(frutas[indexPath.row].Nombre)"
        cell.Fecharegistro.text = "Registrado el :  \(frutas[indexPath.row].FechaRegistro)"
        cell.FechaModificacion.text = "Modificado el :  \(frutas[indexPath.row].FechaActualizacion)"
        cell.Preciokglbl.text = "Kg  $\(frutas[indexPath.row].Precio.PrecioKg)"
        cell.PrecioMkglbl.text = "Mk  $\(frutas[indexPath.row].Precio.PrecioMkg)"
        cell.Preciodocenalbl.text = "Docena  $\(frutas[indexPath.row].Precio.PrecioDocena)"
        if frutas[indexPath.row].Imagen == ""{
            cell.ImageFruits.image = UIImage(systemName: "doc.circle")
        }
        else{
            let imagedata = Data(base64Encoded: frutas[indexPath.row].Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            cell.ImageFruits.image = UIImage(data: imagedata!)
        }
        return cell
    }
    
    @IBAction func AddFruit(_ sender: Any) {
        performSegue(withIdentifier: "seguesAddFruits", sender: nil)
    }
    
    @IBAction func SearchAction(_ sender: Any) {
        
    loaddatabyname()
    }
    

}
extension ViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right{
            let deleteAction = SwipeAction(style: .destructive, title: "Delete"){ [self]
                action, indexPath in
                self.idFruta = self.frutas[indexPath.row].Id
                let result = self.frutasviewmodel.DELETE(idfruta: self.idFruta)
                if result.Correct == true{
                    self.loadData()
                    let alert = UIAlertController(title: "Ok", message: "Se elimino Correctamente", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
                else{
                    let alert = UIAlertController(title: "Alerta", message: "Ocurrio un Error", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
            }
            deleteAction.image = UIImage(systemName: "trash")
            return [deleteAction]
        }
        else{
            let UpdateAction = SwipeAction(style: .destructive, title: "Update"){
                action, indexPath in
                self.idFruta = self.frutas[indexPath.row].Id
                self.performSegue(withIdentifier: "seguesUpdateFruits", sender: nil)
            }
            UpdateAction.image = UIImage(systemName: "repeat")
            UpdateAction.backgroundColor = UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 1.00)
            return [UpdateAction]
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguesUpdateFruits"{
            let frutas = segue.destination as! AddFruitsViewController
            frutas.idFruta = self.idFruta
        }
    }
}

