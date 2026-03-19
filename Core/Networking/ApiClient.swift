//
//  Apiclient.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 19/03/2026.
//

import Foundation

class ApiClient{
    static let shared = ApiClient()
    private init(){}
    
    private let baseUrl = "";
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable? = nil,
        token: String? = nil
    ) async throws -> T {
        guard let url = URL(string: baseUrl+endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        }
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.serverError
        }
        
        return try  JSONDecoder().decode(T.self, from: data)
        
    }
}
