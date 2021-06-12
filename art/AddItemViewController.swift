//
//  AddItemViewController.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var itemId: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemSize: UITextField!
    @IBOutlet weak var createEditHeader: UILabel!
    @IBOutlet weak var craeteEditBtn: UIButton!
    
    var editItemId:String = ""
    var editItemName:String = ""
    var editItemSize:String = ""
    var editItemPrice:String = ""
    var isEditingMode:Bool = false
    
    @IBAction func addItemClick(_ sender: Any) {
        if (isEditingMode){
            let item = Item.create(json: ["id": editItemId, "name": itemName.text!, "size": itemSize.text!, "price": itemPrice.text!])!
            Model.instance.update(item: item){
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let item = Item.create(json: ["id": itemId.text!, "name": itemName.text!, "size": itemSize.text!, "price": itemPrice.text!])!
            Model.instance.add(item: item){
                self.initForm()
                let alert = UIAlertController(title: "Success", message: "item Saved!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
                self.present(alert, animated: true, completion: nil)
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isEditingMode) {
            createEditHeader.text = "YOUR CREATION"
            craeteEditBtn.setTitle("EDIT", for: .normal)
            
            itemId.isHidden = true
            itemName.text = editItemName
            itemSize.text = editItemSize
            itemPrice.text = editItemPrice
        }
    }
    
    func initForm() {
        itemId.text = ""
        itemName.text = ""
        itemSize.text = ""
        itemPrice.text = ""
    }
    
}
