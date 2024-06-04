//
//  CardVC.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import UIKit
import RxSwift
import FirebaseAuth
import Lottie

class CardVC: UIViewController  {

    @IBOutlet weak var labelFoodTotalCost: UILabel!
    @IBOutlet weak var tableCart: UITableView!
    
    @IBOutlet weak var emptyStack: UIStackView!
    
    var viewModel = CartVM()
    var viewDetailModal = FoodDetailVM()
    var cartFoods = [FoodsDetail]()
    var foods = [Foods]()
    
    private var animationView:LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableCart.dataSource = self
        tableCart.delegate = self
        _ = viewModel.cartFoods.subscribe(onNext: { liste in
            self.cartFoods = liste
            self.setBadge()
            self.tableCart.reloadData()
            self.updateEmptyCart()
        },onError:  { error in
            print("Error: \(error)")
        })
        tableCart.reloadData()
    
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadCartView()
        setBadge()
       
        
    }
    
    @IBAction func allDeleteButton(_ sender: Any) {
        viewModel.deleteAllCartItems(kullanici_adi: Auth.auth().currentUser?.email ?? "")
        
    }
    
    @IBAction func buttonConfirmCart(_ sender: Any) {
        handleCartAction()
    }
    
    func deleteItemTapped(indexpath:IndexPath){
        let food = cartFoods[indexpath.row]
        delete(foods: food)
    }
    
    
    func delete(foods:FoodsDetail){
        guard let sepet_yemek_id = foods.sepet_yemek_id else { return }
               let kullanici_adi = Auth.auth().currentUser?.email ?? ""
               viewModel.deleteCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    
    
    func uploadCartView(){
        viewModel.uploadCartList(kullanici_adi:  Auth.auth().currentUser?.email ?? "")
        updateEmptyCart()
        setBadge()
    }
    
    
    func setBadge(){
        viewModel.setBadge(cartFoodList: cartFoods, tabBarItem: tabBarItem)
        setTotalCartPrice()
    }
    
    
    func setTotalCartPrice(){
        labelFoodTotalCost.text = " \(viewModel.setTotalCartPrice(cartFoodList: cartFoods)),00₺"
    }
    
    func updateEmptyCart() {
        DispatchQueue.main.async {
            if self.cartFoods.isEmpty {
                self.emptyStack.isHidden = false
                self.tableCart.isHidden = true
            } else {
                self.emptyStack.isHidden = true
                self.tableCart.isHidden = false
            }
        }
    }
    
    
    func showAnimation() {
        
        let animationContainerView = UIView(frame: view.bounds)
        animationContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Arka planı yarı şeffaf yapma
        view.addSubview(animationContainerView)
     
        let animationView = LottieAnimationView(name: "confirm2")
        animationView.frame = view.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.70
        animationContainerView.addSubview(animationView)
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            animationContainerView.removeFromSuperview()
        }
    }
    
    
    func handleCartAction() {
          if cartFoods.isEmpty {
              showEmptyCartAlert()
          } else {
              showAnimation()
          }
      }

    
      func showEmptyCartAlert() {
          let alert = UIAlertController(title: "Empty Cart", message: "Please add product to cart.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
      }
    
}


extension CardVC:UITableViewDelegate,UITableViewDataSource,TableProtocol{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TableCartCell", for: indexPath) as! TableCartCell
        let food = cartFoods[indexPath.row]
        cell.labelCart.text = food.yemek_adi
        cell.labelAdd.text = food.yemek_siparis_adet
        cell.labelTotalPrice.text = "\(food.yemek_fiyat!).00₺"
        let imageURL = viewModel.takePicOfFood(imageName: food.yemek_resim_adi!)
        if let url = imageURL{
            DispatchQueue.main.async {
                cell.imageCart.kf.setImage(with: url)
            }
        }
        cell.indexpath = indexPath
        cell.tableProtocool = self
        return cell
    }
   
}
    
