//
//  ContentView.swift
//  poohee
//
//  Created by Yuntao Li on 3/27/22.
//

import SwiftUI
import Firebase


struct CreateAccountView: View {
    let didCompleteLoginProcess: () -> ()
    
    @State var isLogin = false
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var msg = ""
    @State var inVerifyView = false
    @State var verificationStage = 0
    
    var body: some View {
                
        if (inVerifyView) {
            
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 250, height: 250, alignment: .center)
                    .padding(.vertical, 40)
                
                Text(verificationStage == 0 ? "Please check your inbox/spam" : verificationStage == 1 ? "Verification failed" : "We re-sent a link to your JHU email")
                    .foregroundColor(Color.primaryColor)
                    .font(.system(size: 36))
                
                
                Button {
                    resendVerificationEmail()
                }label: {
                    HStack{
                    
                            Spacer()
                            Text("Re-send link")
                                .foregroundColor(.black)
                                .font(.system(size: 24))
                            Spacer()

                    }.padding(.vertical, 12)
                        
                        .background(Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }.padding(.top, 150)
                
                
                Button {
                    verify()
                }label: {
                    HStack{
                    
                            Spacer()
                            Text("I have verified my JHU email")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Spacer()

                    }.padding(.vertical, 12)
                        .background(Color.primaryColor)
                        .cornerRadius(24)
                }
            }
            .padding(.horizontal, 50)
        }
        else {
            
                VStack (){
                    
                    
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 250, height: 250, alignment: .center)
                        .padding(.bottom, 20)
                    
                    Text("Create your account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryColor)
                        .padding(.bottom, 30)



                    TextField("JHU Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke( Color.primaryColor))
                        .disableAutocorrection(true)

                    TextField("Username", text: $username)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke( Color.primaryColor))
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke( Color.primaryColor))
                        .disableAutocorrection(true)
                    
                    Text(msg)
                        .foregroundColor(Color.primaryColor)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                    Button {
                        createAccount()
                    }label: {
                        HStack{
                            

                                Spacer()
                                Text("Send verification email")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                                Spacer()

                            
                        }.padding(.vertical, 12)
                            .background(Color.primaryColor)
                            .cornerRadius(24)
                    }.padding(.top, 130)
                    
                    

                    
                    
                }.padding(.horizontal, 50)
        }
            
                
    }
    
    private func createAccount() {
        
        if (email == "") {
            msg = "Email can't be empty"
            return
        }
        
        if (username == "") {
            msg = "Username can't be empty"
            return
        }
        
        if (password == "") {
            msg = "Password can't be empty"
            return
        }
        
        if (!email.hasSuffix("@jh.edu")) {
            msg = "Email must end with @jh.edu"
            return
        }
        
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                msg = error.localizedDescription
                print("failed to create user: \(error)")
                return
            }
            print("account create")
            storeUserInfo()
            sendVerificationEmail()
            inVerifyView.toggle()
        }
        
        
        
        
    }
    
    private func verify() {
        
        FirebaseManager.shared.auth.currentUser?.reload() {
            error in
            if let error = error {
                print("reload failed" + error.localizedDescription)
                return
            }
            guard let verified = FirebaseManager.shared.auth.currentUser?.isEmailVerified else {
                print("can't verify")
                verificationStage = 1
                return
            }
            
            print(verified)
            
            if (verified == false) {
                verificationStage = 1
            } else {
                inVerifyView.toggle()
                didCompleteLoginProcess()
            }
        }
    }
    
    private func resendVerificationEmail() {
        if FirebaseManager.shared.auth.currentUser != nil {

            FirebaseManager.shared.auth.currentUser?.sendEmailVerification { error in
                if let error = error {
                    print("email sent fail" + error.localizedDescription)
                    return
                }
                print("email sent success")
                verificationStage = 2
                
              // ...
            }
        } else {
            print("current user is null")
            return
        }
    }
    
    private func sendVerificationEmail() {
        if FirebaseManager.shared.auth.currentUser != nil {

            FirebaseManager.shared.auth.currentUser?.sendEmailVerification { error in
                if let error = error {
                    print("email sent fail" + error.localizedDescription)
                    return
                }
                print("email sent success")
              // ...
            }
        } else {
            print("current user is null")
            return
        }
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
                print("info store error" + err.localizedDescription)
                return
            }
        }
        
        print("info stored")
    }
    
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(didCompleteLoginProcess: {
            
        })
    }
}
