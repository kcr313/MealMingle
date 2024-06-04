//
//  HomePageVM.swift
//  MealMingle
//
//  Created by kadir ecer on 22.05.2024.
//

import Foundation
import RxSwift

class HomePageVM{
    var hrepo = HomePageRepo()
    var foods = BehaviorSubject<[Foods]>(value: [Foods]())
    
    init(){
        foods = hrepo.foods
    }
    
    func getFoods(){
        hrepo.getFoods()
    }
    
    
}
