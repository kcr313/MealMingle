//
//  CartRepo.swift
//  MealMingle
//
//  Created by kadir ecer on 25.05.2024.
//

import Foundation
import Alamofire
import FirebaseAuth
import RxSwift

class CartRepo {
    var cartFoods = BehaviorSubject<[FoodsDetail]>(value: [FoodsDetail]())
    var orderQuantity = BehaviorSubject<Int>(value: 1)
    
    // Sepete Yemekleri Getirme
    func showCart() {
        isCartEmpty { isEmpty in
            if !isEmpty {
                let param: Parameters = ["kullanici_adi": "\(Auth.auth().currentUser?.email ?? "")"]
                AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: param).response { response in
                    if let data = response.data {
                        do {
                            // Yanıtı önce JSON olarak kontrol edelim
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("API Yanıtı: \(json)")
                            }

                            let answer = try JSONDecoder().decode(FoodsDetailResponse.self, from: data)
                            if let list = answer.sepet_yemekler {
                                self.cartFoods.onNext(list)
                            } else {
                                print("Sepet boş")
                                self.cartFoods.onNext([]) // Boş liste gönder
                            }
                        } catch {
                            print("Decoding hatası: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                print("Sepet boş")
                self.cartFoods.onNext([]) // Boş liste gönder
            }
        }
    }
    // Sepete Yemek EKleme
    func addCart(yemek_adi: String, yemek_fiyat: String,yemek_resim_adi: String, yemek_siparis_adet: String, kullanici_adi: String) {
        let params : Parameters = ["yemek_adi" : yemek_adi, "yemek_fiyat" : yemek_fiyat, "yemek_siparis_adet" : yemek_siparis_adet, "yemek_resim_adi" : yemek_resim_adi, "kullanici_adi" : "\(Auth.auth().currentUser?.email ?? "")"]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters : params).response{
            response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(Response.self, from: data)
                    if cevap.success == 1{
                        self.uploadCartList(kullanici_adi: kullanici_adi)//sepete yemek ekledikten sonra sepeti güncelleme
                    }
                    print("Başarı : \(cevap.success!)")
                    print("Mesaj  : \(cevap.message!)")
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Sepette Yemek Silme
    func deleteCart(sepet_yemek_id:String, kullanici_adi: String) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php")!
        let param : Parameters = ["sepet_yemek_id" : sepet_yemek_id, "kullanici_adi" : Auth.auth().currentUser?.email ?? ""]
        
        AF.request(url,method: .post,parameters: param).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(Response.self, from: data)
                    print("Başarı : \(cevap.success!)")
                    print("Mesaj  : \(cevap.message!)")
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    //sepet sayfası güncelleme
    func uploadCartList(kullanici_adi: String){ // cvm
        let params: Parameters = ["kullanici_adi": kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response{ response in
            if let data = response.data{
                do{
                    let res = try JSONDecoder().decode(FoodsDetailResponse.self, from: data)
                    if let list = res.sepet_yemekler{
                        self.cartFoods.onNext(list)
                    }
                }catch{
                    print("Sepet yükleme hatası : \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // Tüm ürünleri silme
    func allDeleteItems(sepet_yemek_id:String,kullanici_id:String)
    {
        for _ in sepet_yemek_id{
            DispatchQueue.main.async { [weak self] in
                self?.deleteCart(sepet_yemek_id:sepet_yemek_id, kullanici_adi: Auth.auth().currentUser?.email ?? "")
            }
        }
    }
    
    
    // Resim URl
    func takePicOfFood(imageName: String) -> URL? {
        let urlString = "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)"
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
    
    
    // Sepetin boş olup olmadığına kontrol etme
    func isCartEmpty(completion: @escaping (Bool) -> Void) {
        let param: Parameters = ["kullanici_adi": "\(Auth.auth().currentUser?.email ?? "")"]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: param).response { response in
            if let data = response.data {
                do {
                    let answer = try JSONDecoder().decode(FoodsDetailResponse.self, from: data)
                    if let list = answer.sepet_yemekler {
                        completion(list.isEmpty)
                    } else {
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(true)
                }
            } else {
                completion(true)
            }
        }
    }
    
}
