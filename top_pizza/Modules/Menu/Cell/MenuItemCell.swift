//
//  MenuItemCell.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

import UIKit

final class MenuItemCell: UITableViewCell {
    
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with pizza: MenuItem) {
        titleLabel.text = pizza.title
        descriptionLabel.text = pizza.description
        priceButton.setTitle("от \(pizza.price) р", for: .normal)
        itemImageView.loadImage(from: pizza.imageUrl)
    }

    private func setupLayout() {
        [itemImageView, titleLabel, descriptionLabel, priceButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 10

        titleLabel.font = .boldSystemFont(ofSize: 17)
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .gray

        priceButton.setTitleColor(.systemPink, for: .normal)
        priceButton.layer.cornerRadius = 6
        priceButton.layer.borderColor = UIColor.systemPink.cgColor
        priceButton.layer.borderWidth = 1

        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 132),
            itemImageView.heightAnchor.constraint(equalToConstant: 132),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            priceButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            priceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            priceButton.widthAnchor.constraint(equalToConstant: 100),
            priceButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
