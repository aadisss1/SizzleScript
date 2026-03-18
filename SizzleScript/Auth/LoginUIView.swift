import SwiftUI

struct LoginUIView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var showErrorEmail = false
    @State private var showErrorEmailValidity = false
    @State private var showErrorPassword = false
    
    @State private var shakeEmail = false
    @State private var shakePassword = false
    
    @State private var isSuccess = false
    @State private var isLoading = false
    
    @FocusState private var focusedField: Field?
    
    enum Field : Hashable {
        case email,password
    }
    
    var body: some View {
        ZStack {
            
            //  Background
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
                    
                    //  Email Error
                    if showErrorEmail {
                        Text("Email is required")
                            .foregroundColor(.red)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    else if showErrorEmailValidity {
                        Text("Email is invalid")
                            .foregroundColor(.red)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    //  Email Field
                    TextField("Email/Username", text: $email)
                        .padding()
                        .background(showErrorEmail ? Color.orange.opacity(0.3) : Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .focused($focusedField, equals: .email)
                        .offset(x: shakeEmail ? 8 : 0)
                        .animation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true), value: shakeEmail)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showErrorEmail ? Color.red : Color.clear, lineWidth: 2)
                        )
                    
                    // Password Error
                    if showErrorPassword {
                        Text("Password is required")
                            .foregroundColor(.red)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    //  Password Field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(showErrorPassword ? Color.orange.opacity(0.3) : Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .offset(x: shakePassword ? 8 : 0)
                        .focused($focusedField, equals: .password)
                        .animation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true), value: shakePassword)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showErrorPassword ? Color.red : Color.clear, lineWidth: 2)
                        )
                    
                    //  Login Button
                    Button(action: {
                        validate()
                    }) {
                        ZStack {
                            
                            // Background changes on success
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isSuccess ? Color.green : Color.blue.opacity(0.8))
                            
                            // Content
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else if isSuccess {
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
                        .scaleEffect(isSuccess ? 1.05 : 1.0)
                        .animation(.spring(), value: isSuccess)
                    }
                    .disabled(isLoading)
                    
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
    //  Regex for email
       func isValidEmail(_ email: String) -> Bool {
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
           return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
       }
    //  Validation Logic
    func validate() {
        
        var hasError = false
        
        // Email empty check
        if email.isEmpty {
            showErrorEmail = true
            showErrorEmailValidity = false
            triggerShakeEmail()
            focusedField = .email
            hasError = true
            
        // Email invalid check
        } else if !isValidEmail(email) {
            showErrorEmail = false
            showErrorEmailValidity = true
            triggerShakeEmail()
            focusedField = .email
            hasError = true
            
        } else {
            showErrorEmail = false
            showErrorEmailValidity = false
        }
        
        // Password
        if password.isEmpty {
            showErrorPassword = true
            triggerShakePassword()
            if !hasError {
                focusedField = .password
            }
            hasError = true
        } else {
            showErrorPassword = false
        }
        
        // ✅ Success Flow
        if !hasError {
            loginSuccessAnimation()
        }
    }
    
    // 🔁 Shake Email
    func triggerShakeEmail() {
        shakeEmail = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            shakeEmail = false
        }
    }
    
    // 🔁 Shake Password
    func triggerShakePassword() {
        shakePassword = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            shakePassword = false
        }
    }
    
    //  Success Animation
    func loginSuccessAnimation() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            
            withAnimation {
                isSuccess = true
            }
        }
    }
}

#Preview {
    LoginUIView()
}
