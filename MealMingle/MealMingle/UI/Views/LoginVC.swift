//
//  LoginVC.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var viewModel = LoginVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func sıgnInButton(_ sender: Any) {
        guard let emailText = emailTextField.text ,let passwordText = passwordTextField.text else {
            let alert = UIAlertController(title: "Error", message: "Email and password fields cannot be empty", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        viewModel.login(email: emailText, password: passwordText) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    let controller = self.storyboard?.instantiateViewController(identifier: "tabbarController") as! UITabBarController
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .flipHorizontal
                    self.present(controller, animated: true,completion: nil)
                    print("Login successful: \(user.email ?? "No Email")")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Okay", style: .default) { action in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                    print("Login failed: \(error.localizedDescription)")
                }
            }
        }
            
        }
            
    @IBAction func newUserButton(_ sender: Any) {
        performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
}

