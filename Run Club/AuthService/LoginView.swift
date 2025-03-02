//
//  LoginView.swift
//  Run Club
//
//  Created by Karen Tran on 2025-02-26.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            
            Button {
                Task {
                    do {
                        try await AuthService.shared.magicLinkLogin(email: email)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Login")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .background(Color.yellow)
                    .clipShape(Capsule())
            }
            .disabled(email.count < 7)
        }
        .padding()
        .onOpenURL(perform: { url in
            Task {
                do {
                    try await             AuthService.shared.handleOpenuRL(url: url)

                } catch {
                    print(error.localizedDescription)
                }
            }
        })
    }
}

#Preview {
    LoginView()
}
