//
//  BitkiEklemeVC.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 8.05.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class BitkiEklemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var bitkiBaslikTextField: UITextField!
    @IBOutlet weak var bitkiAciklamaTextField: UITextField!
    @IBOutlet weak var bitkiTarifTextField: UITextField!
    @IBOutlet weak var bitkiImageView: UIImageView!
    var secilenBitkiDocumentID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bitkiImageView.isUserInteractionEnabled = true         // kullanıcı resme tıkladığında işlem yapabilir hale getiriyoruz
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))       //jest algılayıcı(tıklama algılayıcı)
        bitkiImageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func gorselSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary      //nereden alacağımızı belirtiyoruz
        present(pickerController, animated: true, completion: nil)          //bitme buloğu olmayan animasyonlu pickercontroller present et sunmak gibi birşey
    }
    //görseli seçtikten sonra ne yapılacağını yazdığımız fonksiyon
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        bitkiImageView.image = info[.originalImage] as? UIImage      // info bana verilen sözlük bunun içerisine anahtar veriyoruz originalimage seçilen görselin orjinal hali demek
        self.dismiss(animated: true,completion: nil)        //resim seçildikten sonra bu satır ile kapatıyoruz
    }

    @IBAction func bitkiEkleTiklandi(_ sender: Any) {
        if self.bitkiBaslikTextField.text == "" || self.bitkiAciklamaTextField.text == "" || self.bitkiTarifTextField.text == ""{
            mesajGoster(title: "Hata", message: "Boş alanları doldurunuz")
        }else{
            let storage = Storage.storage()
            let storageReferance = storage.reference()
            let mediaFolder = storageReferance.child("Bitkiler")
            if let data = bitkiImageView.image?.jpegData(compressionQuality: 0.5){
                let uuid = UUID().uuidString//ekleyeceğimiz fotoğraflara id vererek her fotoğraf yüklemede bir dosya oluşturmak yerine farklı farklı dosyalar oluştururarak eklenilen bütün fotoğrafları tutabiliyor childdan sonra yazarak tamamlıyoruz
                let imageReferance = mediaFolder.child("\(uuid).jpg")
                imageReferance.putData(data, metadata: nil) { (storagemetadata, error) in
                    //.pudData seçeneğinde metadata ve completion seçeneğini seçiyoruz değerleri (data , nil) 3. seçenekte enter ı tıklıyoruz
                    if error != nil{
                        self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin")
                    }else{
                        imageReferance.downloadURL { (url, error) in
                            if error == nil{
                                let imageUrl = url?.absoluteString//url nin stringe çevrilmiş hali
                              
                                if let imageUrl = imageUrl{
                                    let firestoreDatabase = Firestore.firestore()
                                    let firestorePost = ["gorselUrl" : imageUrl, "bitkiAciklama" : self.bitkiAciklamaTextField.text!, "tarih" : FieldValue.serverTimestamp(), "bitkiKullanim" : self.bitkiTarifTextField.text!, "baslik" : self.bitkiBaslikTextField.text!] as [String : Any]
                                    firestoreDatabase.collection("Bitki").addDocument(data: firestorePost) { (error) in
                                        if error != nil{
                                            self.mesajGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                                        }else{
                                            self.bitkiImageView.image = UIImage(named: "gorselSec")
                                            self.bitkiBaslikTextField.text = ""
                                            self.bitkiAciklamaTextField.text = ""
                                            self.bitkiTarifTextField.text = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        mesajGoster(title: "Kaydedildi", message: "İşleminiz Tamamlandı!")
    }
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
