//
//  Notification+Spence.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/29/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

extension Notification {
    
    var getKeyboardHeight: CGFloat? {
        guard let keyboardInfo = userInfo,
            let keyboardFrameBegin = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return nil
        }
        let keyboardFrameBeginRect = keyboardFrameBegin.cgRectValue
        let keyboardHeight = keyboardFrameBeginRect.size.height
        return keyboardHeight
    }
    
}

