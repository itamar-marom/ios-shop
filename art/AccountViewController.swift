//
//  AccountViewController.swift
//  art
//
//  Created by Itamar Marom on 20/06/2021.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var USerEmailTextField: UITextField!
    @IBOutlet weak var UserPasswordTextField: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
}
