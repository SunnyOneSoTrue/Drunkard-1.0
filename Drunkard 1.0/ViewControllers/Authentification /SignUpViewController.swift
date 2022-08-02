//
//  SignUpViewController.swift
//  Drunkard 1.0
//
//  Created by USER on 07.03.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    private let spinner  = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: UIButton) {
        
        self.emailField?.layer.borderWidth = 0 // used to reset the email and password fields so it can later be detected where the problem is
        self.passwordField?.layer.borderWidth = 0
        self.firstNameField.layer.borderWidth = 0
        self.lastnameField.layer.borderWidth = 0
        
        errorLabel.isHidden = true
        guard let email = emailField?.text! else {return}
        guard let password = passwordField?.text! else {return}
        
        checkFieldValidities(field: emailField)
        checkFieldValidities(field: passwordField)
        checkFieldValidities(field: firstNameField)
        checkFieldValidities(field: lastnameField)
        checkFieldValidities(field: phoneNumberField)
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true)
            }
            
            guard error == nil else {
                strongSelf.errorLabel.text = "\(error!.localizedDescription)"
                strongSelf.errorLabel.isHidden = false
                return
            }
            
            let chatUser = user(firstName: self!.firstNameField.text!,
                                lastName: self!.lastnameField.text!,
                                phoneNumber: self!.phoneNumberField.text!,
                                email: email)
            
            print("you have registered")
            DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                if success {
                    //upload image
                    guard let image = UIImage(named: "blank_profile_pic"), let data = image.pngData() else {return}
                    
                    let filename = chatUser.profilePictureFileName
                    
                    storageManager.shared.uploadProfilePicture(with: data, filename: filename) { result in
                        switch result {
                        case .success(let downloadURL):
                            UserDefaults.standard.setValue(downloadURL, forKey: "profile_picture_url")
                            print(downloadURL)
                        case .failure(let error):
                            print("storage manager error: \(error)")
                        }
                    }
                }
            })
            self?.dismiss(animated: true)
            
        })
        
    }
    
    func checkFieldValidities(field: UITextField){
        
        if field.text == "" {
            field.layer.borderWidth = 3
            field.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        }
    }
    
}
