//
//  BitkilerDetayVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 16.03.2023.
//

import UIKit
import SDWebImage
import Firebase


class BitkilerDetayVC: UIViewController{

    @IBOutlet weak var bitkiBaslikLabel: UILabel!
    @IBOutlet weak var bitkiAciklamaLabel: UILabel!
    @IBOutlet weak var bitkiImageView: UIImageView!
    @IBOutlet weak var bitkiTarifLabel: UILabel!
    @IBOutlet weak var favoriEklemeButton: UIButton!
    @IBOutlet weak var duzenleButton: UIButton!
    
    var secilenBitkiBaslik = ""
    var secilenBitkiAciklamasi = ""
    var secilenBitkiImage = ""
    var secilenBitkiKullanimi = ""
    var secilenBitkiDocumentID = ""
    
    let admin = "cankls@gmail.com"
    var guncelKullanici = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        if admin == guncelKullanici{
            duzenleButton.isHidden = true
        }else{
            duzenleButton.isHidden = false
        }
        bitkiBaslikLabel.text = secilenBitkiBaslik
        bitkiAciklamaLabel.text = secilenBitkiAciklamasi
        if let imageUrl = URL(string: secilenBitkiImage) {
            bitkiImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        bitkiTarifLabel.text = secilenBitkiKullanimi
        super.viewDidLoad()
        favoriDurumuKontrol()
    }
    
    
    @IBAction func favoriEkleTiklandi(_ sender: Any) {
        if favoriEklemeButton.title(for: .normal) == "Favorilere Ekle"{
            favoriEkle()
        }else{
            favoridenKaldir()
        }
    }
    
   func favoriEkle (){
        let firestoreDatabase = Firestore.firestore()
        if let güncelKullanici = Auth.auth().currentUser?.email!{
            let favoriBitki = ["bitkiDocumentID" : secilenBitkiDocumentID, "kullanici" : güncelKullanici, "bitkiAdi" : secilenBitkiBaslik, "bitkiGorselURL" : secilenBitkiImage ,"tarih" : FieldValue.serverTimestamp()] as [String : Any]
                firestoreDatabase.collection("FavoriBitkiler").addDocument(data: favoriBitki) { (error) in
                 if error != nil{
                     self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                 }else{
                     self.tabBarController?.selectedIndex = 2
                 }
             }
        }
    }
    func favoridenKaldir() {
        let firestoreDatabase = Firestore.firestore()
        if let güncelKullanici = Auth.auth().currentUser?.email {
            let favoritesRef = firestoreDatabase.collection("FavoriBitkiler")
            let query = favoritesRef.whereField("kullanici", isEqualTo: güncelKullanici)
                                   .whereField("bitkiDocumentID", isEqualTo: secilenBitkiDocumentID)
            
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    self.mesajGoster(title: "Hata", message: error.localizedDescription )
                }
                guard let documents = snapshot?.documents else {
                    print("Favori belgeleri bulunamadı.")
                    return
                }
                
                for document in documents {
                    favoritesRef.document(document.documentID).delete { (error) in
                        if let error = error {
                            print("Favori belge silinirken hata oluştu: \(error.localizedDescription)")
                        } else {
                            print("Favori belge başarıyla silindi.")
                        }
                    }
                }
            }
        }
    }
    func favoriDurumuKontrol() {
        let firestoreDatabase = Firestore.firestore()
        if let güncelKullanici = Auth.auth().currentUser?.email {
            let favoritesRef = firestoreDatabase.collection("FavoriBitkiler")
            let query = favoritesRef.whereField("kullanici", isEqualTo: güncelKullanici)
                                   .whereField("bitkiDocumentID", isEqualTo: secilenBitkiDocumentID)
            
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Favori belgeleri alınırken hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("Favori belgeleri bulunamadı.")
                    return
                }
                
                if documents.isEmpty {
                    // Kullanıcı bu bitkiyi favorilere eklememiş, butonu Favorilere Ekle olarak ayarla
                    self.favoriEklemeButton.setTitle("Favorilere Ekle", for: .normal)
                } else {
                    // Kullanıcı bu bitkiyi favorilere eklemiş, butonu Favorilerden Kaldır olarak ayarla
                    self.favoriEklemeButton.setTitle("Favorilerden Kaldır", for: .normal)
                }
            }
        }
    }

    
    @IBAction func bitkiDüzenleTiklandi(_ sender: Any) {
        
    }
    
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
