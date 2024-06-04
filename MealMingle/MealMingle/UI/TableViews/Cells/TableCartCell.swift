//
//  TableCartCell.swift
//  MealMingle
//
//  Created by kadir ecer on 24.05.2024.
//

import UIKit

class TableCartCell: UITableViewCell {

 
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelAdd: UILabel!
    @IBOutlet weak var labelCart: UILabel!
    @IBOutlet weak var imageCart: UIImageView!
 
    
    var indexpath:IndexPath?
    var tableProtocool:TableProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func buttonDelete(_ sender: Any) {
        tableProtocool?.deleteItemTapped(indexpath: indexpath!)
    }

}
