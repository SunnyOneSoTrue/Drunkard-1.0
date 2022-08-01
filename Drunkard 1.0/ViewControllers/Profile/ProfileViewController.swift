//
//  ProfileViewController.swift
//  Drunkard 1.0
//
//  Created by USER on 19.03.22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var publicationsContainerView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoContainerView.alpha = 0
    }
    
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            publicationsContainerView.alpha = 1
            infoContainerView.alpha = 0
        }
        else {
            publicationsContainerView.alpha = 0
            infoContainerView.alpha = 1
        }
    }
    
    
    @IBAction func onLogOut(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sign Out?", message: "are you sure you want to sign out?", preferredStyle: .actionSheet)
       
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {[weak self]_ in
                
            guard let strongSelf = self else {return}
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController)!
                vc.modalPresentationStyle = .fullScreen
                strongSelf.present(vc, animated: true)
            }
            catch  {
                print("failed to log out")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
        
    }
}

