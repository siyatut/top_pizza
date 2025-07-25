//
//  MenuViewController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

import UIKit

final class MenuViewController: UIViewController, MenuView {
    
    private var presenter: MenuPresenter!
    private var showSuccessBanner: Bool
    private var pizzas: [Pizza] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private let successBanner: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.isHidden = true
        
        let label = UILabel()
        label.text = "Вход выполнен успешно"
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let check = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        check.tintColor = .systemGreen
        check.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(check)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            check.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            check.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            check.widthAnchor.constraint(equalToConstant: 20),
            check.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return view
    }()
    
    init(showSuccessBanner: Bool = false) {
        self.showSuccessBanner = showSuccessBanner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        presenter = MenuPresenter(view: self)
        presenter.loadMenu()
        
        setupTableView()
        setupSuccessBanner()
        
        let bannerView = BannerView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 160))
        tableView.tableHeaderView = bannerView
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset.top = showSuccessBanner ? 64 : 0
        
        tableView.register(PizzaCell.self, forCellReuseIdentifier: "PizzaCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupSuccessBanner() {
        
        view.addSubview(successBanner)
        view.bringSubviewToFront(successBanner)
        successBanner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            successBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            successBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            successBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            successBanner.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        if showSuccessBanner {
            successBanner.alpha = 0
            successBanner.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.successBanner.alpha = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.successBanner.alpha = 0
                }) { _ in
                    self.successBanner.isHidden = true
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
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
