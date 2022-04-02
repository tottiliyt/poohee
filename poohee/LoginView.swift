//
//  LoginView.swift
//  poohee
//
//  Created by Will Zhao on 4/1/22.
//
import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var isLogin = false
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var status = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                VStack (spacing: 15){
                    Button{
                    } label: {
                        Image(systemName: "plus.circle").font(.system(size: 64))
                            .padding()
                    }
                    
                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)

                    }
                    .padding(14)
                    .background(.white)
                    
                    
                    Button{
                        login()
                    } label: {
                        HStack{
                            Spacer()
                            Text("Login")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                        
                    }
                    
                    Text(self.status)
                        .foregroundColor(Color.red)
                    
                    
                    HStack(spacing: 0){
                        Text("If don't you have an account, ")
                        Text("create one here").foregroundColor(.blue)
                    }
                    
                    
                    
                }.padding()
                


            }
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            .navigationTitle("Login")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func login() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, error in
            if let error = error {
                status = "failed to login: \(error)"
                return
            }
            
            status = "success"
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
