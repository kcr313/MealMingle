//
//  FavoriteTableCell.swift
//  MealMingle
//
//  Created by kadir ecer on 29.05.2024.
//

import UIKit

class FavoriteTableCell: UITableViewCell {

    @IBOutlet weak var labelFavoritePrice: UILabel!
    @IBOutlet weak var labelFavoriteName: UILabel!
    @IBOutlet weak var imageFavorite: UIImageView!
    
    var indexpath:IndexPath?
    var FavoriteTableProtocol:FavoriteTableProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func buttonFavoriteDelete(_ sender: Any) {
        FavoriteTableProtocol?.deleteItemTapped(indexpath: indexpath!)
        
    }
    
    @IBAction func buttonFavoriteAdd(_ sender: Any) {
        FavoriteTableProtocol?.addItemTapped(indexpath: indexpath!)
    }
}
