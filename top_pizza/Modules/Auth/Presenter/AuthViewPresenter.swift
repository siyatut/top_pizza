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
        guard let email = email, let password = password else {
            view?.showError(message: "Заполните все поля")
            return
        }
        
        guard email.contains("@"), password.count >= 6 else {
            view?.showError(message: "Некорректный email или пароль")
            return
        }

        if email == "pizza@top.ru" && password == "123456" {
            view?.showSuccess()
            // router.routeToMain() // когда появится main
        } else {
            view?.showError(message: "Неверный логин или пароль")
        }
    }
}
