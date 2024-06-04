//
//  FavoriteVC.swift
//  MealMingle
//
//  Created by kadir ecer on 21.05.2024.
//

import UIKit

class FavoriteVC: UIViewController {

    @IBOutlet weak var tableFavoriteView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableFavoriteView.delegate = self
        tableFavoriteView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          tableFavoriteView.reloadData()
      }

    func addItemTapped(indexpath:IndexPath){
        let food = FavoriteVM.shared.favoriteList[indexpath.row]
        let controller = storyboard?.instantiateViewController(identifier: "FoodDetailVC") as? FoodDetailVC
        controller?.food = food
        controller!.modalPresentationStyle = .automatic
        present(controller!, animated: true,completion: nil)
    }
    func deleteItemTapped(indexpath:IndexPath){
        let food = FavoriteVM.shared.favoriteList[indexpath.row]
        FavoriteVM.shared.removeFavorite(food: food)
        tableFavoriteView.deleteRows(at: [indexpath], with: .automatic)
    }
}

extension FavoriteVC:UITableViewDelegate,UITableViewDataSource,FavoriteTableProtocol{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return FavoriteVM.shared.favoriteList.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteTableCell
           let food = FavoriteVM.shared.favoriteList[indexPath.row]
           cell.labelFavoriteName.text = food.yemek_adi
           cell.labelFavoritePrice.text = "\(food.yemek_fiyat!).00₺"
           if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)") {
               DispatchQueue.main.async {
                   cell.imageFavorite.kf.setImage(with: url)
               }
           }
           cell.indexpath = indexPath
           cell.FavoriteTableProtocol = self
           return cell
       }
}
