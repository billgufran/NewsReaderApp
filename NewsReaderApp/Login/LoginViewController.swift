//
//  ViewController.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 28/4/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser != nil {
            goToMain()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.viewControllers.removeAll(where: { $0 is RegisterViewController })
    }
    
    func login() {
        guard let email = emailTextField.text, !email.isEmpty else {
            self.presentAlert(title: "Error", message: "Email is not valid")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.presentAlert(title: "Error", message: "Password is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
            if let error = error {
                strongSelf.presentAlert(title: "Error", message: error.localizedDescription)
            } else {
                strongSelf.goToMain()
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        login()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        showRegisterViewController()
    }
}

