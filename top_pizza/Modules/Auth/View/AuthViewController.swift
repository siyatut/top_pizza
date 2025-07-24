//
//  AuthViewController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//

// TODO: - Дёргается при переключении между логином и паролем

import UIKit

final class AuthViewController: UIViewController {
    
    private var bottomConstraint: NSLayoutConstraint!
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
    
    private let bottomPanelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        [authLabel, logoImageView, emailField, passwordField, errorBanner].forEach { $0.translatesAutoresizingMaskIntoConstraints = false;
            view.addSubview($0)
        }
        
        view.addSubview(bottomPanelView)
        bottomPanelView.translatesAutoresizingMaskIntoConstraints = false
        bottomPanelView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = bottomPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            
            authLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(lessThanOrEqualTo: authLabel.bottomAnchor, constant: 121),
            
            emailField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailField.heightAnchor.constraint(equalToConstant: 50),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.bottomAnchor.constraint(lessThanOrEqualTo: bottomPanelView.topAnchor, constant: -79),
            
            bottomPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            bottomPanelView.heightAnchor.constraint(equalToConstant: 88),
            
            loginButton.topAnchor.constraint(equalTo: bottomPanelView.topAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: bottomPanelView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: bottomPanelView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            
            errorBanner.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 8),
            errorBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorBanner.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    @objc private func loginTapped() {
        presenter.login(email: emailField.textField.text, password: passwordField.textField.text)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        bottomConstraint.constant = -keyboardHeight

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        bottomConstraint.constant = 0

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
