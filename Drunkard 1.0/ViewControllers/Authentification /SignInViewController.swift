//
//  SignInViewController.swift
//  Drunkard 1.0
//
//  Created by USER on 07.03.22.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignIn(_ sender: UIButton) {
        
        guard let email = emailField?.text! else {return}
        guard let password = passwordField?.text! else {return}
        
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                strongSelf.warningLabel.text = "\(error!.localizedDescription)"
                strongSelf.warningLabel.isHidden = false
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {

                    switch errCode {
                    case .invalidEmail, .missingEmail:
                        self?.emailField?.layer.borderColor = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
                    case .wrongPassword:
                        self?.passwordField?.layer.borderColor = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
                
                
                return
            }
            print("you have signed in")
            //TODO: Send to app
        })
    }
    
    @IBAction func onSignUp(_ sender: UIButton) {
    }
}
