//
//  BitkilerDetayVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 16.03.2023.
//

import UIKit
import SDWebImage


class BitkilerDetayVC: UIViewController{

    @IBOutlet weak var bitkiBaslikLabel: UILabel!
    @IBOutlet weak var bitkiAciklamaLabel: UILabel!
    @IBOutlet weak var bitkiImageView: UIImageView!
    @IBOutlet weak var bitkiTarifLabel: UILabel!
    
    var secilenBitkiBaslik = ""
    var secilenBitkiAciklamasi = ""
    var secilenBitkiImage = ""
    var secilenBitkiKullanimi = ""
    
    override func viewDidLoad() {
        bitkiBaslikLabel.text = secilenBitkiBaslik
        bitkiAciklamaLabel.text = secilenBitkiAciklamasi
        if let imageUrl = URL(string: secilenBitkiImage) {
            bitkiImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        bitkiTarifLabel.text = secilenBitkiKullanimi
        super.viewDidLoad()
    }
    
    
    
    @IBAction func bitkiDüzenleTiklandi(_ sender: Any) {
        
    }
    

}
