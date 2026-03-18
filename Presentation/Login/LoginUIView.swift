import SwiftUI

struct LoginUIView: View {
    
    @StateObject private var viewModel = LoginViewModel(loginUseCase: LoginUseCaseImpl())
    @FocusState private var focusedField: Field?
    
    enum Field : Hashable {
        case email, password
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.blue.opacity(0.7), Color.purple],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Text("Welcome back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    
                    // Email Error
                    if !viewModel.isEmailValid && !viewModel.email.isEmpty {
                        Text("Email is invalid")
                            .foregroundColor(.red)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Email Field
                    TextField("Email/Username", text: $viewModel.email)
                        .padding()
                        .background((viewModel.isEmailValid || !viewModel.didTryLogin) ? Color.gray.opacity(0.1) : Color.orange.opacity(0.3))
                        .cornerRadius(10)
                        .focused($focusedField, equals: .email)
                        .offset(x: viewModel.shakeEmail ? 8 : 0)
                        .animation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true), value: viewModel.shakeEmail)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke((viewModel.isEmailValid || !viewModel.didTryLogin)  ? Color.clear : Color.red, lineWidth: 2)
                        )
                    
                    // Password Field
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background((viewModel.isEmailValid || !viewModel.didTryLogin)  ? Color.gray.opacity(0.1) : Color.orange.opacity(0.3))
                        .cornerRadius(10)
                        .focused($focusedField, equals: .password)
                        .offset(x: viewModel.shakePassword ? 8 : 0)
                        .animation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true), value: viewModel.shakePassword)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke((viewModel.isEmailValid || !viewModel.didTryLogin)  ? Color.clear : Color.red, lineWidth: 2)
                        )
                    
                    // Login Button
                    Button {
                        viewModel.login()
                        // Auto-focus on invalid fields
                        if !viewModel.isEmailValid {
                            focusedField = .email
                        } else if !viewModel.isPasswordValid {
                            focusedField = .password
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(viewModel.isSuccess ? Color.green : Color.blue.opacity(0.8))
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else if viewModel.isSuccess {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .transition(.scale)
                            } else {
                                Text("Login")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .scaleEffect(viewModel.isSuccess ? 1.05 : 1.0)
                        .animation(.spring(), value: viewModel.isSuccess)
                    }
                    .disabled(viewModel.isLoading || !viewModel.canLogin)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                
                Button("Forgot password?") {}
                    .foregroundColor(.white)
            }
        }
    }
}
