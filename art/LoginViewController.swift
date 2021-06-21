//
//  LoginViewController.swift
//  art
//
//  Created by Itamar Marom on 21/06/2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        print("ACTION: login user:")
        print("-- email: " + userEmail.text!)
        if (userEmail.text != "") && (userPassword.text != "") {
            Auth.auth().signIn(withEmail: userEmail.text!, password: userPassword.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
                if let error = error {
                    print("---- ERROR: LOGIN: \(error)")
                } else {
                    print("---- LOGIN: SUCCESS: " + strongSelf.userEmail.text!)
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            print("---- ERROR: REGISTER: some information is missing")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
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
