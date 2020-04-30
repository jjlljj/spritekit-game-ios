//
//  MainViewController.swift
//  programmatic-ios
//
//  Created by James on 4/30/20.
//  Copyright © 2020 jjlljj. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        setupLoginContentView()
        
        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    func setupLoginContentView() {
        view.addSubview(loginContentView)
        loginContentView.addSubview(emailTextField)
        loginContentView.addSubview(passwordTextField)
        loginContentView.addSubview(loginButton)
        loginContentView.translatesAutoresizingMaskIntoConstraints = false //set this for Auto Layout to work!
        loginContentView.heightAnchor.constraint(
            equalToConstant: view.frame.height/3).isActive = true
        loginContentView.leftAnchor.constraint(
            equalTo: view.leftAnchor).isActive = true
        loginContentView.rightAnchor.constraint(
            equalTo: view.rightAnchor).isActive = true
        loginContentView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor).isActive = true
       
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
    }
    func setupEmailTextField() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.isUserInteractionEnabled = true
        emailTextField.backgroundColor = .white
        emailTextField.frame.size.width = 200
        emailTextField.frame.size.height = 20
        emailTextField.topAnchor.constraint(
            equalTo: loginContentView.topAnchor,
            constant: 40).isActive = true
        emailTextField.centerXAnchor.constraint(
            equalTo: loginContentView.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(
            equalToConstant: 300).isActive = true
        emailTextField.heightAnchor.constraint(
            equalToConstant: 40).isActive = true
    }
    func setupPasswordTextField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isUserInteractionEnabled = true
        passwordTextField.backgroundColor = .white
        passwordTextField.frame.size.width = 200
        passwordTextField.frame.size.height = 20
        passwordTextField.topAnchor.constraint(
            equalTo: emailTextField.bottomAnchor,
            constant: 40).isActive = true
        passwordTextField.centerXAnchor.constraint(
            equalTo: loginContentView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(
            equalToConstant: 300).isActive = true
        passwordTextField.heightAnchor.constraint(
            equalToConstant: 40).isActive = true
    }
    func setupLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.isUserInteractionEnabled = true
        loginButton.backgroundColor = .white
        loginButton.frame.size.width = 100
        loginButton.frame.size.height = 30
        loginButton.topAnchor.constraint(
            equalTo: passwordTextField.bottomAnchor,
            constant: 40).isActive = true
        loginButton.centerXAnchor.constraint(
            equalTo: loginContentView.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(
            equalToConstant: 100).isActive = true
        loginButton.heightAnchor.constraint(
            equalToConstant: 30).isActive = true
    }
    
    lazy var textField: UITextField! = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.textAlignment = .center
        
        return view
    }()
    
   let loginContentView: UIView = {
       let view = UIView()
       view.backgroundColor = .green
       return view
   }()
   let emailTextField: UITextField = {
       let textField = UITextField()
       textField.placeholder = "EMAIL"
       return textField
   }()
   let passwordTextField: UITextField = {
       let textField = UITextField()
       textField.placeholder = "PASSWORD (MIN. 8 CHARACTERS)"
       return textField
   }()
   let loginButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Login", for: .normal)
       button.addTarget(
           self,
           action: #selector(loginButtonPressed),
           for: UIControl.Event.touchUpInside)
       return button
   }()
    
    @objc func loginButtonPressed(sender: UIButton!) {
    }
}
