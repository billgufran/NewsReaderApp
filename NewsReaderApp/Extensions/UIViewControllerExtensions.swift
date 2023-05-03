//
//  UIViewControllerExtensions.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 3/5/23.
//

import UIKit

extension UIApplication {
    var window: UIWindow {
        if #available(iOS 13.0, *) {
            let windowScene = connectedScenes.first as! UIWindowScene
            return windowScene.windows.first!
        } else {
            // Fallback on earlier versions
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.window!
        }
    }
}

extension UIViewController {
    func goToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "main")
        let window = UIApplication.shared.window
        window.rootViewController = viewController
    }
    
    func goToLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "navLogin")
        let window = UIApplication.shared.window
        window.rootViewController = viewController
    }
}
