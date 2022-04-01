//
//  ContentView.swift
//  poohee
//
//  Created by Yuntao Li on 3/27/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLogin = false
    @State var email = ""
    @State var username = ""
    @State var password = ""
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                
                VStack{
                    Button{
                        
                    } label: {
                        Image(systemName: "plus.circle").font(.system(size: 64))
                            .padding()
                    }
                    
                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        TextField("Username", text: $username )
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)

                    }
                    .padding(12)
                    .background(.white)

                    Button{
                        
                    } label: {
                        HStack{
                            Spacer()
                            Text("Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                        
                    }
                    
                    
                    HStack(spacing: 0){
                        Text("If you have an account, ")
                        Text("sign in here").foregroundColor(.blue)
                    }
                    
                    
                    
                }.padding()
                


            }
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            .navigationTitle("Create Account")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
