//
//  FrutasTableViewCell.swift
//  JAngelYacheDev
//
//  Created by Daniel Angel on 12/03/23.
//

import UIKit
import SwipeCellKit

class FrutasTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var ImageFruits: UIImageView!
    @IBOutlet weak var idFruitlbl: UILabel!
    @IBOutlet weak var clavefruitlbl: UILabel!
    @IBOutlet weak var Nombrelbl: UILabel!
    @IBOutlet weak var Preciokglbl: UILabel!
    @IBOutlet weak var PrecioMkglbl: UILabel!
    @IBOutlet weak var Preciodocenalbl: UILabel!
    @IBOutlet weak var Fecharegistro: UILabel!
    @IBOutlet weak var FechaModificacion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
