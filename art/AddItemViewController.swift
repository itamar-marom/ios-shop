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
        let item = Item.create(json: ["name": itemName.text!, "size": itemSize.text!])!
        Model.instance.add(item: item)
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
