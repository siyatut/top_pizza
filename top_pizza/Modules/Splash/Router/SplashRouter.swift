//
//  SplashRouterProtocol.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//


import UIKit

protocol SplashRouterProtocol {
    func routeToAuth(from view: UIViewController)
}

final class SplashRouter: SplashRouterProtocol {
    func routeToAuth(from view: UIViewController) {
        let authVC = AuthAssembly.createAuthModule()
        view.navigationController?.setViewControllers([authVC], animated: true)
    }
}
