//
//  FarkindalikVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 16.03.2023.
//

import UIKit
import Firebase
import SDWebImage

class FavorilerVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var favoriBitkilerinizLabel: UILabel!
    @IBOutlet weak var favoriBitkilerTableView: UITableView!
    
    var favoriBitkilerDizisi = [FavoriBitki]()
    var guncelKullanici = Auth.auth().currentUser?.email
    var guncelKullaniciAdi = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kullaniciAdiBulma()
        favoriBitkilerTableView.delegate = self
        favoriBitkilerTableView.dataSource = self
        favoriBitkileriGetir()
    }
    
    func favoriBitkileriGetir() {
        let firestoreDatabase = Firestore.firestore()
        if let güncelKullanici = Auth.auth().currentUser?.email {
            let favoritesRef = firestoreDatabase.collection("FavoriBitkiler")
            let query = favoritesRef.whereField("kullanici", isEqualTo: güncelKullanici)
            
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Favori bitkileri alınırken hata oluştu: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("Favori bitki belgeleri bulunamadı.")
                    return
                }
                for document in documents {
                    if let bitkiDocumentID = document.get("bitkiDocumentID") as? String,
                       let bitkiAdi = document.get("bitkiAdi") as? String,
                       let bitkiGorselURL = document.get("bitkiGorselURL") as? String {
                            let favoriBitki = FavoriBitki(bitkiDocumentID: bitkiDocumentID, bitkiAdi: bitkiAdi, bitkiGorselURL: bitkiGorselURL)
                            self.favoriBitkilerDizisi.append(favoriBitki)
                    }
                }
                
                // Favori bitkileri alındıktan sonra tablo görünümünü güncelle
                self.favoriBitkilerTableView.reloadData()
                self.favoriBitkilerinizLabel.text = "Favori \(self.favoriBitkilerDizisi.count) bitkiniz"
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriBitkilerDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriBitkiCell", for: indexPath) as! FavoriBitkilerCell
        let favoriBitki = favoriBitkilerDizisi[indexPath.row].bitkiGorselURL
        cell.bitkiAdiLabel.text = favoriBitkilerDizisi[indexPath.row].bitkiAdi
        cell.imageView?.sd_setImage(with: URL(string: favoriBitki), completed: nil)
        return cell
    }
    
    func kullaniciAdiBulma(){
        let db = Firestore.firestore()
        db.collection("User").whereField("email", isEqualTo: guncelKullanici as Any).addSnapshotListener { (snapshot, Error) in
            if let Error = Error {
                self.mesajGoster(title: "Hata", message: Error.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    for documnet in snapshot!.documents{
                        self.guncelKullaniciAdi = documnet.get("username") as Any as! String
                        self.kullaniciAdiLabel.text = self.guncelKullaniciAdi
                    }
                }
            }
        }
    }
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
