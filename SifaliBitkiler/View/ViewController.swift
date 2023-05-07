//
//  ViewController.swift
//  SifaliBitkiler
//
//  Created by Erbil Can on 15.03.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var kullaniciAdiTextField: UITextField!
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func girisYapTiklandi(_ sender: UIButton) {
        if emailTextField.text != "" && sifreTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!){
                (AuthDataResult, error) in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız. Tekrar deneyiniz")
                }else{
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }
    }
    
    @IBAction func kayitOlTiklandi(_ sender: UIButton) {
        if emailTextField.text != "" && sifreTextField.text != "" && kullaniciAdiTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!){
                (AuthDataResult, error) in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error!.localizedDescription)
                }
                else{
                    let firestoreDatabase = Firestore.firestore()
                    let firestoreUser = ["userID" : Auth.auth().currentUser?.uid , "username" : self.kullaniciAdiTextField.text! , "email" : self.emailTextField.text! , "createDate" : FieldValue.serverTimestamp()] as [String : Any]
                    firestoreDatabase.collection("User").document(Auth.auth().currentUser!.uid).setData(firestoreUser) { (error) in
                        if error != nil{
                            self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                        }else{
                            self.kullaniciAdiTextField.text = ""
                            self.emailTextField.text = ""
                            self.sifreTextField.text = ""
                        }
                    }
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
                
            }
            //kullanıcı kayıt işlemleri
        }
    }
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
       
    }
}

