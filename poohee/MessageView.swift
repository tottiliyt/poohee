//
//  MyChatView.swift
//  poohee
//
//  Created by Will Zhao on 4/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    
    @State var selectedUser : Profile?
    @Binding var isPopUp : Bool
    @ObservedObject var vm : HomeViewModel
    
    
    var body: some View {
            ZStack{
                VStack(spacing:0){
                        topBar
                        .padding(.horizontal)
                        messageQueue
                }
                
                if isPopUp{
                    HomePopUp(show: $isPopUp, vm: vm)
                }
            }
    }
    
    private var topBar: some View {
        VStack{
            ZStack{
                /*RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.primaryColor)
                                .frame(width: 380, height: 250, alignment: .center)*/
                
                HStack{
                    Spacer()
                    if !(vm.user?.new_match ?? false){
                        if self.vm.user?.matching == "On"{
                            Text("Hey \(vm.profile?.first_name ?? ""), we are working hard to find your next friend!")
                                    .font(.system(size: 30, weight: .bold))
                                    .padding()
                        } else {
                            VStack (alignment: .center){
                                Text("Your matching is currently paused")
                                    .font(.system(size: 30, weight: .bold))
                                Button(action: {
                                    vm.updateMatching()
                                }, label: {
                                    Text("Resume")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 30, weight: .bold))
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                })
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        }
                    } else {
                        VStack (alignment: .center){
                            Text("\(vm.profile?.first_name ?? ""), you have a new match!")
                                .font(.system(size: 30, weight: .bold))
                            
                            Button(action: {
                                withAnimation{
                                    isPopUp.toggle()
                                }
                            }, label: {
                                
                                Text("Check")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 30, weight: .bold))
                                    .padding()
                                    .frame(width: 175, height: 60)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            })
                            
                        }
                        .padding(.vertical)
                    }
                        
                    Spacer()
                }
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(20)
                
                
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
                if vm.chats.count == 0{
                    Text("You don't have any matches yet")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray)
                        .padding(.vertical)
                }
                
                ForEach(vm.chats) {chat in
                    
                    NavigationLink (destination: {
                        ChatView(chat: chat)
                    }, label: {
                        HStack(spacing: 16){
                            WebImage(url: URL(string: chat.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                                .clipped()
                                .cornerRadius(60)
                                .overlay(RoundedRectangle(cornerRadius: 60)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.chatPink)
                                )
                            
                            VStack (alignment: .leading){
                                Text("\(chat.firstName)")
                                    .font(.system(size: 20, weight: chat.stage == 0 ? .bold: .semibold))
                                    .foregroundColor(Color.black)
                                Spacer()
                                
                                if chat.stage == 0 {
                                    Text("^^^  You have a new match!")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(1)
                                        .foregroundColor(Color.black).font(.system(size:14, weight: .semibold))
                                        
                                } else if chat.stage == -1 {
                                    Text("Meet up cancled")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(1)
                                        .foregroundColor(Color(.lightGray)).font(.system(size:14))
                                        
                                }else {
                                    Text("\(chat.text)")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(1)
                                        .foregroundColor(Color(.lightGray)).font(.system(size:14))
                                }
                                
                            }
                            
                            Spacer()
                            
                            VStack{
                                Text("\(chat.timeAgo)")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                Spacer()
                            }
                            
                            
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

