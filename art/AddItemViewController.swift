//
//  AddItemViewController.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//

import UIKit
import Kingfisher
import Firebase

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var itemId: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemSize: UITextField!
    @IBOutlet weak var createEditHeader: UILabel!
    @IBOutlet weak var craeteEditBtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var editItemId:String = ""
    var editItemName:String = ""
    var editItemSize:String = ""
    var editItemPrice:String = ""
    var editedImage:String = ""
    var isEditingMode:Bool = false
    
    var newImage: UIImage?
    
    @IBAction func addItemClick(_ sender: Any) {
        if self.image.image != nil{
            Model.instance.saveImage(image: self.image.image!) { (url) in
                self.saveItem(url: url)
            }
        }else{
            self.saveItem(url: "")
        }

    }
    
    func saveItem(url:String) {
        if (isEditingMode){
            let item = Item.create(json: ["id": editItemId, "name": itemName.text!, "size": itemSize.text!, "price": itemPrice.text!, "image": url])!
            Model.instance.add(item: item){
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            let item = Item.create(json: ["id": itemId.text, "name": itemName.text!, "size": itemSize.text!, "price": itemPrice.text!, "image": url])!
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
            image.kf.setImage(with: URL(string: editedImage))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser
        print("ACTION: authenticating user")
        if let user = user {
            print("-- AUTH: User logged in")
        } else {
            print("-- AUTH: user not logged in")
            performSegue(withIdentifier: "fromCreateToLogin", sender: self)
        }
    }
    
    func initForm() {
        itemId.text = ""
        itemName.text = ""
        itemSize.text = ""
        itemPrice.text = ""
        image.image = UIImage(named: "tray")
    }
    
    @IBAction func editImage(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
         imagePicker.allowsEditing = true
         self.present(imagePicker, animated: true, completion: nil)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
               imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.image.image = newImage
        self.dismiss(animated: true, completion: nil)
    }
    
}
