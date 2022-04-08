//
//  HomeView.swift
//  poohee
//
//  Created by Will Zhao on 4/7/22.
//

import SwiftUI

struct HomeView: View {
    @State var isMessageMode = true
    var body: some View {
        VStack(){
            ZStack{
                if isMessageMode {
                    MessageView()
                } else {
                    ProfileView()
                }
            }
            
            Spacer()
            
            HStack(spacing: 0){
                Button(action: {
                    isMessageMode = true
                }, label: {
                    HStack(spacing:0){
                        Spacer()
                        if isMessageMode{
                            Image("MessageWhite")
                                .font(.system(size: 110))
                        } else {
                            Image("MessageGrey")
                                .font(.system(size: 110))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 24)
                        .background(isMessageMode ? Color.primaryColor: Color.white)
                        .cornerRadius(20)
                })
                
                Button(action: {
                    isMessageMode = false
                }, label: {
                    HStack(spacing:0){
                        Spacer()
                        if isMessageMode{
                            Image("ProfileGrey")
                                .font(.system(size: 100))
                        } else {
                            Image("ProfileWhite")
                                .font(.system(size: 100))
                        }
                            
                        Spacer()
                    }
                    .padding(.vertical, 20)
                        .background(isMessageMode ? Color.white: Color.secondaryColor)
                        .cornerRadius(20)
                    
                })
               
            }
            
        }
        .ignoresSafeArea()
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
