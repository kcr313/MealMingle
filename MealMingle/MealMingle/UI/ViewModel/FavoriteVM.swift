//
//  FavoriteVM.swift
//  MealMingle
//
//  Created by kadir ecer on 29.05.2024.
//

import Foundation

class FavoriteVM {
    static var shared = FavoriteVM()
    private init() {}
    
    var favoriteList: [Foods] = []

    func addFavorite(food: Foods) {
        favoriteList.append(food)
    }

    func removeFavorite(food: Foods) {
        if let index = favoriteList.firstIndex(where: { $0.yemek_adi == food.yemek_adi }) {
            favoriteList.remove(at: index)
        }
    }

    func isFavorite(food: Foods) -> Bool {
        return favoriteList.contains(where: { $0.yemek_adi == food.yemek_adi })
    }
    
}

