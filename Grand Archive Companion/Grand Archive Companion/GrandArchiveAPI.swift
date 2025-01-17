//
//  GrandArchiveAPI.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/17/25.
//

import Foundation

struct APIResponse: Codable {
    let data: [Card]
}

func performCardSearch(for term: String) async throws -> [Card] {
    let url = URL(string: "https://api.gatcg.com/cards/search?name=\(term)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    
//    print(String(data: data, encoding: .utf8) ?? "No data")
    
    let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
    return apiResponse.data
}
