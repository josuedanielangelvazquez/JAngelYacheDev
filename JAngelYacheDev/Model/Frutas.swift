//
//  File.swift
//  JAngelYacheDev
//
//  Created by Daniel Angel on 11/03/23.
//

import Foundation
struct Frutas {
    var Id : Int
    var Clave : Int
    var Nombre : String
    var Imagen : String
    var Precio : Precios
    var FechaRegistro : String
    var FechaActualizacion : String
    
}
struct Precios : Codable{
    var PrecioKg : Double
    var PrecioMkg : Double
    var PrecioDocena : Double
}

