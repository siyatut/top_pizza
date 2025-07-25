//
//  MenuViewController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

import UIKit

final class MenuViewController: UIViewController, MenuView {
    
    private var presenter: MenuPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter = MenuPresenter(view: self)
        presenter.loadMenu()
    }

    func display(pizzas: [Pizza]) {
        print("Got \(pizzas.count) pizzas")
    }

    func display(error: String) {
        print("Error loading pizzas: \(error)")
    }
}

