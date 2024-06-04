//
//  HomePageCollectionCell.swift
//  MealMingle
//
//  Created by kadir ecer on 22.05.2024.
//

import UIKit


class HomePageCollectionCell: UICollectionViewCell {
    
    var protocolCell:CollectionProtocol?
    var indexpath:IndexPath?
    var food:Foods?
    
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var labelFoodPrice: UILabel!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var imageFood: UIImageView!
   

    
    @IBAction func buttonFavorite(_ sender: Any) {
        if buttonFavorite.tintColor == UIColor.imageBackground {
            buttonFavorite.tintColor = UIColor.systemRed// Eski renginize göre ayarlayın
            FavoriteVM.shared.addFavorite(food: food!)
        } else {
            buttonFavorite.tintColor = UIColor.imageBackground
            FavoriteVM.shared.removeFavorite(food: food!)
        }
            protocolCell!.favoriteTapped(indexpath: indexpath!)
    }
    
    @IBAction func buttonAddCart(_ sender: Any) {
        protocolCell!.addCartTapped(indexpath: indexpath!)
        
    }
}
