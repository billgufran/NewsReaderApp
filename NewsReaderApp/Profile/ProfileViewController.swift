//
//  ProfileViewController.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 3/5/23.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfile()
    }
    
    func setProfile() {
        let user = Auth.auth().currentUser
        if let user = user {
            emailTextField.text = user.email
            nameTextField.text = user.displayName
        }
    }
    
    func updateProfile() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nameTextField.text
        changeRequest?.commitChanges { [weak self] error in
            if let error = error {
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        updateProfile()
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.goToLogin()
            } catch let signOutError as NSError {
                self.presentAlert(title: "Error", message: signOutError.localizedDescription)
            }
        }))
        present(alert, animated: true)
    }
    
}
