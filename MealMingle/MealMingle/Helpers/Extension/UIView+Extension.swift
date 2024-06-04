//
//  UIView+Extension.swift
//  MealMingle
//
//  Created by kadir ecer on 19.05.2024.
//

import UIKit

extension UIView{
   @IBInspectable var cornerRadius:CGFloat{
       get{return self.cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
    }
    
}
