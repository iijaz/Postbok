//
//  RoundedImageView.swift
//  SMC
//
//  Created by JuicePhactree on 5/9/18.
//  Copyright © 2018 juicePhactree. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layer.cornerRadius = super.frame.size.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        super.layer.cornerRadius = super.frame.size.height / 2
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    

}
