//
//  LoginVM.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import Foundation

class RegisterVM{
    var arepo = AuthRepo()
    
    func register(username:String,email:String,password:String){
        arepo.sıgnUp(username: username , email: email, password: password)
    }
}
