//
//  RegisterViewController.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 3/5/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.viewControllers.removeAll(where: { $0 is LoginViewController })
    }
    
    func register() {
        guard let email = emailTextField.text, !email.isEmpty else {
            presentAlert(title: "Error", message: "Email is not valid")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            presentAlert(title: "Error", message: "Password is not valid")
            return
        }
        
        // Firebase sign up
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let `self` = self else { return }
            
            if let error = error {
                self.presentAlert(title: "Error", message: error.localizedDescription)
            } else {
                let alert = UIAlertController(title: "Congratulation", message: "Register success!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
                    self.showLoginViewController()
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        register()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        showLoginViewController()
    }
    
}

extension LoginViewController {
    func showRegisterViewController() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        // withIdentifier: storyboardId
        let viewViewController = storyboard.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        
        navigationController?.pushViewController(viewViewController, animated: true)
    }
}

extension RegisterViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        // withIdentifier: storyboardId
        let viewViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        
        navigationController?.pushViewController(viewViewController, animated: true)
    }
}

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
}
