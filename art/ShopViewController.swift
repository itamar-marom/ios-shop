//
//  ShopViewController.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var data = [Item]()
    
    @IBOutlet weak var shopListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()        
        Model.instance.notificationItemList.observe {
            self.reloadData()
        }
    }
    
    func reloadData() {
        Model.instance.getAllItems() { items in
            self.data = items
            self.shopListTableView.reloadData()
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
        let cell = shopListTableView.dequeueReusableCell(withIdentifier: "shopListCell", for: indexPath) as! ShopListTableViewCell
        let item = data[indexPath.row]
        cell.itemName.text = item.name
        cell.itemPrice.text = (item.price ?? "0") + "$"
        return cell
    }
}
