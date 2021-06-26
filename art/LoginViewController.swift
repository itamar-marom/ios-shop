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
    
    @IBOutlet weak var processIcon: UIActivityIndicatorView!
    
    @IBAction func noType(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        view.endEditing(true)
        print("ACTION: login user:")
        print("-- email: " + userEmail.text!)
        if (userEmail.text != "") && (userPassword.text != "") {
            processIcon.startAnimating()
            Auth.auth().signIn(withEmail: userEmail.text!, password: userPassword.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
                if let error = error {
                    print("---- ERROR: LOGIN: \(error)")
                    let alert = UIAlertController(title: "ERROR", message: "Name or password is incorrect, please try again", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
                    strongSelf.present(alert, animated: true, completion: nil)
                } else {
                    print("---- LOGIN: SUCCESS: " + strongSelf.userEmail.text!)
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            print("---- ERROR: REGISTER: some information is missing")
            let alert = UIAlertController(title: "ERROR", message: "Some information is missing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { action in}))
            self.present(alert, animated: true, completion: nil)
        }
        
        processIcon.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        processIcon.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        print("ACTION: authenticating user")
        if let user = user {
            print("-- AUTH: User logged in")
            navigationController?.popViewController(animated: true)
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

}
