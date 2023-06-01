//
//  AramaListelemeCell.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 27.05.2023.
//

import UIKit

class AramaListelemeCell: UITableViewCell {

    
    @IBOutlet weak var bitkiImageView: UIImageView!
    @IBOutlet weak var bitkiIsimLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
