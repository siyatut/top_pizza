//
//  MenuViewController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

import UIKit

final class MenuViewController: UIViewController, MenuView {
    
    private var presenter: MenuPresenter!
    
    private let tableView = UITableView()
    private var pizzas: [Pizza] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter = MenuPresenter(view: self)
        presenter.loadMenu()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(PizzaCell.self, forCellReuseIdentifier: "PizzaCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func display(pizzas: [Pizza]) {
        self.pizzas = pizzas
        tableView.reloadData()
    }

    func display(error: String) {
        print("Error loading pizzas: \(error)")
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaCell", for: indexPath) as? PizzaCell else {
            return UITableViewCell()
        }
        cell.configure(with: pizzas[indexPath.row])
        return cell
    }
}
