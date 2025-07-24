//
//  AuthAssembly.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//


import UIKit

enum AuthAssembly {
    static func createAuthModule() -> UIViewController {
        let view = AuthViewController()
        let presenter = AuthPresenter(view: view)
        let router = AuthRouter()

        view.presenter = presenter
        presenter.router = router

        return view
    }
}
