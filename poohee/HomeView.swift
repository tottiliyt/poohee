//
//  HomeView.swift
//  poohee
//
//  Created by Will Zhao on 4/7/22.
//

import SwiftUI



struct HomeView: View {
    
    @ObservedObject var vm = ViewModel()
    @State var isMessageMode = true
    @State var isPopUp = false
    
    
    var body: some View {
        VStack(spacing:0){
            ZStack{
                if isMessageMode {
                    MessageView(isPopUp: $isPopUp, vm : vm)
                } else {
                    ProfileView()
                }
            }
            
            HStack(){
                Button(action: {
                    isMessageMode = true
                }, label: {
                    HStack(spacing:0){
                        Spacer()
                        if isMessageMode{
                            Image("MessageWhite")
                                .resizable()
                                .frame(width:47, height:47)
                        } else {
                            Image("MessageGrey")
                                .resizable()
                                .frame(width:47, height:47)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 21)
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
        .ignoresSafeArea(.all, edges: .bottom)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
