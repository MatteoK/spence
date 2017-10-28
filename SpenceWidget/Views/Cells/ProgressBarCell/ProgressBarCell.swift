//
//  ProgressBarCell.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/2/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

private let padding: CGFloat = 15

class ProgressBarCell: UICollectionViewCell {
   
    @IBOutlet weak var progressBarTrailingConstraint: NSLayoutConstraint!
    
    private var showButtons = false
    
    var onCancelButtonPressed: (()->Void)?
    
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var cancelButton: CancelButton!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setShowButtonsEnabled(value: Bool, animated: Bool, completion: (()->Void)? = nil) {
        showButtons = value
        if(animated) {
            UIView.animate(
                withDuration: 0.3,
                animations: { [weak self] in
                    self?.updateLayout()
                    self?.layoutIfNeeded()
                },
                completion: { _ in
                    completion?()
                }
            )
        } else {
            updateLayout()
        }
    }
    
    func updateLayout() {
        updateConstraint()
        buttonContainer.alpha = showButtons ? 1 : 0
    }
    
    func updateConstraint() {
        progressBarTrailingConstraint.constant = showButtons ? padding + buttonContainer.frame.width - 4 : padding
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        onCancelButtonPressed?()
    }
    
}
