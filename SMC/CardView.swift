//
//  CardView.swift
//  SMC
//
//  Created by JuicePhactree on 11/14/17.
//  Copyright © 2017 juicePhactree. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.init(colorLiteralRed: 205.0/255.0, green: 71.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        //self.roundViewAndSetShadow()
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.red
        
    }
    
    override func layerWillDraw(_ layer: CALayer) {
    }
    

    
    

}

