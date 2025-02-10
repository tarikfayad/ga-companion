//
//  GrandArchiveAPI.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/17/25.
//

import Foundation

struct APIResponse: Codable {
    let data: [CardResponse]
}

func performCardSearch(for term: String) async throws -> [Card] {
    let url = URL(string: "https://api.gatcg.com/cards/search?name=\(term)")!
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return apiResponse.data.map { Card.createCardFromResponse(response: $0) }
    }
    catch {
        print("Failed to fetch cards: \(error)")
        return []
    }
}
