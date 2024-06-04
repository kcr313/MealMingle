//
//  AuthRepo.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class AuthRepo{
    func sıgnIn(email:String,password:String,completion:@escaping(Result<User, Error>)->Void){
        Auth.auth().signIn(withEmail: email, password: password){ authResult,error in
            if let error = error{
                print(error.localizedDescription)
            } 
            
            if let user = authResult?.user {
                completion(.success(user))
            } else {
                let error = NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Wrong Password or Email."])
                completion(.failure(error))
            }
            
        }
    }
    
    
    func sıgnUp(username:String,email:String,password:String){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if let error = error{
                print(error.localizedDescription)
            }
            guard let userUid = result?.user.uid else {return}
            let data = [
                "email":email,
                "username":username,
                "uid":userUid
            ] as [String:Any]
            Firestore.firestore().collection("users").document(userUid).setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                print("Başarılı")
            }
        }
        
    }
    
}
