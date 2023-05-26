//
//  BitkilerVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 16.03.2023.
//

import UIKit
import Firebase
import SDWebImage


class BitkilerVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var secilenBitkiBaslik = ""
    var secilenBitkiAciklama = ""
    var secilenBitkiImage = ""
    var secilenbitkiKullanim = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bitkiEklemeButton: UIButton!
    
    var bitkilerDizisi = [Bitki]()
    var guncelKullanici : String = (Auth.auth().currentUser?.email)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        verileriAl()
        if guncelKullanici == "cankls@gmail.com"{
            bitkiEklemeButton.isHidden = false
        }else{
            bitkiEklemeButton.isHidden = true
        }
    }
    
    func verileriAl(){
        let firebaseDatabase = Firestore.firestore()
        firebaseDatabase.collection("Bitki").order(by: "tarih", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription as Any)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.bitkilerDizisi.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        if let gorselUrl = document.get("gorselUrl") as? String{
                            if let bitkiAdi = document.get("baslik") as? String{
                                if let bitkiAciklama = document.get("bitkiAciklama") as? String{
                                    if let bitkiKullanim = document.get("bitkiKullanim") as? String{
                                        let bitki = Bitki(bitkiAdi: bitkiAdi, gorselUrl: gorselUrl, bitkiAciklama: bitkiAciklama, bitkiKullanimi: bitkiKullanim)
                                        self.bitkilerDizisi.append(bitki)
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bitkilerDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BitkiCell", for: indexPath) as! BitkilerCell
        cell.bitkilerBaslikLabel.text = bitkilerDizisi[indexPath.row].bitkiAdi
        cell.bitkilerKisaAciklamaLabel.text = bitkilerDizisi[indexPath.row].bitkiAciklama
        let gorselUrl = bitkilerDizisi[indexPath.row].gorselUrl
        cell.bitkilerImageView.sd_setImage(with: URL(string: gorselUrl))
        return cell
    }
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        secilenBitkiBaslik = bitkilerDizisi[indexPath.row].bitkiAdi
        secilenBitkiAciklama = bitkilerDizisi[indexPath.row].bitkiAciklama
        secilenBitkiImage = bitkilerDizisi[indexPath.row].gorselUrl
        secilenbitkiKullanim = bitkilerDizisi[indexPath.row].bitkiKullanimi
        performSegue(withIdentifier: "toBitkilerDetayVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBitkilerDetayVC"{
            let destinationVC = segue.destination as! BitkilerDetayVC
            destinationVC.secilenBitkiBaslik = secilenBitkiBaslik
            destinationVC.secilenBitkiAciklamasi = secilenBitkiAciklama
            destinationVC.secilenBitkiImage = secilenBitkiImage
            destinationVC.secilenBitkiKullanimi = secilenbitkiKullanim
        }
    }
    
    @IBAction func bitkiEklemeTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "toBitkiEklemeVC", sender: nil)
    }
    
    

}
