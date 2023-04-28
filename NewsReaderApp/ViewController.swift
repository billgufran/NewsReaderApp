//
//  ViewController.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 28/4/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTitleLabel.text = "Surel"
        emailTextField.placeholder = "surel@pengguna.com"
        
        passwordTitleLabel.text = "Kata Sandi"
        passwordTextField.placeholder = "Rahasia"
        
        loginButton.setTitle("Masuk", for: UIControl.State.normal)
        loginButton.layer.cornerRadius = 4
    }
    
    
    @IBAction func loginButtonOnTap(_ sender: Any) {
        print("Email: \(emailTextField.text ?? "-")")
    }
}

