//
//  AuthRepositoryImpl.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 19/03/2026.
//

class AuthRepositoryImpl:AuthRepositoryProtocol{
   private let apiClient = AuthApi()
    
    func login(username: String, password: String) -> User {
       let loginResponse = try await apiClient.login(username: username, password: password)
        let profile = try await apiClient.getProfile(token: loginResponse.access_token)
        KeyChainManager.shared.save(token: profile.token)
        return User (id: profile.id, email: profile.email, token: profile.token)
    }
}
