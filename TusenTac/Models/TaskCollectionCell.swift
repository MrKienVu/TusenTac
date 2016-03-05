//
//  TaskCollectionCell.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 18/02/16.
//  Copyright © 2016 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit

class TaskCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var lastDosageLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
