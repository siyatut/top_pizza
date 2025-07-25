//
//  MainTabBarController.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

import UIKit

final class MainTabBarController: UITabBarController {

    private let showSuccessBanner: Bool

    init(showSuccessBanner: Bool = false) {
        self.showSuccessBanner = showSuccessBanner
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemPink
        setupTabs()
    }

    private func setupTabs() {
        let menuVC = MenuViewController(showSuccessBanner: showSuccessBanner)
        menuVC.tabBarItem = UITabBarItem(title: "Меню", image: UIImage(systemName: "menucard"), tag: 0)

        let contactsVC = PlaceholderViewController(title: "Контакты")
        contactsVC.tabBarItem = UITabBarItem(title: "Контакты", image: UIImage(systemName: "mappin.and.ellipse"), tag: 1)

        let profileVC = PlaceholderViewController(title: "Профиль")
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.fill"), tag: 2)

        let cartVC = PlaceholderViewController(title: "Корзина")
        cartVC.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "trash"), tag: 3)

        viewControllers = [
            UINavigationController(rootViewController: menuVC),
            UINavigationController(rootViewController: contactsVC),
            UINavigationController(rootViewController: profileVC),
            UINavigationController(rootViewController: cartVC)
        ]
    }
}
