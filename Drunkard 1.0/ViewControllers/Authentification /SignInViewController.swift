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
    @IBOutlet weak var rememberMeButton: UIButton!
    
    var rememberMe = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        
        warningLabel.isHidden = true
        
        rememberMeButton.setImage(UIImage(systemName: "square.dashed"), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(FirebaseAuth.Auth.auth().currentUser != nil){ // temporary conditional TODO: write logic of remembering a signed in user
            changeRootAndMoveToViewController()
        }
    }
    
    @IBAction func onSignIn(_ sender: UIButton) {
        
        self.emailField?.layer.borderWidth = 0 // used to reset the email and password fields so it can later be detected where the problem is
        self.passwordField?.layer.borderWidth = 0
        
        warningLabel.isHidden = true
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
        
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                strongSelf.warningLabel.text = "\(error!.localizedDescription)"
                strongSelf.warningLabel.isHidden = false
                return
            }
            
            //TODO: remember signed in user
            
            print("you have signed in")
//            strongSelf.navigationController?.dismiss(animated: true)
            self?.changeRootAndMoveToViewController()
        })
    }
    
    
    
    
    @IBAction func onRememberMe(_ sender: UIButton) {
        rememberMe.toggle()
    //TODO: add remember me function
        switch rememberMe {
        case true:
            sender.setImage(UIImage(systemName:  "heart.square"), for: .normal)

        case false:
            sender.setImage(UIImage(systemName: "square.dashed"), for: .normal)

        default:
            return
        }
    }
    
    @IBAction func onSignUp(_ sender: UIButton) {
        let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController)!
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func changeRootAndMoveToViewController() {
        self.dismiss(animated: true)
    }
}
