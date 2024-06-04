//
//  OnboardingCollectionVC.swift
//  MealMingle
//
//  Created by kadir ecer on 19.05.2024.
//

import UIKit

class OnboardingCollectionVC: UICollectionViewCell {
    
    @IBOutlet weak var slideDescriptionLbl: UILabel!
    @IBOutlet weak var slideTitleLbl: UILabel!
    @IBOutlet weak var slideImageView: UIImageView!
    
    func setup(_ slide:OnboardingVM){
        
        slideImageView.image = slide.image
        slideTitleLbl.text = slide.title
        slideDescriptionLbl.text = slide.description
    }
}
