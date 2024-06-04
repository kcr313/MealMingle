//
//  RegisterVC.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

var viewModel = RegisterVM()

class RegisterVC: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func sıgnUpButton(_ sender: UIButton) {
        guard let usernameText = usernameText.text else {return}
        guard let emailText = emailText.text else {return}
        guard let passwordText = passwordText.text else {return}
        
        viewModel.register(username: usernameText, email: emailText, password: passwordText)
        succesRegister()

    }
    
    func succesRegister(){
        let alert = UIAlertController(title: "Kayıt Başarılı", message: "Kaydınız başarıyla yapılmıştır", preferredStyle: .alert)
        let okeyAction = UIAlertAction(title: "Okey", style: .cancel)
        alert.addAction(okeyAction)
        self.present(alert, animated: true)
    }
    

}
