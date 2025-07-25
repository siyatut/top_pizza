//
//  Pizza.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

struct Pizza: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Int
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id, title, description, price
        case imageUrl = "thumbnail"
    }
}

struct PizzaResponse: Decodable {
    let products: [Pizza]
}

