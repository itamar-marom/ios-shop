//
//  AccountViewController.swift
//  art
//
//  Created by Itamar Marom on 20/06/2021.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var USerEmailTextField: UITextField!
    @IBOutlet weak var UserPhoneTextField: UITextField!
    @IBOutlet weak var UserPasswordTextField: UITextField!
    
    @IBOutlet weak var ItemsListTableView: UITableView!
    
    @IBAction func SignOutButton(_ sender: Any) {
    }
    
    var data = [Item]()
    
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
}
