//
//  AuthViewController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//

import UIKit

final class AuthViewController: UIViewController, UITextFieldDelegate {
    
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
        imageView.contentMode = .scaleAspectFit
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
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private let errorBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.isHidden = true
        return view
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Неверный логин или пароль"
        label.textColor = .systemPink
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let errorCloseButton: UIButton = {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemPink
        button.tintColor = .white
        button.layer.cornerRadius = 9
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(hideErrorBanner), for: .touchUpInside)
        return button
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
        
        emailField.textField.delegate = self
        passwordField.textField.delegate = self
        
        emailField.textField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        [authLabel, logoImageView, emailField, passwordField, errorBannerView, bottomPanelView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false;
            view.addSubview($0)
        }
        errorBannerView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorBannerView.addSubview(errorCloseButton)
        errorCloseButton.translatesAutoresizingMaskIntoConstraints = false
        bottomPanelView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = bottomPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            
            authLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLabel.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
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
            
            passwordField.bottomAnchor.constraint(equalTo: bottomPanelView.topAnchor, constant: -79),
            
            bottomPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            bottomPanelView.heightAnchor.constraint(equalToConstant: 118),
            
            loginButton.topAnchor.constraint(equalTo: bottomPanelView.topAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: bottomPanelView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: bottomPanelView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            
            errorBannerView.topAnchor.constraint(equalTo: authLabel.topAnchor),
            errorBannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorBannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorBannerView.heightAnchor.constraint(equalToConstant: 48),
            
            errorLabel.centerYAnchor.constraint(equalTo: errorBannerView.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: errorBannerView.centerXAnchor),
            
            errorCloseButton.centerYAnchor.constraint(equalTo: errorBannerView.centerYAnchor),
            errorCloseButton.trailingAnchor.constraint(equalTo: errorBannerView.trailingAnchor, constant: -16),
            errorCloseButton.widthAnchor.constraint(equalToConstant: 18),
            errorCloseButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    @objc private func loginTapped() {
        presenter.login(email: emailField.textField.text, password: passwordField.textField.text)
    }
    
    @objc private func keyboardFrameWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        let keyboardHeight = max(view.frame.height - keyboardFrame.origin.y, 0)
        bottomConstraint.constant = -keyboardHeight
        
        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [.beginFromCurrentState, options],
                       animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func textFieldsChanged() {
        let email = emailField.textField.text ?? ""
        let password = passwordField.textField.text ?? ""
        
        let isFormFilled = !email.isEmpty && !password.isEmpty
        loginButton.isEnabled = isFormFilled
        loginButton.alpha = isFormFilled ? 1.0 : 0.5
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AuthViewProtocol

extension AuthViewController: AuthViewProtocol {
    func showError(message: String) {
        errorLabel.text = message
        errorBannerView.isHidden = false
    }
    
    func showSuccess() {
        errorBannerView.isHidden = true
        // сделать дальнейший переход, когда появится main
    }
    
    @objc private func hideErrorBanner() {
        errorBannerView.isHidden = true
    }
}
