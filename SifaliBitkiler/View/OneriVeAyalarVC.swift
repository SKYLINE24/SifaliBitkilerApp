//
//  OneriVeAyalarVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 16.03.2023.
//

import UIKit
import Firebase

class OneriVeAyalarVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func CikisYapTiklandi(_ sender: Any) {
        do{
            try Auth.auth().signOut()//kullanıcıdan çıkış yapmış oluyoruz butona tıkladığımızda, izlyeceğimiz segue de aşşağıda, kullanıcı uygulamaya tekrar girdiğinde giriş yapması gerekecek
            performSegue(withIdentifier: "toGirisEkrani", sender: nil)
        }catch{
            print("Hata")
        }
    }
    

}
