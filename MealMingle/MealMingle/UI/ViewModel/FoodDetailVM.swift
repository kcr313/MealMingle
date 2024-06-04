//
//  FoodDetailVM.swift
//  MealMingle
//
//  Created by kadir ecer on 27.05.2024.
//

import Foundation
import RxSwift
import UIKit
import FirebaseAuth

class FoodDetailVM{
    
    var hrepo = HomePageRepo()
    var crepo = CartRepo()
    var orderQuantity = BehaviorSubject<Int>(value: 1)
    var totalPrice = BehaviorSubject<Int>(value: 1)
    var cartFoodList = BehaviorSubject<[FoodsDetail]>(value: [FoodsDetail]())
    
    
    init(){
        
        orderQuantity = hrepo.orderQuantity
        totalPrice = hrepo.totalPrice
        cartFoodList = crepo.cartFoods
    }
    
    
    func addCart(yemek_adi: String, yemek_fiyat: String,yemek_resim_adi: String, yemek_siparis_adet: String, kullanici_adi: String){
        crepo.addCart(yemek_adi: yemek_adi, yemek_fiyat: yemek_fiyat, yemek_resim_adi: yemek_resim_adi, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
    }
    
    
    func quantityCal(sender: UIButton){
        hrepo.quantityCal(sender: sender)
    }
    
    
    func calculateTotalPrice(price: Int){
        hrepo.calculateTotalPrice(price: price)
    }
    
    
    func uploadCart(kullanici_adi: String){
        crepo.uploadCartList(kullanici_adi: kullanici_adi )
    }
    
    
    func deleteFromCart(sepet_yemek_id:String, kullanici_adi:String){
        crepo.deleteCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    
    
    func addAgainTocart(cardList : [FoodsDetail], food:Foods?){
        var isName = false
        var f = FoodsDetail()
        for i in cardList{
            if let foodName = i.yemek_adi{
                if foodName == food!.yemek_adi{
                    isName = true
                    f = i
                    break
                } else {
                    isName = false
                }
            }
        }
        if isName {
            crepo.deleteCart(sepet_yemek_id: f.sepet_yemek_id! , kullanici_adi:f.kullanici_adi!)
            if let food = food{
                let intQuantity = (try? orderQuantity.value()) ?? 1
                    crepo.addCart(
                    yemek_adi: food.yemek_adi ?? "yemek bulunamadı",
                    yemek_fiyat: String(Int((food.yemek_fiyat)!)! * (intQuantity + Int(f.yemek_siparis_adet!)!)), // Int değeri String'e çevrildi
                    yemek_resim_adi: food.yemek_resim_adi!,
                    yemek_siparis_adet: String(intQuantity + Int(f.yemek_siparis_adet!)!), // Int değeri String'e çevrildi
                    kullanici_adi:  Auth.auth().currentUser?.email ?? ""
                )
            }
        } else {
            if let food = food{
                let intQuantity = (try? orderQuantity.value()) ?? 1
                    crepo.addCart(
                    yemek_adi: food.yemek_adi ?? "yemek bulunamadı",
                    yemek_fiyat: String(Int(food.yemek_fiyat!)! * intQuantity), // Int değeri String'e çevrildi
                    yemek_resim_adi: food.yemek_resim_adi!,
                    yemek_siparis_adet: String(intQuantity), // Int değeri String'e çevrildi
                    kullanici_adi:  Auth.auth().currentUser?.email ?? ""
                    
                )
            }
        }
    }
}
