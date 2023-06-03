//
//  BitkilerDetayVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 16.03.2023.
//

import UIKit
import SDWebImage
import Firebase


final class BitkilerDetayVC: UIViewController{

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
    var guncelKullanici = Auth.auth().currentUser?.email
    let admin = "cankls@gmail.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if admin == guncelKullanici{
            duzenleButton.isHidden = false
        }else{
            duzenleButton.isHidden = true
        }
        bitkiBaslikLabel.text = self.secilenBitkiBaslik
        bitkiAciklamaLabel.text = secilenBitkiAciklamasi
        if let imageUrl = URL(string: secilenBitkiImage) {
            bitkiImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        bitkiTarifLabel.text = secilenBitkiKullanimi
        favoriDurumuKontrol()
    }
    
    @IBAction func favoriEkleTiklandi(_ sender: Any) {
        if favoriEklemeButton.title(for: .normal) == "Favorilere Ekle"{
            favoriEkle()
        }else{
            favoridenKaldir()
        }
    }
    func secilenBitkiBulma(){
        let fd = Firestore.firestore()
        fd.collection("Bitkiler").document(secilenBitkiDocumentID).getDocument{ document, error in
            if error != nil{
                print(error?.localizedDescription as Any)
            }else{
                if let document = document{
                    self.bitkiBaslikLabel.text = document.get("baslik") as? String;
                    self.bitkiTarifLabel.text = document.get("bitkiAciklama") as? String;
                    self.bitkiTarifLabel.text = document.get("bitkiKullanim") as? String;
                }
            }
        }
        self.bitkiImageView.sd_setImage(with: URL(string: self.secilenBitkiImage))
    }
    func favoriEkle (){
        let firestoreDatabase = Firestore.firestore()
        if let güncelKullanici = Auth.auth().currentUser?.email!{
            let favoriBitki = ["bitkiDocumentID" : secilenBitkiDocumentID, "kullanici" : güncelKullanici, "bitkiAdi" : secilenBitkiBaslik,"bitkiKullanim": secilenBitkiKullanimi,"bitkiAciklama": secilenBitkiAciklamasi ,"gorselUrl" : secilenBitkiImage ,"tarih" : FieldValue.serverTimestamp()] as [String : Any]
                firestoreDatabase.collection("FavoriBitkiler").addDocument(data: favoriBitki) { (error) in
                 if error != nil{
                     self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                 }else{
                     print("Favori belge başarıyla eklendi.")
                     self.favoriEklemeButton.setTitle("Favorilerden Kaldır", for: .normal)
                 }
             }
        }
    }
    func favoridenKaldir() {
        let firestoreDatabase = Firestore.firestore()
        if let güncelKullanici = Auth.auth().currentUser?.email {
            let favoritesRef = firestoreDatabase.collection("FavoriBitkiler")
            let query = favoritesRef.whereField("kullanici", isEqualTo: güncelKullanici).whereField("bitkiDocumentID", isEqualTo: secilenBitkiDocumentID)
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
                            self.favoriEklemeButton.setTitle("Favorilere Ekle", for: .normal)
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
            let query = favoritesRef.whereField("kullanici", isEqualTo: güncelKullanici).whereField("bitkiDocumentID", isEqualTo: secilenBitkiDocumentID)
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
                }else{
                    // Kullanıcı bu bitkiyi favorilere eklemiş, butonu Favorilerden Kaldır olarak ayarla
                    self.favoriEklemeButton.setTitle("Favorilerden Kaldır", for: .normal)
                }
            }
        }
    }
    @IBAction func bitkiSilTiklandi(_ sender: Any) {
        bitkiCollectionDelete()
        favoriBitkiCollectionDelete()
    }
    func bitkiCollectionDelete() {
        let db = Firestore.firestore()
        db.collection("Bitki").whereField("baslik", isEqualTo: secilenBitkiBaslik).getDocuments{ snapshot, error in
            if let error = error {
                self.mesajGoster(title: "Hata", message: error.localizedDescription)
            }else {
                if let documents = snapshot?.documents {
                    for document in documents {
                        document.reference.delete { error in
                            if let error = error {
                                self.mesajGoster(title: "Hata", message: error.localizedDescription)
                            } else {
                                self.mesajGoster(title: "Onaylandı", message: "Silme işleminiz gerçekleşti!")
                            }
                        }
                    }
                }else {
                    print("Bitki bulunamadı")
                }
            }
        }
    }
    func favoriBitkiCollectionDelete() {
        let db = Firestore.firestore()
        db.collection("FavoriBitkiler").whereField("bitkiDocumentID", isEqualTo: secilenBitkiDocumentID).getDocuments { snapshot, error in
            if let error = error {
                self.mesajGoster(title: "Hata", message: error.localizedDescription)
            }else {
                if let documents = snapshot?.documents {
                    for document in documents {
                        document.reference.delete { error in
                            if let error = error {
                                self.mesajGoster(title: "Hata", message: error.localizedDescription)
                            } else {
                                self.mesajGoster(title: "Onaylandı", message: "Silme işleminiz gerçekleşti!")
                            }
                        }
                    }
                }else {
                    print("Bitki bulunamadı")
                }
            }
        }
    }
    @IBAction func bitkiDüzenleTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "frombitkiDüzenlemeToBitkiEkleme", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "frombitkiDüzenlemeToBitkiEkleme"{
            let destinationVC = segue.destination as! BitkiEklemeVC
            destinationVC.secilenBitkiBaslik = secilenBitkiBaslik
            destinationVC.secilenBitkiAciklamasi = secilenBitkiAciklamasi
            destinationVC.secilenBitkiKullanimi = secilenBitkiKullanimi
            destinationVC.secilenBitkiDocumentID = secilenBitkiDocumentID
            destinationVC.secilenBitkiImage = secilenBitkiImage
        }
    }
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
