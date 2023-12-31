//
//  TypeCell.swift
//  DreamLister
//
//  Created by Kimia Yazdani on 7/8/23.
//

import UIKit
import CoreData

class TypeCell: UITableViewCell, UITextViewDelegate {

    var itemType: Store!
    
    @IBOutlet weak var trashBtn: UIButton!
    
    @IBOutlet weak var typeName: UITextView!
    @IBOutlet weak var colorWell: UIColorWell!
    
    
    weak var delegate: TypeCellDelegate?
  
    
    
    
    func configureCell(itemType: Store) {
        self.itemType = itemType
        typeName.text = itemType.name
        colorWell.selectedColor = hexStringToUIColor(hex: itemType.color!)
        
        typeName.delegate = self
        typeName.isScrollEnabled = false
        typeName.isUserInteractionEnabled = true
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        typeName.endEditing(true)
        itemType.name = typeName.text.capitalized
        itemType.color = colorWell.selectedColor?.toHex()
        ad.saveContext()
    }
    
    
    
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
    // Handle Delete

    @IBAction func deleteBtnPressed(_ sender: Any) {
        
        delegate?.typeCellDidRequestDeletion(self)
        }
    
    
    // Handle Change Name
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
   

}






extension UIColor {
    func toHex() -> String? {
        guard let components = self.cgColor.components else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        let hex = String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        return hex
    }
    
    
}



protocol TypeCellDelegate: AnyObject {
    func typeCellDidRequestDeletion(_ cell: TypeCell)
}
