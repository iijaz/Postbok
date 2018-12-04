//
//  CustomCollectionViewCell.swift
//  SMC
//
//  Created by JuicePhactree on 10/20/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                //self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.contentView.backgroundColor = UIColor.red
                self.layer.borderColor = UIColor.red.cgColor
                self.layer.borderWidth = 2.0
               // self.tickImageView.isHidden = false
            }
            else
            {
                //self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor.gray
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 0.0
               // self.tickImageView.isHidden = true
            }
        }
    }
    
}
