//
//  LoginView.swift
//  poohee
//
//  Created by Will Zhao on 4/1/22.
//
import SwiftUI
import Firebase

struct LoginView: View {
    let didCompleteLoginProcess: () -> ()
    
    @State var isLogin = false
    @State var email = ""
    @State var password = ""
    @State var msg = ""
    @State var inVerifyView = false
    @State var verification_fail = false
    
//    init() {
//        //Use this if NavigationBarTitle is with Large Font
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: Color.primaryColor]
//
//    }
    
    var body: some View {
            
        if (inVerifyView) {
            
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 250, height: 250, alignment: .center)
                    .padding(.vertical, 40)
                
                Text(verification_fail ? "Verification failed" : "Please check your email inbox/spam")
                    .foregroundColor(Color.primaryColor)
                    .font(.system(size: 36))
                
                
                
                
                
                Button {
                    verify()
                }label: {
                    HStack{
                    
                            Spacer()
                            Text(verification_fail ? "Resend link" : "I have verified my JHU email")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Spacer()

                    }.padding(.vertical, 12)
                        .background(Color.primaryColor)
                        .cornerRadius(24)
                }.padding(.top, 150)
            }
            .padding(.horizontal, 50)
        }
        else {
            VStack (){
                
                
                
                Image("logo")
                    .resizable()
                    .frame(width: 250, height: 250, alignment: .center)
                    .padding(.bottom, 20)
                
                Text("Log in to your account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                    .padding(.bottom, 30)
                    .disableAutocorrection(true)



                TextField("JHU Email", text: $email)
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
                    login()
                }label: {
                    HStack{
                        

                            Spacer()
                            Text("Continue")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Spacer()

                        
                    }.padding(.vertical, 12)
                        .background(Color.primaryColor)
                        .cornerRadius(24)
                }.padding(.top, 200)
                
            }.padding(.horizontal, 50)
        }
                
                
    }
    private func verify() {
        
        if (verification_fail) {
            verification_fail = false
        }
        
        print(FirebaseManager.shared.auth.currentUser?.isEmailVerified ?? "haha")
        
        if ((FirebaseManager.shared.auth.currentUser?.isEmailVerified) != true) {
            verification_fail = true
            sendVerificationEmail()
        } else {
            inVerifyView.toggle()
            didCompleteLoginProcess()
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
    
    private func login() {
        
        if (email == "") {
            msg = "Email can't be empty"
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
        
//        FirebaseManager.shared.auth.createUser(withEmail: "yuntao-li@outlook.com", password: "123qweASD") {
//            result, error in
//            if let error = error {
//                print("failed to create user: \(error)")
//            }
//            print("account created")
//        }
        
        
        
//        let actionCodeSettings = ActionCodeSettings()
//        // The sign-in operation has to always be completed in the app.
//        actionCodeSettings.handleCodeInApp = true
//
//        actionCodeSettings.url =
//        URL(string: "https://yolkapps.com/email_auth")
//
//        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
//
//        FirebaseManager.shared.auth.sendSignInLink(toEmail: "yli346@jhu.edu",
//                                   actionCodeSettings: actionCodeSettings) { error in
//            if let error = error {
//                print(error.localizedDescription)
//              return
//            }
//            // The link was successfully sent. Inform the user.
//            // Save the email locally so you don't need to ask the user for it again
//            // if they open the link on the same device.
//            UserDefaults.standard.set("yli346@jhu.edu", forKey: "Email")
//            print("Check your email for link")
//        }
        
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, error in
            if let error = error {
                
                if (error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted.") {
                    msg = "No account is associated with this email address"
                }
                else {
                    msg = "Email or password is incorrect"
                }
                
                print(error)
                return
            }

            print("login success")
            
            FirebaseManager.shared.auth.currentUser?.reload() {
                error in
                if let error = error {
                    print("reload failed" + error.localizedDescription)
                    return
                }
                if (FirebaseManager.shared.auth.currentUser?.isEmailVerified != true) {
                    inVerifyView = true
                }
                else {
                    didCompleteLoginProcess()
                }
            }
            

            
        }
//
//        var verified =
//
//        if FirebaseManager.shared.auth.currentUser != nil {
//
//            var verified =FirebaseManager.shared.auth.currentUser.
//
//            FirebaseManager.shared.auth.currentUser?.sendEmailVerification { error in
//                if let error = error {
//                    print("email sent fail")
//                    return
//                }
//                print("email sent success")
//              // ...
//            }
//        } else {
//            print("current user is null")
//            return
//        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: {
            
        })
    }
}
