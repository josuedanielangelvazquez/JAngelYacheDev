//
//  DateViewModel.swift
//  JAngelYacheDev
//
//  Created by Daniel Angel on 12/03/23.
//

import Foundation
class DateViewModel{
    func getDate()->String{
        let date = Date()
          let dateformatter = DateFormatter()
          dateformatter.dateFormat = "dd/MM/yyyy HH:mm"
         let horamodificacion = dateformatter.string(from: date)
        return horamodificacion
    }
 
}
