//
//  SongCell.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Filip Sollar on 15/05/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(model: SongModel) {
        lbName.text = model.title
        lbLength.text = model.duration
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
