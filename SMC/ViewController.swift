//
//  ViewController.swift
//  CodeVise
//
//  Created by Arslan Javed on 9/25/17.
//  Copyright © 2017 Arslan Javed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.roundViewAndSetShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.tabBarController?.selectedIndex = 1
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


