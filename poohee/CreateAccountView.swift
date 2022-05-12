//
//  ContentView.swift
//  poohee
//
//  Created by Yuntao Li on 3/27/22.
//

import SwiftUI
import Firebase
import FirebaseFunctions


struct CreateAccountView: View {
    let didCompleteLoginProcess: () -> ()
    
    @State var isLogin = false
    @State var email = ""
    @State var password = ""
    @State var msg = ""
    @State var inVerifyView = false
    @State var verificationStage = 0
    @State var verificationCode = ""
    @State var code = ""
    
    var body: some View {
        ScrollView {
            if (inVerifyView) {
                
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 250, height: 250, alignment: .center)
                        .padding(.vertical, 40)
                    
                    Text(verificationStage == 0 ? "Please check your inbox/spam" : verificationStage == 1 ? "Verification failed, incorrect verification code" : "We re-sent a link to your JHU email")
                        .foregroundColor(Color.primaryColor)
                        .font(.system(size: 26))
                    
                    TextField("Verification Code", text: $code)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke( Color.primaryColor))
                        .disableAutocorrection(true)
                        .padding(.vertical, 12)
                    
                    Text(msg)
                        .foregroundColor(Color.primaryColor)
                        .font(.system(size: 16))
                    
                    Button {
                        verify()
                    }label: {
                        HStack{
                        
                                Spacer()
                                Text("Submit code")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                                Spacer()

                        }.padding(.vertical, 12)
                            .background(Color.primaryColor)
                            .cornerRadius(24)
                    }
                    
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
                    }
                    .padding(.vertical)
                    .padding(.bottom, 50)
                    

                    

                }
                .padding(.horizontal, 50)
                .background(Color.white)
                .onTapGesture {
                    hideKeyboard()
                }
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
                        
                        
                        
                        ZStack{
                            Text("\n")
                                .foregroundColor(Color.white)
                            
                            Text(msg)
                                .foregroundColor(Color.primaryColor)
                            
                            
                        }
                        .padding(.bottom)
                        
                        Text("By clicking Send verification email, you agree to Yolk's [User Agreement](https://app.termly.io/document/eula/44f41692-0575-4c91-8b51-9af7afd751d3) and [Privacy Policy](https://app.termly.io/document/privacy-policy/9682ee46-348f-4fb4-9b2d-d10ee163b416)").font(.system(size: 12))
                        
                        
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
                        }
                        
                        

                        
                        
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)
                    .background(Color.white)
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
        }
                

            
                
    }
    
    func makeCode(email:String) -> String {
        String(String(email.hashValue).suffix(6))
    }
    
    private func createAccount() {
        
        if (email == "") {
            msg = "Email can't be empty"
            return
        }
        
        if (password.count < 6) {
            msg = "Password needs to be at least 6 characters in length"
            return
        }
        
        
        verificationCode = makeCode(email: email)
        sendVerificationEmail()
        inVerifyView.toggle()
        

        
        
        
        
    }
    
    private func verify() {
        
        let verified = (makeCode(email: email) == code)
        
        if (verified == false) {
            verificationStage = 1
        } else {
            FirebaseManager.shared.auth.createUser(withEmail: email + "@jh.edu", password: password) {
                result, error in
                if let error = error {
                    msg = error.localizedDescription
                    print("failed to create user: \(error)")
                    return
                }
                print("account create")
                FirebaseManager.shared.auth.currentUser?.reload() {
                    error in
                    if let error = error {
                        print("reload failed" + error.localizedDescription)
                        return
                    }
                    inVerifyView.toggle()
                    storeUserInfo()
                    didCompleteLoginProcess()

                }
                
            }
        }
        

        
    }
    
    private func resendVerificationEmail() {

            
    Functions.functions().httpsCallable("sendVerificationEmail").call(["code": verificationCode, "email": email + "@jh.edu"]) { result, error in
        if let error = error as NSError? {
            print(error)
        }
        print("email sent success")
        verificationStage = 2
      }
          
    }
    
    private func sendVerificationEmail() {


    Functions.functions().httpsCallable("sendVerificationEmail").call(["code": verificationCode, "email": email+"@jh.edu"]) { result, error in
        if let error = error as NSError? {
            print(error)
        }
        print("email sent success")
      }
        
    }
    
    private func storeUserInfo(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        
        let userData = ["email": email + "@jh.edu", "profile": [:], "matching": "On", "profileImageUrl": "", "num_meet": 0, "fcmToken": fcmToken, "verificationCode": self.verificationCode] as [String : Any]
        
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


