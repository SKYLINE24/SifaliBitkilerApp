//
//  BitkiAramaVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 16.03.2023.
//

import UIKit
import Firebase
import SDWebImage

class BitkiAramaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var aramaTextField: UITextField!
    @IBOutlet weak var aramaListelemeTableView: UITableView!
    
    var searchBitkiAdi = ""
    
    var bitkilerDizisi = [Bitki]()
    
    var secilenBitkiBaslik = ""
    var secilenBitkiAciklama = ""
    var secilenBitkiImage = ""
    var secilenbitkiKullanim = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aramaListelemeTableView.delegate = self
        aramaListelemeTableView.dataSource = self
    }
    
    @IBAction func araButtonTiklandi(_ sender: Any) {
        bitkiSearch()
    }
    
    func bitkiSearch(){
        let firestoreDataBase = Firestore.firestore()
        if let arananBitki = aramaTextField.text{
            firestoreDataBase.collection("Bitki").whereField("baslik", isEqualTo: arananBitki as Any).addSnapshotListener { (snapshot, Error) in
                if Error != nil {
                    print(Error?.localizedDescription as Any)
                }else{
                    if snapshot?.isEmpty != true && snapshot != nil{
                        for document in snapshot!.documents{
                            self.bitkilerDizisi.removeAll(keepingCapacity: false)
                            if let gorselUrl = document.get("gorselUrl") as? String{
                                if let bitkiBaslik = document.get("baslik") as? String{
                                    if let bitkiAciklama = document.get("bitkiAciklama") as? String{
                                        if let bitkiKullanim = document.get("bitkiKullanim") as? String{
                                            let bitkiDocumentID = document.documentID
                                            let arananBitki = Bitki(bitkiAdi: bitkiBaslik, gorselUrl: gorselUrl, bitkiAciklama: bitkiAciklama, bitkiKullanim: bitkiKullanim, bitkiDocumentID: bitkiDocumentID)
                                            self.bitkilerDizisi.append(arananBitki)
                                        }
                                    }
                                }
                            }
                        }
                        self.aramaListelemeTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bitkilerDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AramaListeCell", for: indexPath) as! AramaListelemeCell
        
        let bitki = bitkilerDizisi[indexPath.row]
        cell.bitkiIsimLabel.text = bitki.bitkiAdi
        cell.bitkiImageView.sd_setImage(with: URL(string: bitki.gorselUrl))
        
        return cell
    }
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        secilenBitkiBaslik = bitkilerDizisi[indexPath.row].bitkiAdi
        secilenBitkiAciklama = bitkilerDizisi[indexPath.row].bitkiAciklama
        secilenBitkiImage = bitkilerDizisi[indexPath.row].gorselUrl
        secilenbitkiKullanim = bitkilerDizisi[indexPath.row].bitkiKullanim
        performSegue(withIdentifier: "fromAramaToBitkiDetayVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAramaToBitkiDetayVC"{
            let destinationVC = segue.destination as! BitkilerDetayVC
            destinationVC.secilenBitkiBaslik = secilenBitkiBaslik
            destinationVC.secilenBitkiAciklamasi = secilenBitkiAciklama
            destinationVC.secilenBitkiImage = secilenBitkiImage
            destinationVC.secilenBitkiKullanimi = secilenbitkiKullanim
        }
    }
    
    func mesajGoster(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
