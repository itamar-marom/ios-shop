//
//  ShopViewController.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var shopListTableView: UITableView!
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shopListTableView.dequeueReusableCell(withIdentifier: "shopListCell", for: indexPath) as! ShopListTableViewCell
        cell.productName.text = "ESSENTIALS"
        cell.productPrice.text = "400$"
        return cell
    }
}
