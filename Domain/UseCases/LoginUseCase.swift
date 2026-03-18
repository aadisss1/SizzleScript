//
//  LoginUseCase.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 18/03/2026.
//
import Foundation

protocol LoginUseCase {
    func execute(email:String, password:String) -> Bool
}

class LoginUseCaseImpl: LoginUseCase {
    func execute(email:String, password: String) -> Bool {
        return 	!email.isEmpty && !password.isEmpty 
    }
}
