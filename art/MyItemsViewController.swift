//
//  MyItemsViewController.swift
//  art
//
//  Created by Itamar Marom on 26/06/2021.
//

import UIKit
import Firebase

class MyItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var trashBtn: UIBarButtonItem!
    
    @IBOutlet weak var ItemsListTableView: UITableView!
    
    var UserIdLogged:String = "NO USER"
    
    var data = [Item]()
    var trashFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        Model.instance.notificationItemList.observe {
            self.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        print("ACTION: authenticating user")
        if let user = user {
            print("-- AUTH: User logged in")
            UserIdLogged = user.uid
        } else {
            print("-- AUTH: user not logged in")
//            performSegue(withIdentifier: "fromAccountToLogin", sender: self)
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                self.reloadData()
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
            destinationVC.userId = itemSelected.userId ?? ""
        }
    }
}
