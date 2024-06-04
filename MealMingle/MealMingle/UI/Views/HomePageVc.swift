//
//  HomePageVc.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import UIKit
import Kingfisher
import FirebaseAuth

class HomePageVc: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var foods = [Foods]()
    var viewModel = HomePageVM()
    var searchFoods = [Foods]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        _ = viewModel.foods.subscribe(onNext: { liste in
            self.foods = liste
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
        })
        
      
        
        searchBar.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        
        //Collection Tasarım
        let foodTasarim = UICollectionViewFlowLayout()
        foodTasarim.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        foodTasarim.minimumLineSpacing = 10
        foodTasarim.minimumInteritemSpacing = 10
        let width = homeCollectionView.frame.size.width
        let cellWidht = (width - 40) / 2
        foodTasarim.itemSize = CGSize(width: cellWidht, height: cellWidht*1.1)
        homeCollectionView.collectionViewLayout = foodTasarim
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFoods()
    }
    
    
    @IBAction func buttonLogOut(_ sender: Any) {
       showLogOutAlert()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodDetail"{
            if let food = sender as? Foods{
                let toVC = segue.destination as! FoodDetailVC
                toVC.food = food
            }
        }
    }
    
    
    func addCartTapped(indexpath:IndexPath){
        let food = foods[indexpath.row]
        performSegue(withIdentifier: "toFoodDetail", sender: food)
    }
    
    
    func favoriteTapped(indexpath: IndexPath){
        let food = searching ? searchFoods[indexpath.row] : foods[indexpath.row]
        print("\(food.yemek_adi!) added")
    }
    
    
    func showLogOutAlert() {
        let alert = UIAlertController(title: "Log Out ", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.signOut()
            let controller = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            self.present(controller, animated: true,completion: nil)
        }))
        
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension HomePageVc:UICollectionViewDelegate,UICollectionViewDataSource, CollectionProtocol{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searching ? searchFoods.count : foods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homePageCell", for: indexPath) as! HomePageCollectionCell
        let food = searching ? searchFoods[indexPath.row] : foods[indexPath.row]
        cell.labelFoodName.text = food.yemek_adi
        cell.labelFoodPrice.text = "\(food.yemek_fiyat!).00₺"
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)")
        {
            DispatchQueue.main.async {
                cell.imageFood.kf.setImage(with : url)
                
            }
        }
        cell.indexpath = indexPath
        cell.protocolCell = self
        cell.food = food
        cell.buttonFavorite.tintColor = FavoriteVM.shared.isFavorite(food: food) ? UIColor.systemRed : UIColor.imageBackground
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = searching ? searchFoods[indexPath.row] : foods[indexPath.row]
        performSegue(withIdentifier: "toFoodDetail", sender: food)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension HomePageVc:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
                 searching = false
                 searchFoods.removeAll()
                 homeCollectionView.reloadData()
             } else {
                 searching = true
                 searchFoods = foods.filter { $0.yemek_adi?.lowercased().contains(searchText.lowercased()) ?? false }
                 homeCollectionView.reloadData()
             }
    }

}
