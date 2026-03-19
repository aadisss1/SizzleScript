//
//  KeyChainManager.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 19/03/2026.
//

class KeyChainManager {
    static var shared = KeyChainManager()
    
    private init() {}
    
    private var tokenKey: String { "sizzleScriptToken" }
    privaye var userIdKey: String { "sizzleScriptUserId" }
    
    func getToken() async throws -> String? {
        try await KeychainItem<String>.fetchItem(forKey: tokenKey)
    }
    func getUserId() async throws -> String? {
        try await KeychainItem<String>.fetchItem(forKey: userIdKey)
    }
    
    func saveToken(_ token: String) async throws {
        try await KeychainItem<String>.saveItem(token, forKey: tokenKey)
    }
    func saveUserId(_ userId: String) async throws {
        try await KeychainItem<String>.saveItem(userId, forKey: userIdKey)
    }
}
