//
//  SignUpViewController.swift
//  Drunkard 1.0
//
//  Created by USER on 07.03.22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: UIButton) {
        
        self.emailField?.layer.borderWidth = 0 // used to reset the email and password fields so it can later be detected where the problem is
        self.passwordField?.layer.borderWidth = 0
        
        errorLabel.isHidden = true
        guard let email = emailField?.text! else {return}
        guard let password = passwordField?.text! else {return}
        
        switch (email, password) { // used for detecting and highliting where the problem is: the email, the password or both.
        case let (email, password) where password == "" && email == "":
            self.emailField?.layer.borderWidth = 3
            self.passwordField?.layer.borderWidth = 3
            self.passwordField?.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
            self.emailField?.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
            
        case let (email, password) where email == "" && password != "":
            self.emailField?.layer.borderWidth = 3
            self.emailField?.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor

        case let (email, password) where password == "" && email != "":
            self.passwordField?.layer.borderWidth = 3
            self.passwordField?.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor

        default:
            print("both email and password are present")
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                strongSelf.errorLabel.text = "\(error!.localizedDescription)"
                strongSelf.errorLabel.isHidden = false
                return
            }
            
            print("you have registered")
            
            self?.navigationController?.popViewController(animated: true)
            
        })
        
    }
    
}
