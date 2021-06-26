//
//  ViewItemViewController.swift
//  art
//
//  Created by admin on 21/06/2021.
//

import UIKit
import Kingfisher
import Firebase

class ViewItemViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    var itemId:String?
    var imageUrl:String?
    var itemName:String?
    var itemPrice:String?
    var itemSize:String?
    var itemEmail:String?
    var userId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let text = itemName {
            name.text = itemName
        }
//        print(name.text)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        print("viewItemViewController: ACTION: authenticating user")
        if let user = user {
            print("viewItemViewController: -- AUTH: User logged in")
            print("USERID: \(userId)")
            print("LOGGEDID: \(user.uid)")
            if (userId != user.uid) {
                editButton.isHidden = true
            }
            
        } else {
            print("viewItemViewController: -- AUTH: user not logged in")
            editButton.isHidden = true
        }
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
            destinationVC.UserEmailLogged = itemEmail ?? ""
        }
    }

}
