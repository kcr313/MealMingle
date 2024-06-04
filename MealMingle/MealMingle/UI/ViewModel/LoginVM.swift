//
//  LoginVM.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import Foundation
import FirebaseAuth
class LoginVM{
    var arepo = AuthRepo()
    
    func login(email:String,password:String,completion: @escaping (Result<User, Error>) -> Void){
        arepo.sıgnIn(email:email, password: password){ result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

