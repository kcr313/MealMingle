//
//  CartVM.swift
//  MealMingle
//
//  Created by kadir ecer on 25.05.2024.
//

import Foundation
import RxSwift
import UIKit

class CartVM{
    var crepo = CartRepo()
    var hrepo = HomePageRepo()
    var cartFoods = BehaviorSubject<[FoodsDetail]>(value: [FoodsDetail]())
    var orderQuantity = BehaviorSubject<Int>(value: 1)
    var totalPrice = BehaviorSubject<Int>(value: 1)
    var listCount = 0
    
    private let disposeBag = DisposeBag()
    
    
    init(){
        cartFoods = crepo.cartFoods
        orderQuantity = hrepo.orderQuantity
        totalPrice = hrepo.totalPrice
    }
    
    func showCart(){
        crepo.showCart()
    }
    
    
    func deleteCart(sepet_yemek_id: String, kullanici_adi: String){
        crepo.deleteCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
        showCart()
    }
    
    
    func deleteAllCartItems(kullanici_adi: String) {
        cartFoods
            .take(1)
            .subscribe(onNext: { [weak self] foods in
                guard let self = self else { return }
                guard !foods.isEmpty else {
                    print("Sepet boş, silme işlemi yapılmadı.")
                    return
                }
                for food in foods{
                    self.deleteCart(sepet_yemek_id: food.sepet_yemek_id!, kullanici_adi: food.kullanici_adi!)
                }
                self.uploadCartList(kullanici_adi: kullanici_adi)
            })
            .disposed(by: disposeBag)
    }
    
    
    func takePicOfFood(imageName: String) -> URL?{
        crepo.takePicOfFood(imageName: imageName)
    }
    
    
    func uploadCartList(kullanici_adi:String){
        crepo.uploadCartList(kullanici_adi: kullanici_adi)
    }
    
    
    func setTotalCartPrice(cartFoodList: [FoodsDetail]) -> Int{
        var totalPrice = 0
        for i in cartFoodList{
            totalPrice += Int(i.yemek_fiyat!)!
        }
        return totalPrice
    }
    
    
    func setBadge(cartFoodList: [FoodsDetail], tabBarItem: UITabBarItem){
        listCount = cartFoodList.count
        tabBarItem.badgeValue = listCount > 0 ? "\(listCount)" : nil
    }
    
}
