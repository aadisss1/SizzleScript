//
//  LoginViewModel.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 18/03/2026.
//


import Combine
import Foundation

class LoginViewModel: ObservableObject {
    
    // MARK: - Input
    @Published var email: String = ""
    @Published var password: String = ""
    
    // MARK: - Output / Validation
    @Published var isEmailValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var canLogin: Bool = false
    
    // MARK: - UI States
    @Published var shakeEmail: Bool = false
    @Published var shakePassword: Bool = false
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var didTryLogin: Bool = false
    
    // Combine
    private var cancellables = Set<AnyCancellable>()
    
    // Use Case
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        setupValidation()
    }
    
    // MARK: - Combine Validation
    private func setupValidation() {
        // Validate email & password dynamically
        $email
            .map { !$0.isEmpty && self.isValidEmail($0) }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)
        
        $password
            .map { !$0.isEmpty }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellables)
        
        // Combine both for canLogin
        Publishers.CombineLatest($isEmailValid, $isPasswordValid)
            .map { $0 && $1 }
            .assign(to: \.canLogin, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Login Logic
    // MARK: - Login Logic
    func login() {
        var hasError = false
        didTryLogin = true
        // Email empty or invalid
        if email.isEmpty || !isValidEmail(email) {
            shakeEmailAnimation()
            isEmailValid = false
            hasError = true
        }
        
        // Password empty
        if password.isEmpty {
            shakePasswordAnimation()
            isPasswordValid = false
            hasError = true
        }
        
        guard !hasError else { return }
        
        // ✅ Success flow
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // just set state, View will handle animation
            self.isSuccess = true
        }
    }

    // MARK: - Shake Animations
    private func shakeEmailAnimation() {
        shakeEmail = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.shakeEmail = false
        }
    }

    private func shakePasswordAnimation() {
        shakePassword = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.shakePassword = false
        }
    }

    // MARK: - Email Regex Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

}
