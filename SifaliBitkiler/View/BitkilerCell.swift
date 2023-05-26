//
//  BitkilerCell.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 8.05.2023.
//

import UIKit

class BitkilerCell: UITableViewCell {

    @IBOutlet weak var bitkilerBaslikLabel: UILabel!
    @IBOutlet weak var bitkilerImageView: UIImageView!
    @IBOutlet weak var bitkilerKisaAciklamaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
