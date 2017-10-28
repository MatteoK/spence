//
//  ExpenseButtonCell.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/2/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class ExpenseButtonCell: UICollectionViewCell {
    
    var onButtonPressed: (()->Void)?
    
    @IBOutlet weak var expenseButton: UIButton!
    
    @IBAction func buttonPressed(sender: UIButton) {
        onButtonPressed?()
    }

}
