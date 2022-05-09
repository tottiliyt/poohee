//
//  LoginView.swift
//  poohee
//
//  Created by Will Zhao on 4/1/22.
//
import SwiftUI
import Firebase
import FirebaseFunctions

struct LoginView: View {
    let didCompleteLoginProcess: () -> ()
    
    @State var isLogin = false
    @State var email = ""
    @State var password = ""
    @State var msg = ""
    @State var forget_email = ""
    @State var inVerifyView = false
    @State var verification_fail = false
    @State var inForgetPassword = false
    
    var body: some View {
        ScrollView {

                
                if (inForgetPassword) {
                    VStack{
                        Image("logo")
                            .resizable()
                            .frame(width: 250, height: 250, alignment: .center)
                            .padding(.bottom, 20)
                        
                        Text("Reset password")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                            .padding(.bottom, 30)
                            .disableAutocorrection(true)
                        
                        
                        HStack {
                            TextField("JHED", text: $forget_email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke( Color.primaryColor))
                                .disableAutocorrection(true)
                            
                            Text("@jh.edu")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 24))
                            
                                
                        }
                        
                        ZStack{
                            Text("\n")
                                .foregroundColor(Color.white)
                            
                            Text(msg)
                                .foregroundColor(Color.primaryColor)
                            
                            
                        }
                        .padding(.bottom)
                        
                        
                        Button {
                            sendResetPasswordLink()
                        }label: {
                            Text("Send reset password link")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .padding()
                                .background(Color.primaryColor)
                                .cornerRadius(15)
                        }
                        
                    }
                    .padding(.horizontal, 50)
                    .background(Color.white)
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                else {
                    VStack{
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 250, height: 250, alignment: .center)
                            .padding(.bottom, 20)
                        
                        Text("Sign in to your account")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                            .padding(.bottom)
                            .disableAutocorrection(true)


                        HStack {
                            TextField("JHED", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).stroke( Color.primaryColor))
                                .disableAutocorrection(true)
                            
                            Text("@jh.edu")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 24))
                            
                                
                        }
                        
                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke( Color.primaryColor))
                            .disableAutocorrection(true)
                        
                        
                        Button {
                            forget_password()
                        }label: {

                                Text("Forgot password?")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 14))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        
                        }

                        Text(msg)
                            .foregroundColor(Color.primaryColor)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom)
                        
                        Spacer()
                        
                        Button {
                            login()
                        }label: {
                            HStack{
                                    Spacer()
                                    Text("Sign In")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                    Spacer()

                                
                            }.padding(.vertical, 12)
                                .background(Color.primaryColor)
                                .cornerRadius(24)
                        }
                        
                    }
                    .padding(.horizontal, 50)
                    .background(Color.white)
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                
                
            
                    
        }
    }
    
    
    private func forget_password() {
        inForgetPassword = true
    }
    
    private func sendResetPasswordLink(){
        
        FirebaseManager.shared.auth.sendPasswordReset(withEmail: forget_email + "@jh.edu") { error in
            if let error = error {
                msg = "Failed to send reset password link, please try again"
            } else {
                inForgetPassword = false
                msg = "Reset password link has been sent successfully. It might take a few mintues to deliver"
            }
        }
        

    }
    
    
    private func login() {
        
        if (email == "") {
            msg = "Email can't be empty"
            return
        }
        
        if (password == "") {
            msg = "Password can't be empty"
            return
        }
        
        
        FirebaseManager.shared.auth.signIn(withEmail: email + "@jh.edu", password: password) {
            result, error in
            if let error = error {
                
                msg = "The email or password is incorrect"
                
                return
            }

            print("login success")
            
            FirebaseManager.shared.auth.currentUser?.reload() {
                error in
                if let error = error {
                    print("reload failed" + error.localizedDescription)
                    return
                }

                    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                        return
                    }
                    guard let fcmToken = Messaging.messaging().fcmToken else { return }
                    
                    let ref = FirebaseManager.shared.firestore.collection("users").document(uid)
                    
                    ref.updateData([
                        "fcmToken": fcmToken
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        }
                    }
                    didCompleteLoginProcess()
                
            }
            

            
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: {
            
        })
    }
}
