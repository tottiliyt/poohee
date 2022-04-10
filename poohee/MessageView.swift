//
//  MyChatView.swift
//  poohee
//
//  Created by Will Zhao on 4/1/22.
//

import SwiftUI

struct MessageView: View {
    
    @State var selectedUser : Profile?
    @Binding var isPopUp : Bool
    @ObservedObject var vm : HomeViewModel
    @Binding var accepted: Bool
    
    
    var body: some View {
            ZStack{
                VStack(spacing:0){
                        topBar
                        messageQueue
                }
                
                if isPopUp{
                    PopUpView(show: $isPopUp, accepted: $accepted, vm: vm)
                }
            }
    }
    
    private var topBar: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.primaryColor)
                                .frame(width: 380, height: 250, alignment: .center)
                
                VStack (alignment: .center, spacing: 20){
                    Text("\(vm.profile?.first_name ?? ""), You have an upcoming match!")
                        .font(.system(size: 30, weight: .bold))
                    
                    Button(action: {
                        withAnimation{
                            isPopUp.toggle()
                        }
                    }, label: {
                        
                        Text("Check")
                            .foregroundColor(Color.black)
                            .font(.system(size: 25, weight: .bold))
                            .padding()
                    })
                    .frame(width: 175, height: 60)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding(.horizontal)
            
            HStack{
                Text("Conversations")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(Color.chatPink)
                    .padding(.init(top: 0, leading: 18, bottom: 5, trailing: 0))
                Spacer()
            }
            Divider()
                .background(Color.chatPink)
                
        }
        
        
        
    }
    
    private var messageQueue: some View {
        ScrollView{
            VStack{
                ForEach(vm.chats) {chat in
                    
                    NavigationLink (destination: {
                        ChatView(chat: chat)
                    }, label: {
                        HStack(spacing: 16){
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color.chatPink)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(Color.chatPink)
                                )
                            
                            VStack (alignment: .leading){
                                Text("\(chat.first_name)")
                                    .font(.system(size: 20, weight:
                                            .semibold))
                                    .foregroundColor(Color.black)
                                Spacer()
                                Text("\(chat.text)")
                                    .foregroundColor(Color(.lightGray)).font(.system(size:14))
                            }
                            
                            Spacer()
                            
                            Text("\(chat.timeAgo)")
                                .font(.system(size: 14, weight:
                                        .semibold))
                                .foregroundColor(Color.black)
                            
                        }
                    })
                     
                    
                    Divider()
                        .background(Color.chatPink)
                        .frame(height:12)
                }
                .padding(.horizontal)
                
                Image("logo")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .padding(.top, 15)
        }
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

