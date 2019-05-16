//
//  AlbumCell.swift
//  ProjektVyvojMobilnichAplikaci
//
//  Created by Filip Sollar on 15/05/2019.
//  Copyright © 2019 Lukas and Filip. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumCell: UITableViewCell {

    @IBOutlet var ivThumb: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(model: ReleaseModel) {
        ivThumb.kf.setImage(with: URL(string: model.thumbUrl))
        lbTitle.text = model.name
        lbYear.text = String(model.year)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
