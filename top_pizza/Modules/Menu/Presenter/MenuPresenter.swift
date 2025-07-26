//
//  MenuPresenter.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

import UIKit

protocol MenuView: AnyObject {
    func display(menuItems: [MenuItem])
    func display(error: String)
}

final class MenuPresenter {
    
    // MARK: - Properties
    
    private weak var view: MenuView?
    private let service: PizzaServiceProtocol
    
    // MARK: - Initialization
    
    init(view: MenuView, service: PizzaServiceProtocol = PizzaService()) {
        self.view = view
        self.service = service
    }
    
    // MARK: - Public Methods
    
    func loadMenu() {
        service.fetchPizzas { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pizzas):
                    self?.view?.display(menuItems: pizzas)
                case .failure(let error):
                    self?.view?.display(error: error.localizedDescription)
                }
            }
        }
    }
}
