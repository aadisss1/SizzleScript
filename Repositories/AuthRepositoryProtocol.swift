//
//  AuthRepositoryProtocol.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 19/03/2026.
//

protocol AuthRepositoryProtocol {
    func login (email: String, password: String) async throws -> User
}
