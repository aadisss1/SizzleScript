//
//  LoginUseCase.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 18/03/2026.
//
import Foundation

class LoginUseCase {
    private let loginRepository: AuthRepositoryProtocol
    
    init(loginRepository: AuthRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    func execute(username: String, password: String) async throws -> User {
        return try await self.loginRepository.login(email: username, password: password)
            
        
    }
    
}
