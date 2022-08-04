//
//  ProfileViewController.swift
//  Drunkard 1.0
//
//  Created by USER on 19.03.22.
//

import UIKit
import FirebaseAuth
import Photos
import PhotosUI

class ProfileViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var publicationsContainerView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var imageBeingPicked = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoContainerView.alpha = 0
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width/2
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
    
    @IBAction func onTapProfilePicture(_ sender: Any) {
        print("profile picture tapped")
        imageBeingPicked = "profile"
        act(on: profilePictureView)
    }
    
    @IBAction func onTapBackgroundPicture(_ sender: Any) {
        print("background picture tapped")
        imageBeingPicked = "background"
        act(on: backgroundImageView)
    }
    
    @IBAction func onLogOut(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sign Out", message: "are you sure you want to sign out?", preferredStyle: .actionSheet)
       
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
    
    
    private func act(on imageView: UIImageView) { //used to interract or change profile and background pictures
        var actionSheet = UIAlertController()
        
        if imageBeingPicked == "profile" {
            actionSheet = UIAlertController(title: "Profile Picture", message: "Please Select your action", preferredStyle: .actionSheet)
        }
        else {
            actionSheet = UIAlertController(title: "Background Picture", message: "Please Select your action", preferredStyle: .actionSheet)
        }
        
        actionSheet.addAction(UIAlertAction(title: "View", style: .default, handler: { _ in //MARK: used to view the images on the profile
            let newImageView = UIImageView(image: imageView.image)
                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = .black
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
                newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
                self.navigationController?.isNavigationBarHidden = true
                self.tabBarController?.tabBar.isHidden = true
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Replace", style: .default, handler: { _ in
            print("pressed Replace")
            
            self.dismiss(animated: true)
            
            let newActionSheet = UIAlertController(title: "Replace Photo", message: "Please choose an option", preferredStyle: .actionSheet)
            
            newActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.delegate = self
                vc.allowsEditing = true
                self.present(vc, animated: true)
            }))
            
            newActionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                //TODO: choose from gallery and upload
                var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
                    phPickerConfig.selectionLimit = 1
                    phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
                let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
                    phPickerVC.delegate = self
                self.present(phPickerVC, animated: true)
                
                
            }))
            
            newActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(newActionSheet, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheet, animated: true)
    }
    
    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) { //used to dismiss when viewing the profile or background pictures
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
}


extension ProfileViewController:PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    if self.imageBeingPicked == "profile" {
                        self.profilePictureView.image = image
                        //TODO: SAVE THE NEW PICTURE TO FIREBASE
                    } else {
                        self.backgroundImageView.image = image
                        //TODO: SAVE THE NEW PICTURE TO FIREBASE
                    }
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage
        
        if imageBeingPicked == "profile" {
            profilePictureView.image = image
            //TODO: SAVE THE NEW PICTURE TO FIREBASE
        } else {
            backgroundImageView.image = image
            //TODO: SAVE THE NEW PICTURE TO FIREBASE
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

