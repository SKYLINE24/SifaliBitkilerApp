//
//  OneriVeAyalarVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 16.03.2023.
//

import UIKit
import Firebase

class OneriVeAyalarVC: UIViewController {

    @IBOutlet weak var oneriVeSikayetTextField: UITextField!
    
    var guncelKullanici = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func gonderTiklandi(_ sender: Any) {
        let db = Firestore.firestore()
        if oneriVeSikayetTextField != nil {
            let data:[String: Any] = ["email": guncelKullanici as Any, "ileti": oneriVeSikayetTextField.text as Any]
            db.collection("Sikayet ve Oneri").addDocument(data: data){ error in
                if let error = error{
                    self.mesajGoster(title: "Hata", message: error.localizedDescription )
                }else{
                    self.mesajGoster(title: "İşlem Tamam", message: "Mesajınız iletilmiştir")
                    self.oneriVeSikayetTextField.text = ""
                }
            }
        }
    }
    
    @IBAction func CikisYapTiklandi(_ sender: Any) {
        do{
            try Auth.auth().signOut()//kullanıcıdan çıkış yapmış oluyoruz butona tıkladığımızda, izlyeceğimiz segue de aşşağıda, kullanıcı uygulamaya tekrar girdiğinde giriş yapması gerekecek
            performSegue(withIdentifier: "toGirisEkrani", sender: nil)
        }catch{
            print("Hata")
        }
    }
    
    
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
