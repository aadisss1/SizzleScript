//
//  AuthApi.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 19/03/2026.
//

struct LoginRequest: Encodable {
    let email:String
    let password: String
}
struct LoginResponse: Decodable {
    let access_token:String
}

struct UserProfile: Decodable {
    let id: Int
    let email: String
    let name: String
}

class AuthApi {
    func login(request: LoginRequest) async throws -> LoginResponse {
        let body = LoginRequest(email: request.email, password: request.password)
        
        return try await ApiClient.shared.request(endpoint: "api/v1/auth/login", method: .post , body:body)
        
    }
    func getProfile(token: String) async throws -> UserProfile {
        return try await ApiClient.shared.request(endpoint: "api/v1/auth/profile", method: .get, token:token)
    }
}
