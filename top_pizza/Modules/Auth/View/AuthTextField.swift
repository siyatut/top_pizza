//
//  AuthTextField.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//

import UIKit

final class AuthTextField: UIView {

    let textField = UITextField()

    private let iconImageView: UIImageView
    private let eyeButton: UIButton?

    init(placeholder: String, systemImageName: String, isSecure: Bool = false) {
        iconImageView = UIImageView(image: UIImage(systemName: systemImageName))
        iconImageView.tintColor = .systemGray
        if isSecure {
            eyeButton = UIButton(type: .system)
            eyeButton?.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            eyeButton = nil
        }
        super.init(frame: .zero)

        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor

        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.borderStyle = .none
        textField.autocapitalizationType = .sentences
        textField.backgroundColor = .systemBackground
        textField.tintColor = .systemGray

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        addSubview(textField)

        if let eye = eyeButton {
            eye.translatesAutoresizingMaskIntoConstraints = false
            eye.tintColor = .systemGray
            eye.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)
            addSubview(eye)

            NSLayoutConstraint.activate([
                eye.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                eye.centerYAnchor.constraint(equalTo: centerYAnchor),
                eye.widthAnchor.constraint(equalToConstant: 18),
                eye.heightAnchor.constraint(equalToConstant: 18)
            ])
        }

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            eyeButton != nil
                ? textField.trailingAnchor.constraint(equalTo: eyeButton!.leadingAnchor, constant: -8)
                : textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }

    @objc private func toggleVisibility() {
        let wasResponder = textField.isFirstResponder
        let text = textField.text
        let selected = textField.selectedTextRange

        textField.isSecureTextEntry.toggle()
        textField.text = text

        if wasResponder {
            textField.becomeFirstResponder()
            textField.selectedTextRange = selected
        }

        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton?.setImage(UIImage(systemName: imageName), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
