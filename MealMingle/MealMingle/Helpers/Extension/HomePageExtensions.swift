//
//  HomePageExtensions.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import Foundation
import UIKit
import FirebaseAuth

extension HomePageVc{
    func authstatus(){
        if Auth.auth().currentUser?.uid == nil{
            DispatchQueue.main.async {
                let controller = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! UINavigationController
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true,completion: nil)
            }
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            
        }
    }
}
