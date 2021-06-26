//
//  AccountViewController.swift
//  art
//
//  Created by Itamar Marom on 20/06/2021.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var trashBtn: UIBarButtonItem!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var USerEmailTextField: UITextField!
    @IBOutlet weak var UserPasswordTextField: UITextField!
    
    @IBOutlet weak var ItemsListTableView: UITableView!
    
    @IBOutlet weak var progressIcon: UIActivityIndicatorView!
    
    var UserIdLogged:String = "NO USER"
    
    @IBAction func noType(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func SaveInfoButton(_ sender: Any) {
        view.endEditing(true)
        print("ACTION: update information:")
        
        let user = Auth.auth().currentUser
        
        let newName = UserNameTextField.text
        let newEmail = USerEmailTextField.text
        let newPassword = UserPasswordTextField.text
        
        var isAlert = false
        
        progressIcon.startAnimating()
        
        if (newName != "") && (newName != user?.displayName) {
            print("-- UPDATE: name: " + newName!)
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = newName
            changeRequest?.commitChanges { (error) in
                if let error = error {
                    print("---- ERROR: name: failed to update: \(error)")
                    let alert = UIAlertController(title: "ERROR", message: "Couldn't save your name", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
                    self.present(alert, animated: true, completion: nil)
                    isAlert = true
                }
            }
        }
        
        if (newEmail != "") && (newEmail != user?.email) {
            print("-- UPDATE: email: " + newEmail! )
            Auth.auth().currentUser?.updateEmail(to: newEmail!) { (error) in
                if let error = error {
                    print("---- ERROR: email: failed to update: \(error)")
                    if (!isAlert) {
                        let alert = UIAlertController(title: "ERROR", message: "Couldn't save your email, make sure it's valid", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
                        self.present(alert, animated: true, completion: nil)
                        isAlert = true
                    }
                }
            }
        }
        
        if (newPassword != "") {
            print("-- UPDATE: password: " + newPassword! )
            Auth.auth().currentUser?.updatePassword(to: newPassword!) { (error) in
                if let error = error {
                    print("---- ERROR: password: failed to update \(error)")
                    if (!isAlert) {
                        let alert = UIAlertController(title: "ERROR", message: "Couldn't save your password, make sure is larger than 6 characters", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
                        self.present(alert, animated: true, completion: nil)
                        isAlert = true
                    }
                }
            }
        }
        
        UserNameTextField.text = ""
        USerEmailTextField.text = ""
        UserPasswordTextField.text = ""
        
        progressIcon.stopAnimating()
    }
    
    @IBAction func SignOutButton(_ sender: Any) {
        progressIcon.startAnimating()
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "fromAccountToLogin", sender: self)
        } catch let signOutError as NSError {
            print ("ERROR: SIGN OUT: %@", signOutError)
            let alert = UIAlertController(title: "ERROR", message: "Couldn't sign you out, please try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
            self.present(alert, animated: true, completion: nil)
        }
        progressIcon.stopAnimating()
    }
    
    var data = [Item]()
    var trashFlag = false
    
    @IBAction func trashAction(_ sender: Any) {
        trashFlag = !trashFlag
        ItemsListTableView.setEditing(trashFlag, animated: true)
        if (trashFlag) {
            trashBtn.image = UIImage(systemName: "multiply.circle.fill")
            self.navigationItem.rightBarButtonItem = trashBtn
        } else {
            trashBtn.image = UIImage(systemName: "trash")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        Model.instance.notificationItemList.observe {
            self.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func reloadData() {
        Model.instance.getAllItems() { items in
            var userItems = [Item]()
            for item in items {
                if item.userId == self.UserIdLogged {
                    userItems.append(item)
                }
            }
            self.data = userItems
            self.ItemsListTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        print("ACTION: authenticating user")
        if let user = user {
            print("-- AUTH: User logged in")
            UserNameLabel.text = user.displayName
            UserNameTextField.attributedPlaceholder = NSAttributedString(string: user.displayName ?? "")
            USerEmailTextField.attributedPlaceholder = NSAttributedString(string: user.email!)
            UserIdLogged = user.uid
        } else {
            print("-- AUTH: user not logged in")
            performSegue(withIdentifier: "fromAccountToLogin", sender: self)
        }
        
        progressIcon.hidesWhenStopped = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data)
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ItemsListTableView.dequeueReusableCell(withIdentifier: "AccountListCell", for: indexPath) as! AccountItemTableViewCell
        let item = data[indexPath.row]
        cell.ItemName.text = item.name
        cell.ItemPrice.text = (item.price ?? "0") + "$"
        
        let url = URL(string: item.image ?? "")
        cell.ItemImage.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return trashFlag
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            let i = indexPath.row
            Model.instance.delete(item: data[i]){
                let alert = UIAlertController(title: "Success", message: "item Deleted!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromAccountToView") {
            let selectedIndex = ItemsListTableView.indexPath(for: sender as! UITableViewCell)
            let itemSelected = data[selectedIndex?.row ?? 0]
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC:ViewItemViewController = segue.destination as! ViewItemViewController
            destinationVC.itemId = itemSelected.id ?? ""
            destinationVC.itemName = itemSelected.name ?? ""
            destinationVC.itemPrice = itemSelected.price ?? ""
            destinationVC.itemSize = itemSelected.size ?? ""
            destinationVC.itemEmail = itemSelected.email ?? ""
            destinationVC.imageUrl = itemSelected.image ?? ""
            
        }
    }
}
