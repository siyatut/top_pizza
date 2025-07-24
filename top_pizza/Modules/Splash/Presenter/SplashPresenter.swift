//
//  SplashViewProtocol.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//


import UIKit

protocol SplashViewProtocol: AnyObject {
    func navigateToAuth()
}

protocol SplashPresenterProtocol: AnyObject {
    var router: SplashRouterProtocol! { get set }
    func viewDidLoad()
}

final class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol?
    var router: SplashRouterProtocol!

    init(view: SplashViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view?.navigateToAuth()
        }
        print("Splash presenter loaded")
    }
}
