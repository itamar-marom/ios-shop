//
//  RegisterViewController.swift
//  art
//
//  Created by Itamar Marom on 21/06/2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func joinButton(_ sender: Any) {
        print("ACTION: register user:")
        print("-- email: " + userEmail.text!)
        print("-- name: " + userName.text!)
        if (userEmail.text != "") && (userName.text != "") && (userPassword.text != "") {
            Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!) { authResult, error in
                if let error = error {
                    print("---- ERROR: REGISTER: \(error)")
                } else {
                    print("---- REGISTER: SUCCESS: " + self.userEmail.text!)
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.userName.text
                    changeRequest?.commitChanges { (error) in
                      print("---- ERROR: name: failed to update")
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            print("---- ERROR: REGISTER: some information is missing")
        }
    }
    
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

}
