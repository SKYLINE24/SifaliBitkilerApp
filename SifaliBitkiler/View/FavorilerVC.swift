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
    
    var favoriBitkilerDizisi = [Bitki]()
    var guncelKullanici = Auth.auth().currentUser?.email
    var guncelKullaniciAdi = ""
    var secilenBitkiBaslik = ""
    var secilenBitkiAciklama = ""
    var secilenBitkiImage = ""
    var secilenbitkiKullanim = ""
    var secilenBitkiDocumentID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kullaniciAdiBulma()
    }
    override func viewWillAppear(_ animated: Bool) {
        favoriBitkileriGetir()
        favoriBitkilerTableView.delegate = self
        favoriBitkilerTableView.dataSource = self
    }
    func favoriBitkileriGetir() {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("FavoriBitkiler").order(by: "tarih", descending: true).whereField("kullanici", isEqualTo: guncelKullanici as Any).addSnapshotListener{ (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.favoriBitkilerDizisi.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        if let gorselUrl = document.get("gorselUrl") as? String{
                            if let bitkiAdi = document.get("bitkiAdi") as? String{
                                if let bitkiAciklama = document.get("bitkiAciklama") as? String{
                                    if let bitkiKullanim = document.get("bitkiKullanim") as? String{
                                        if let bitkiDocumentID = document.get("bitkiDocumentID") as? String{
                                            let bitki = Bitki(bitkiAdi: bitkiAdi, gorselUrl: gorselUrl, bitkiAciklama: bitkiAciklama, bitkiKullanim: bitkiKullanim, bitkiDocumentID: bitkiDocumentID)
                                            self.favoriBitkilerDizisi.append(bitki)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.favoriBitkilerTableView.reloadData()
                    self.favoriBitkilerinizLabel.text = "Favori \(self.favoriBitkilerDizisi.count) bitkiniz"
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriBitkilerDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriBitkiCell", for: indexPath) as! FavoriBitkilerCell
        let favoriBitki = favoriBitkilerDizisi[indexPath.row].gorselUrl
        cell.bitkiAdiLabel.text = favoriBitkilerDizisi[indexPath.row].bitkiAdi
        cell.bitkiImageView.sd_setImage(with: URL(string: favoriBitki), completed: nil)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenBitkiBaslik = favoriBitkilerDizisi[indexPath.row].bitkiAdi
        secilenBitkiAciklama = favoriBitkilerDizisi[indexPath.row].bitkiAciklama
        secilenBitkiImage = favoriBitkilerDizisi[indexPath.row].gorselUrl
        secilenbitkiKullanim = favoriBitkilerDizisi[indexPath.row].bitkiKullanim
        secilenBitkiDocumentID = favoriBitkilerDizisi[indexPath.row].bitkiDocumentID
        performSegue(withIdentifier: "fromFavoriToBitkiDetayVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFavoriToBitkiDetayVC"{
            let destinationVC = segue.destination as! BitkilerDetayVC
            destinationVC.secilenBitkiBaslik = secilenBitkiBaslik
            destinationVC.secilenBitkiAciklamasi = secilenBitkiAciklama
            destinationVC.secilenBitkiImage = secilenBitkiImage
            destinationVC.secilenBitkiKullanimi = secilenbitkiKullanim
            destinationVC.secilenBitkiDocumentID = secilenBitkiDocumentID
        }
    }
    
    func kullaniciAdiBulma(){
        let db = Firestore.firestore()
        db.collection("User").whereField("email", isEqualTo: guncelKullanici as Any).addSnapshotListener { (snapshot, Error) in
            if snapshot?.isEmpty != true && snapshot != nil{
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
    }
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
