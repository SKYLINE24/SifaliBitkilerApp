//
//  FavoriBitkilerCell.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 21.05.2023.
//

import UIKit

class FavoriBitkilerCell: UITableViewCell {

    @IBOutlet weak var bitkiImageView: UIImageView!
    @IBOutlet weak var bitkiAdiLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
