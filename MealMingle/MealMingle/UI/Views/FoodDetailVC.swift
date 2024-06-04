//
//  FoodDetailVC.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import UIKit
import FirebaseAuth
import RxSwift

class FoodDetailVC: UIViewController {

    @IBOutlet weak var labelFoodNumber: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelFoodPrice: UILabel!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var imageFoodDetail: UIImageView!
    
    
    var viewModal = FoodDetailVM()
    var food:Foods?
    var cartFoodList:[FoodsDetail]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = viewModal.cartFoodList.subscribe(onNext: { liste in
            self.cartFoodList = liste
        })
        
        if let f = food{
            _ = viewModal.totalPrice.subscribe(onNext: {price in
                self.labelTotalPrice.text = " \(price).00₺"
            })
            _ = viewModal.orderQuantity.subscribe(onNext: { q in
                self.labelFoodNumber.text = "\(q)"
            })
            
            labelFoodName.text    = f.yemek_adi
            labelFoodPrice.text   = "\(String(describing: f.yemek_fiyat!)).00₺"
            labelTotalPrice.text  = "\(String(describing: f.yemek_fiyat!)).00₺"
            
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(f.yemek_resim_adi!)")
            {
                DispatchQueue.main.async {
                    self.imageFoodDetail.kf.setImage(with : url)
                    
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModal.uploadCart(kullanici_adi: Auth.auth().currentUser?.email ?? "")
    }
    
    
    @IBAction func orderQuantity(_ sender: UIButton) {
        viewModal.quantityCal(sender:sender)
        viewModal.calculateTotalPrice(price: Int((food?.yemek_fiyat)!)!)
    }
    
    
    @IBAction func addToCart(_ sender: UIButton) {
        viewModal.addAgainTocart(cardList: cartFoodList!, food: food)
    }
    
}
