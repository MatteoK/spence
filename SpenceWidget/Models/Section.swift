//
//  Section.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/2/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum SectionType {
    
    case top
    case bottom

}

struct Section {
    
    let type: SectionType
    let cells: [CellType]
    
}
