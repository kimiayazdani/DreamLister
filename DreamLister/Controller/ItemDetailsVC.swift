//
//  ItemDetailsView.swift
//  DreamLister
//
//  Created by Kimia Yazdani on 7/6/23.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var DetailsField: UITextField!
    @IBOutlet weak var PriceField: UITextField!
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var thumbImgView: UIImageView!
    @IBOutlet weak var finishedSwitch: UISwitch!
    
    var stores = [Store]()
    var itemToEdit: Item?
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        TitleField.delegate = self
        DetailsField.delegate = self
        PriceField.delegate = self

        
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    // Pickerview Functions
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO: fill later
    }
    
    // Handle Data
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
        } catch {
            let error = error as NSError
            
            print("\(error.localizedDescription.debugDescription)")
        }
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            TitleField.text = item.title
            PriceField.text = "\(item.price)"
            DetailsField.text = item.details
            finishedSwitch.isOn = item.finished
            
            thumbImgView.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
                
            }
        }
        
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Actions
    
    @IBAction func imgBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func SaveBtnPressed(_ sender: Any) {
        
        let picture = Image(context: context)
        picture.image = thumbImgView.image
        
        
        
        var item: Item!
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
//       let item = Item(context: context)
        if let title = TitleField.text {
            item.title = title
        }
        if let price = PriceField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details = DetailsField.text {
            item.details = details
        }
        item.finished = finishedSwitch.isOn
        item.toStore = stores[ storePicker.selectedRow(inComponent: 0)]
        item.toImage = picture
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    // Image Handling
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            thumbImgView.image = image
        }
        imagePicker.dismiss(animated: true)
    }
}