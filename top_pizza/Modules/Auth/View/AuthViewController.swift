//
//  AuthViewController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//


import UIKit

final class AuthViewController: UIViewController {
    
    var presenter: AuthPresenterProtocol!
    
    private let authLabel: UILabel = {
        let label = UILabel()
        label.text = "Авторизация"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.tintColor = .systemPink
        return imageView
    }()
    
    private let emailField = AuthTextField(placeholder: "Логин", systemImageName: "person.fill")
    
    private let passwordField: AuthTextField = {
            let field = AuthTextField(placeholder: "Пароль", systemImageName: "lock.fill", isSecure: true)
            return field
        }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemPink
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(AuthViewController.self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private let errorBanner: UILabel = {
            let label = UILabel()
            label.backgroundColor = UIColor(red: 1, green: 0.9, blue: 0.9, alpha: 1)
            label.textColor = .systemRed
            label.text = "Неверный логин или пароль"
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textAlignment = .center
            label.layer.cornerRadius = 16
            label.layer.masksToBounds = true
            label.isHidden = true
            return label
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        [authLabel, logoImageView, emailField, passwordField, loginButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false; view.addSubview($0) }

        NSLayoutConstraint.activate([
            authLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 121),
            
            emailField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailField.heightAnchor.constraint(equalToConstant: 50),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 254),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func loginTapped() {
        presenter.login(email: emailField.textField.text, password: passwordField.textField.text)
    }
}

// MARK: - AuthViewProtocol

extension AuthViewController: AuthViewProtocol {
    func showError(message: String) {
        errorBanner.text = message
        errorBanner.isHidden = false
    }

    func showSuccess() {
        errorBanner.isHidden = true
        let alert = UIAlertController(title: "Успех", message: "Вы вошли!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
