//
//  ViewController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 23/7/2568 BE.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }()
    
    var presenter: SplashPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tintColor
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SplashViewController: SplashViewProtocol {
    func navigateToAuth() {
        presenter.router.routeToAuth(from: self)
    }
}
