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
    @IBAction func addItemClick(_ sender: Any) {
        let item = Item.create(json: ["id": itemId.text!, "name": itemName.text!, "size": itemSize.text!, "price": itemPrice.text!])!
        Model.instance.add(item: item){
            self.navigationController?.popViewController(animated: true)
            let alert = UIAlertController(title: "Success", message: "item Saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
            self.present(alert, animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 0

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
