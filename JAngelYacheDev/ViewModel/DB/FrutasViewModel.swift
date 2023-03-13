//
//  FrutasViewModel.swift
//  JAngelYacheDev
//
//  Created by Daniel Angel on 11/03/23.
//

import Foundation
import SQLite3
class FrutasViewModel{
    let frutasModel : Frutas? = nil
    func Update(fruta : Frutas)->Result{
        var result = Result()
        let context = DB.init()
        let query = "UPDATE Frutas SET(Clave, ArrayPrecios, Nombre, FechaModificacion, Imagen)  = (?, ?, ?, ?, ?) WHERE (IdFruta = \(fruta.Id))"
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK{
                sqlite3_bind_int(statement, 1, Int32(fruta.Clave))
                 let precios = codefrutas(precios: fruta.Precio)
                sqlite3_bind_text(statement, 2, (precios! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (fruta.Nombre as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 4, (fruta.FechaActualizacion as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 5, (fruta.Imagen as NSString).utf8String, -1, nil)

                if sqlite3_step(statement) == SQLITE_DONE{
                    result.Correct = true
                }
                else
                {
                    result.Correct = false
                }
            }
        }
        catch let error{
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
        }
        
        return result
    }
    
    func Add(frutas : Frutas)->Result{
        var result = Result(Correct: false)
        let context = DB.init()
        let query = "Insert INTO Frutas(Clave, ArrayPrecios, Nombre, FechaRegistro, FechaModificacion, Imagen) VALUES(?,?,?,?,?,?)"
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK{
                sqlite3_bind_int(statement, 1, Int32(frutas.Clave))
                 let precios = codefrutas(precios: frutas.Precio)
                sqlite3_bind_text(statement, 2, (precios! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (frutas.Nombre as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 4, (frutas.FechaRegistro as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 5, (frutas.FechaActualizacion as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 6, (frutas.Imagen as NSString).utf8String, -1, nil)
                if sqlite3_step(statement) == SQLITE_DONE{
                    result.Correct = true
                }
                else
                {
                    result.Correct = false
                }
            }
        } catch let error{
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
        }
        return result
    }
    
    func codefrutas(precios: Precios)->String?{
        do {
            let jsonData = try JSONEncoder().encode(precios)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
           return jsonString
        } catch { print(error)
            return nil
        }
    }
    func getById(IdFruta : Int)->Result{
        var result = Result()
        let context = DB.init()
        let query = "SELECT IdFruta, Clave, Nombre, ArrayPrecios, FechaRegistro, FechaModificacion, Imagen FROM Frutas WHERE (IdFruta = \(IdFruta))"
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK{
                result.Object
                if sqlite3_step(statement) == SQLITE_ROW{
                    var precios = Precios(PrecioKg: 0.0, PrecioMkg: 0.0, PrecioDocena: 0.0)
                    var fruta = Frutas(Id: 0, Clave: 0, Nombre: "", Imagen: "", Precio: precios, FechaRegistro: "", FechaActualizacion: "")
                    
                    fruta.Id = Int(sqlite3_column_int(statement, 0))
                    fruta.Clave = Int(sqlite3_column_int(statement, 1))
                    fruta.Nombre = String(cString: sqlite3_column_text(statement, 2))
                    let preciosdata = String(cString: sqlite3_column_text(statement, 3))
                    let safedata = preciosdata.data(using: .utf8)!
                    let precio = jsondecoder(data: safedata)
                    fruta.Precio = precio!
                    fruta.FechaRegistro = String(cString: sqlite3_column_text(statement, 4))
                    fruta.FechaActualizacion = String(cString: sqlite3_column_text(statement, 5))
                    if sqlite3_column_text(statement, 6) !=  nil{
                        fruta.Imagen = String(cString: sqlite3_column_text(statement, 6))
                    }
                    else{
                        fruta.Imagen = ""
                    }
                    
                    result.Object = fruta
                    

                }
                result.Correct = true
               
            }
        }
        catch let error {
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
        }
        sqlite3_finalize(statement)
        sqlite3_close(context.db)
        return result
    }
    
    func getAll()-> Result{
        
        var result = Result()
        let context = DB.init()
        let query = "SELECT  IdFruta, Clave, ArrayPrecios, Nombre, FechaRegistro, FechaModificacion, Imagen FROM Frutas"
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK{
                result.Objects = []
                while sqlite3_step(statement) == SQLITE_ROW{
                    var precios = Precios(PrecioKg: 0.0, PrecioMkg: 0.0, PrecioDocena: 0.0)
                    var frutas = Frutas(Id: 0, Clave: 0, Nombre: "", Imagen: "", Precio: precios, FechaRegistro: "", FechaActualizacion: "")
                    frutas.Id = Int(sqlite3_column_int(statement, 0))
                    frutas.Clave = Int(sqlite3_column_int(statement, 1))
                    let preciosdata = String(cString: sqlite3_column_text(statement, 2))
                    let safedata = preciosdata.data(using: .utf8)!
                    frutas.Precio =  jsondecoder(data: safedata)!
                    frutas.Nombre = String(cString: sqlite3_column_text(statement, 3))
                    frutas.FechaRegistro = String(cString: sqlite3_column_text(statement, 4))
                    frutas.FechaActualizacion = String(cString: sqlite3_column_text(statement, 5))
                    if sqlite3_column_text(statement, 6) !=  nil{
                        frutas.Imagen = String(cString: sqlite3_column_text(statement, 6))
                    }
                    else{
                        frutas.Imagen = ""
                    }
                    result.Objects?.append(frutas)
                }
                result.Correct = true
                
            }
          
        }  catch let error {
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
        }
        return result
    }
    func DELETE(idfruta : Int)->Result{
        var result = Result()
        let context = DB.init()
        let query = "DELETE FROM Frutas WHERE(IdFruta = \(idfruta))"
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK{
                result.Correct = true
                print("ELIMINADO")
                if sqlite3_step(statement) == SQLITE_DONE{
                    result.Correct = true
                    print("Correcto")
                }
                else{
                    result.Correct = false
                    print("Error")
                }
            }
            
        }
        catch let error {
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
            print(result.ErrorMessage)
        }
        return result
    }
    func GetByNombre(nombreFruta :  String)-> Result{
        var result = Result()
        let context = DB.init()
        let query = "SELECT  IdFruta, Clave, ArrayPrecios, Nombre, FechaRegistro, FechaModificacion, Imagen FROM Frutas WHERE Nombre LIKE LTRIM(RTRIM('\(nombreFruta)')||'%')"
        var statement : OpaquePointer? = nil
        do{
            if try sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK{
                result.Objects = []
                while sqlite3_step(statement) == SQLITE_ROW{
                    var precios = Precios(PrecioKg: 0.0, PrecioMkg: 0.0, PrecioDocena: 0.0)
                    var frutas = Frutas(Id: 0, Clave: 0, Nombre: "", Imagen: "", Precio: precios, FechaRegistro: "", FechaActualizacion: "")
                    frutas.Id = Int(sqlite3_column_int(statement, 0))
                    frutas.Clave = Int(sqlite3_column_int(statement, 1))
                    let preciosdata = String(cString: sqlite3_column_text(statement, 2))
                    let safedata = preciosdata.data(using: .utf8)!
                    frutas.Precio =  jsondecoder(data: safedata)!
                    frutas.Nombre = String(cString: sqlite3_column_text(statement, 3))
                    frutas.FechaRegistro = String(cString: sqlite3_column_text(statement, 4))
                    frutas.FechaActualizacion = String(cString: sqlite3_column_text(statement, 5))
                    if sqlite3_column_text(statement, 6) !=  nil{
                        frutas.Imagen = String(cString: sqlite3_column_text(statement, 6))
                    }
                    else{
                        frutas.Imagen = ""
                    }
                    result.Objects?.append(frutas)
                    
                }
                result.Correct = true
            }
        }
        catch let error{
            result.Correct = false
        }
        return result
    }
    func jsondecoder(data: Data)->Precios?{
        let decodable = JSONDecoder()
        do{
            let request = try decodable.decode(Precios.self, from: data)
            let precios = Precios(PrecioKg: request.PrecioKg, PrecioMkg: request.PrecioMkg, PrecioDocena: request.PrecioDocena)
            return precios
        }
        catch let error{
            print("error en la decodificacion")
            print(error.localizedDescription)
            return nil
        }
        
    }
    
}
