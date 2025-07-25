//
//  PizzaServiceProtocol.swift
//  top_pizza
//
//  Created by Anastasia Tyutinova on 25/7/2568 BE.
//

import UIKit

protocol PizzaServiceProtocol {
    func fetchPizzas(completion: @escaping (Result<[Pizza], Error>) -> Void)
}

final class PizzaService: PizzaServiceProtocol {
    func fetchPizzas(completion: @escaping (Result<[Pizza], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(PizzaResponse.self, from: data)
                completion(.success(decoded.products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
