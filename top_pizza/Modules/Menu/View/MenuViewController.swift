//
//  MenuViewController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

// TODO: - №2 Добавить кнопку с городами с левый верхний угол
// TODO: - №3 Разделить этот модуль по папкам
// TODO: - №4 Меню с категориями не прилипло к верху, а ещё поработать с цветами

import UIKit

final class MenuViewController: UIViewController, MenuView {
    
    private var presenter: MenuPresenter!
    private var showSuccessBanner: Bool
    private var menuSections: [MenuSection] = [
        MenuSection(title: "Пицца", items: []),
        MenuSection(title: "Комбо", items: []),
        MenuSection(title: "Десерты", items: []),
        MenuSection(title: "Напитки", items: [])
    ]
    
    private let categoryView = CategorySelectorView()
    
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
        
        categoryView.delegate = self
        tableView.tableHeaderView = createHeaderView()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset.top = showSuccessBanner ? 64 : 0
        
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: "PizzaCell")
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
    
    private func createHeaderView() -> UIView {
        let container = UIView()
        let banner = BannerView(frame: .zero)
        banner.translatesAutoresizingMaskIntoConstraints = false
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(banner)
        container.addSubview(categoryView)
        
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: container.topAnchor),
            banner.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            banner.heightAnchor.constraint(equalToConstant: 160),
            
            categoryView.topAnchor.constraint(equalTo: banner.bottomAnchor),
            categoryView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 44),
            categoryView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        container.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 160 + 44)
        return container
    }
    
    
    func display(menuItems: [MenuItem]) {
        let chunkSize = menuItems.count / 4
        menuSections[0] = MenuSection(title: "Пицца", items: Array(menuItems[0..<chunkSize]))
        menuSections[1] = MenuSection(title: "Комбо", items: Array(menuItems[chunkSize..<(chunkSize * 2)]))
        menuSections[2] = MenuSection(title: "Десерты", items: Array(menuItems[(chunkSize * 2)..<(chunkSize * 3)]))
        menuSections[3] = MenuSection(title: "Напитки", items: Array(menuItems[(chunkSize * 3)...]))
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaCell", for: indexPath) as? MenuItemCell else {
            return UITableViewCell()
        }
        let pizza = menuSections[indexPath.section].items[indexPath.row]
        cell.configure(with: pizza)
        return cell
    }
}

extension MenuViewController: CategorySelectorDelegate {
    func didSelectCategory(index: Int) {
        guard menuSections[index].items.count > 0 else { return }
        let indexPath = IndexPath(row: 0, section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
