//
//  AuthViewProtocol.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//

import UIKit

protocol AuthViewProtocol: AnyObject {
    func showError(message: String)
    func showSuccess()
}

protocol AuthPresenterProtocol: AnyObject {
    func login(email: String?, password: String?)
}

final class AuthPresenter: AuthPresenterProtocol {

    weak var view: AuthViewProtocol?
    var router: AuthRouterProtocol!

    init(view: AuthViewProtocol) {
        self.view = view
    }

    func login(email: String?, password: String?) {
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = password?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty, !password.isEmpty else {
            view?.showError(message: "Заполните все поля")
            return
        }

        guard email == "Qwerty123", password == "Qwerty123" else {
            view?.showError(message: "Неверный логин или пароль")
            return
        }

        view?.showSuccess()
    }
}
