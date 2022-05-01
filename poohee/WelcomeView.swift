//
//  WelcomeView.swift
//  poohee
//
//  Created by Yuntao Li on 4/2/22.
//

import SwiftUI
import Firebase

struct WelcomeView: View {
    
    let didCompleteLoginProcess: () -> ()
    
    var body: some View {
        NavigationView{

                VStack(){
                    Text("Ready to break out of your shell?").font(.system(size: 45)).foregroundColor(Color.primaryColor)
                    Image("logo")
                        .resizable()
                        .frame(width: 180, height: 180, alignment: .center)
                        .padding(.vertical, 40)
                    
                    
                    Button {

                    }label: {
                        HStack{
                            
                            NavigationLink(destination: CreateAccountView(didCompleteLoginProcess: {
                                didCompleteLoginProcess()
                            })){
                                Spacer()
                                Text("Register with JHU email")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))

                                Spacer()
                            }
                            

                        }.padding(.vertical)
                            .background(Color.primaryColor)
                            .cornerRadius(20)
                    }
                    
                    Button {
                        
                    }label: {
                        HStack{
                            
                            NavigationLink(destination: LoginView(didCompleteLoginProcess: {
                                didCompleteLoginProcess()
                            })) {
                                Spacer()
                                Text("Sign In")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24))
                                Spacer()
                            }
                            
                        }.padding(.vertical)
                            .background(Color.buttonGray)
                            .cornerRadius(20)
                    }
                    
                    
                    
                }
                .navigationBarHidden(true)
                
                .padding(.horizontal, 50)
                            
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
    

}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(didCompleteLoginProcess: {
            
        })
    }
}

