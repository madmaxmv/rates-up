//
//  RateCell.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!

    func setup(with state: RateViewState) {
        codeLabel.text = state.characterCode
        detailsLabel.text = state.details
        valueLabel.text = state.value
        differenceLabel.text = state.difference
    }
    
}