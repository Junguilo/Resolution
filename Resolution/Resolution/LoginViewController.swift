//
//  LoginViewController.swift
//  Resolution
//
//  Created by June Eguilos on 11/18/25.
//

import UIKit
import Supabase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var userField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        userField.frame = CGRect(x: userField.frame.origin.x, y: userField.frame.origin.y, width: 300, height: 50)
        userField.layer.cornerRadius = 10
        
        passField.frame = CGRect(x: passField.frame.origin.x, y: passField.frame.origin.y, width: 300, height: 50)
        passField.layer.cornerRadius = 10
        
    }

    func signUpUser(email: String, password: String) async throws{
        try await supabase.auth.signUp(email: email, password: password)
    }

    func signInUser(email: String, password: String) async throws{
        try await supabase.auth.signIn(email: email, password: password)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
        guard let email = userField.text, !email.isEmpty,
            let password = passField.text, !password.isEmpty else {
                print("Please enter both email and password!")
                return
            }

            Task{
                do{
                    try await signInUser(email: email, password: password)
                    await MainActor.run{
                        print("Sign in Successful!")
                    }
                } catch {
                    await MainActor.run{
                        print("Sign in failed")
                    }
                }
            }
    }

    @IBAction func singUpButtonTapped(_ sender: Any) {
        guard let email = userField.text, !email.isEmpty,
            let password = passField.text, !password.isEmpty else {
                print("Please enter both email and password!")
                return
            }

            Task{
                do{
                    try await signUpUser(email: email, password: password)
                    await MainActor.run{
                        print("Sign in Successful!")
                    }
                } catch {
                    await MainActor.run{
                        print("Sign in failed")
                    }
                }
            }
    }
}

extension UIViewController{
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
