//
//  ContentView.swift
//  poohee
//
//  Created by Yuntao Li on 3/27/22.
//

import SwiftUI
import Firebase


struct CreateAccountView: View {
    
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
                        createAccount()
                    } label: {
                        HStack{
                            Spacer()
                            Text("Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                        
                    }
                    
                    Text(self.status)
                        .foregroundColor(Color.red)
                    
                    
                    HStack(spacing: 0){
                        Text("If already you have an account, ")
                        Text("sign in here").foregroundColor(.blue)
                    }
                    
                    
                    
                }.padding()
                


            }
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            .navigationTitle("Create Account")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func createAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                status = "failed to create user: \(error)"
                return
            }
            
            status = "success"
            
            
        }
        
        self.storeUserInfo()
        
    }
    
    private func storeUserInfo(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        print(uid)
        
        let userData = ["uid": uid, "email": self.email, "profileImageUrl": ""]
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
            if let err = err {
                self.status = "\(err)"
                return
            }
        }
        
        status = "info stored"
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
