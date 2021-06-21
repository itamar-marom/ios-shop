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
    
    @IBAction func SaveInfoButton(_ sender: Any) {
        
        print("ACTION: update information:")
        
        let user = Auth.auth().currentUser
        
        let newName = UserNameTextField.text
        let newEmail = USerEmailTextField.text
        let newPassword = UserPasswordTextField.text
        
        if (newName != "") && (newName != user?.displayName) {
            print("-- UPDATE: name: " + newName!)
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = newName
            changeRequest?.commitChanges { (error) in
              print("---- ERROR: name: failed to update")
            }
        }
        
        if (newEmail != "") && (newEmail != user?.email) {
            print("-- UPDATE: email: " + newEmail! )
            Auth.auth().currentUser?.updateEmail(to: newEmail!) { (error) in
                print("---- ERROR: email: failed to update")
            }
        }
        
        if (newPassword != "") {
            print("-- UPDATE: password: " + newPassword! )
            Auth.auth().currentUser?.updatePassword(to: newPassword!) { (error) in
                if let error = error {
                    print("---- ERROR: password: failed to update \(error)")
                }
            }
        }
    }
    
    @IBAction func SignOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "fromAccountToLogin", sender: self)
        } catch let signOutError as NSError {
          print ("ERROR: SIGN OUT: %@", signOutError)
        }
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
            self.data = items
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
            UserNameTextField.text = user.displayName
            USerEmailTextField.text = user.email
        } else {
            print("-- AUTH: user not logged in")
            performSegue(withIdentifier: "fromAccountToLogin", sender: self)
        }
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
}
