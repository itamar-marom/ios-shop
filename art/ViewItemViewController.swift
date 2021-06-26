//
//  ViewItemViewController.swift
//  art
//
//  Created by admin on 21/06/2021.
//

import UIKit
import Kingfisher

class ViewItemViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var itemId:String?
    var imageUrl:String?
    var itemName:String?
    var itemPrice:String?
    var itemSize:String?
    var itemEmail:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = itemName {
            name.text = itemName
        }
        print(name.text)
        if let text = itemPrice {
            price.text = itemPrice
        }
        if let text = itemSize {
            size.text = itemSize
        }
        if let text = itemEmail {
            email.text = itemEmail
        }
        image.kf.setImage(with: URL(string: imageUrl ?? ""))
//        image = UIImageView(image: UIImage(named: "tray"))
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditItemSegueId") {
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC:AddItemViewController = segue.destination as! AddItemViewController
            destinationVC.isEditingMode = true
            destinationVC.editItemId = itemId ?? ""
            destinationVC.editItemName = name.text ?? ""
            destinationVC.editItemPrice = price.text ?? ""
            destinationVC.editItemSize = size.text ?? ""
            destinationVC.editedImage = imageUrl ?? ""
            destinationVC.editedItemUserEmail = itemEmail ?? ""
        }
    }

}
