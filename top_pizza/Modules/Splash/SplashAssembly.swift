//
//  SplashAssembly.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 24/7/2568 BE.
//

import UIKit

enum SplashAssembly {
    
    static func createSplashModule() -> UIViewController {
        let view = SplashViewController()
        let presenter = SplashPresenter(view: view)
        let router = SplashRouter()
        
        view.presenter = presenter
        presenter.router = router
        
        return view
    }
}
