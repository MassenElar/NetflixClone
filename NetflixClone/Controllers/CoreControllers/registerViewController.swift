//
//  registerViewController.swift
//  NetflixClone
//
//  Created by developer on 6/22/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import Firebase

class registerViewController: UIViewController {
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .systemRed
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "netflixLG1")
        return imageView
    }()
    
    private var fullNameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(
            string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray]
        )
        field.layer.cornerRadius = 5
        field.backgroundColor = .white
        field.textColor = .systemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        return field
    }()
    
    
    private var emailTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(
            string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray]
        )
        field.layer.cornerRadius = 5
        field.backgroundColor = .white
        field.textColor = .systemBackground
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
        field.textColor = .systemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private var passwordConfirmTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray]
        )
        field.layer.cornerRadius = 5
        field.backgroundColor = .white
        field.textColor = .systemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemRed
        button.setTitleColor(UIColor.white, for: .focused)
        button.addTarget(nil, action: #selector(registerUser), for: .touchUpInside)
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(fullNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordConfirmTextField)
        view.addSubview(imageView)
        view.addSubview(registerButton)
        view.addSubview(errorLabel)
        
        addConstraints()
    }
    
    
    @objc func registerUser() {
        print("register tapped")
        if let email = emailTextField.text, let fullname = fullNameTextField.text, let pass = passwordTextField.text, let passConfirm = passwordConfirmTextField.text {
            
            createNewUser(email: email, password: pass, fullName: fullname, passConfirm: passConfirm)
        }
    }
    
    private func createNewUser(email: String, password: String, fullName: String, passConfirm: String) {
        if password != passConfirm {
            errorLabel.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.errorLabel.text = "Password doesn't match"
            }
            return
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: email, password: password) { user, error in
                        let uid = Auth.auth().currentUser?.uid
                        let ref = Database.database().reference(withPath: "Netflix/users").child(uid ?? "")
                        let vc = MainTabBarViewController()
                        ref.setValue(["uid": uid, "email": email, "fullName": fullName])
                        self.navigationController?.pushViewController(vc, animated: true)
                        print("user registred")
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                        self?.errorLabel.text = error?.localizedDescription 
                    }
                    print(error?.localizedDescription ?? "failed to create user")
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
        
        let fullNameConstraints = [
            fullNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            fullNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            fullNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let emailConstraints = [
            emailTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 20),
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
        
        let passwordConfirmConstraints = [
            passwordConfirmTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            passwordConfirmTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordConfirmTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let errorLabelconstraints = [
            errorLabel.topAnchor.constraint(equalTo: passwordConfirmTextField.bottomAnchor, constant: 10),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let registerButtonConstraints = [
            registerButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10),
            registerButton.widthAnchor.constraint(equalToConstant: 150),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        
        
        NSLayoutConstraint.activate(fullNameConstraints)
        NSLayoutConstraint.activate(emailConstraints)
        NSLayoutConstraint.activate(passwordConstraints)
        NSLayoutConstraint.activate(passwordConfirmConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(errorLabelconstraints)
    }
    
   

}
