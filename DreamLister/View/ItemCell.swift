//
//  ItemCell.swift
//  DreamLister
//
//  Created by Kimia Yazdani on 7/6/23.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbUIImage: UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DetailsLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    func configureCell(item: Item) {
        TitleLbl.text = item.title
        DetailsLbl.text = item.details
        priceLbl.text = "$\(item.price)"
        thumbUIImage.image = item.toImage?.image as? UIImage
        self.accessoryType = item.finished ? .checkmark : .none
    }
}
