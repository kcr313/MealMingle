//
//  HomeVCProtocol.swift
//  MealMingle
//
//  Created by kadir ecer on 4.06.2024.
//

import Foundation


protocol CollectionProtocol{
        func addCartTapped(indexpath:IndexPath)
        func favoriteTapped(indexpath:IndexPath)
    }

protocol TableProtocol{
    func deleteItemTapped(indexpath:IndexPath)
}

protocol FavoriteTableProtocol{
    func addItemTapped(indexpath:IndexPath)
    func deleteItemTapped(indexpath:IndexPath)
}
