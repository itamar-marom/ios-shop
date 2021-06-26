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
    
    @IBOutlet weak var progressIcon: UIActivityIndicatorView!
    
    @IBAction func noType(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func joinButton(_ sender: Any) {
        view.endEditing(true)
        print("ACTION: register user:")
        print("-- email: " + userEmail.text!)
        print("-- name: " + userName.text!)
        if (userEmail.text != "") && (userName.text != "") && (userPassword.text != "") {
            progressIcon.startAnimating()
            Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!) { authResult, error in
                if let error = error {
                    print("---- ERROR: REGISTER: \(error)")
                    let alert = UIAlertController(title: "ERROR", message: "Something went wrong... please make sure your email is valid and your password is longer than 6 characters", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("---- REGISTER: SUCCESS: " + self.userEmail.text!)
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.userName.text
                    changeRequest?.commitChanges { (error) in
                        if let error = error {
                            print("---- ERROR: name: failed to update: \(error)")
                            let alert = UIAlertController(title: "ERROR", message: "Something went wrong... please try again", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
            progressIcon.stopAnimating()
        } else {
            print("---- ERROR: REGISTER: some information is missing")
            let alert = UIAlertController(title: "ERROR", message: "Someinformation is missing. please fill entire form.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressIcon.hidesWhenStopped = true
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
