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
        priceLbl.text = "➶\(item.price)"
        thumbUIImage.image = item.toImage?.image as? UIImage
        
        let colorIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        if let store = item.toStore {
            colorIndicatorView.backgroundColor = hexStringToUIColor(hex: store.color!)
        }
        
        self.accessoryView = colorIndicatorView
        self.accessoryType = item.finished ? .checkmark : .none
    }
    
    // Utilities
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
