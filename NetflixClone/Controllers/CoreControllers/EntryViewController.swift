//
//  EntryViewController.swift
//  NetflixClone
//
//  Created by developer on 6/22/22.
//

import UIKit
import Firebase
import FirebaseAuth
import LocalAuthentication




class EntryViewController: UIViewController {
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "netflixLG1")
        return imageView
    }()
    
    
    private var emailTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(
            string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray]
        )
        field.layer.cornerRadius = 5
        field.backgroundColor = .white
        field.textColor = .black
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        return field
    }()
    
    private var passwordTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(
            string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray]
        )
        field.layer.cornerRadius = 5
        field.backgroundColor = .white
        field.textColor = .black
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemRed
        button.setTitleColor(UIColor.white, for: .focused)
        button.addTarget(nil, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemRed
        button.setTitleColor(UIColor.white, for: .focused)
        button.addTarget(nil, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(errorLabel)
        addConstraints()
    }
    
    
    @objc func loginTapped() {
        print("button tapped")
//        faceIdAuth()
        if let email = emailTextField.text, let pass = passwordTextField.text {
            signIn(email: email, password: pass)
        }
    }
    
    @objc func registerTapped() {
        print("register tapped")
        let vc = registerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil {
                print("user logged in")
                let vc = MainTabBarViewController()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            } else {
                print(error?.localizedDescription ?? "error login")
                self.errorLabel.text = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.errorLabel.text = error?.localizedDescription
                }
            }
        }
                    
    }

    
    private func addConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        let emailConstraints = [
            emailTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let passwordConstraints = [
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let errorLabelconstraints = [
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.widthAnchor.constraint(equalToConstant: 320)
        ]
        
        let loginButtonConstraints = [
            loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let registerButtonConstraints = [
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            registerButton.widthAnchor.constraint(equalToConstant: 150),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        
        
        NSLayoutConstraint.activate(emailConstraints)
        NSLayoutConstraint.activate(passwordConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(errorLabelconstraints)
    }
    

    

}

extension EntryViewController {
    func faceIdAuth() {
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Login with face id"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    
                    guard success, error == nil else {
                        let alert = UIAlertController(title: "Failed to log in", message: "Please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    
                    // show next vc
                    let vc = MainTabBarViewController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                }
            }
        } else {
            
            let alert = UIAlertController(title: "Unavailabale", message: "Can't use face id", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            
        }
    }
}
