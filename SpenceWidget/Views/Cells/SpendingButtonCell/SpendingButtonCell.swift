//
//  SpendingButtonCell.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/2/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class SpendingButtonCell: UICollectionViewCell {

    static let nibName = "SpendingButtonCell"
    
    var onButtonPressed: (()->Void)?
    
    @IBOutlet weak var spendingButton: UIButton!
    
    @IBAction func buttonPressed(sender: UIButton) {
        onButtonPressed?()
    }

}
