//
//  ProfileViewController.swift
//  NetflixClone
//
//  Created by developer on 6/23/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Full Name: "
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Full Name: "
        return label
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Out", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemRed
        button.setTitleColor(UIColor.white, for: .focused)
        button.addTarget(nil, action: #selector(signOut), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(emailLabel)
        view.addSubview(fullNameLabel)
        view.addSubview(signOutButton)
        
        addConstraint()
        getData()
    }
    
    @objc private func signOut() {
        let firebaseAuth = Auth.auth()
           do {
               try firebaseAuth.signOut()
               print("user Logged out")
               let loginVC = EntryViewController()
               (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.backToEntry(loginVC)
               

           } catch {
               print ("Error signing out: %@", error)
           }
    }
    
    private func addConstraint() {
        
        let emailLabelConstraints = [
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.widthAnchor.constraint(equalToConstant: 300)
        ]
        
        let fullnameLabelConstraints = [
            fullNameLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullNameLabel.widthAnchor.constraint(equalToConstant: 300)
        ]
        
        let signOutButtonConstraints = [
            signOutButton.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 20),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signOutButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(emailLabelConstraints)
        NSLayoutConstraint.activate(fullnameLabelConstraints)
        NSLayoutConstraint.activate(signOutButtonConstraints)
    }
}

extension ProfileViewController {
    func getData() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("Netflix/users/\(uid ?? "")").observeSingleEvent(of: .value, with: { snapShot in
            DispatchQueue.main.async { [weak self] in
                let value = snapShot.value as? NSDictionary
                let fullName = value?["fullName"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                self?.emailLabel.text = "Email:   \(email)"
                self?.fullNameLabel.text = "Full Name:   \(fullName)"
            }
            
        })
    }
}
