//
//  HomePageRepo.swift
//  MealMingle
//
//  Created by kadir ecer on 16.05.2024.
//

import Foundation
import Alamofire
import RxSwift
import FirebaseAuth
import UIKit

class HomePageRepo{
    var foods = BehaviorSubject<[Foods]>(value: [Foods]())
    var orderQuantity = BehaviorSubject<Int>(value: 1)
    var totalPrice = BehaviorSubject<Int>(value: 1) //tek bir ürün çeşidinin toplam fiyatı
    
    //Ürünleri Getirme
    func getFoods(){
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php")!
        
        AF.request(url,method: .get).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(FoodsResponse.self, from: data)
                    if let liste = cevap.yemekler {
                        self.foods.onNext(liste)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Adet Değişikliğini ayarlama
    func quantityCal(sender: UIButton){
        if let buttonIdentifier = sender.accessibilityIdentifier {
            if buttonIdentifier == "minusButton" {
                let currentCount = (try? orderQuantity.value()) ?? 1
                let newCount = max(currentCount - 1, 1)
                orderQuantity.onNext(newCount)
                
            } else if buttonIdentifier == "plusButton" {
                let newCount = (try? orderQuantity.value()) ?? 1
                orderQuantity.onNext(newCount + 1)
            }
        }
    }
    //adet değiştikten sonra ürün miktarını hesaplama
    func calculateTotalPrice(price: Int){
        let currentCount = (try? orderQuantity.value()) ?? 1
        let newPrice = currentCount * price
        totalPrice.onNext(newPrice)
    }
    
    func takePicOfFood(imageName: String) -> URL? {
        let urlString = "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)"
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
}
