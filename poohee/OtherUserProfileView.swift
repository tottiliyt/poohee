//
//  OtherUserProfileView.swift
//  poohee
//
//  Created by Yuntao Li on 4/22/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct OtherUserProfileView: View {
    
    @ObservedObject var vm : ChatViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            ScrollView {

                VStack{
                    WebImage(url: URL(string: vm.recipientProfile?.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(200)
                        .overlay(RoundedRectangle(cornerRadius: 200)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.secondaryColor)
                        )
                        .padding(.bottom, 20)
                    

                    Text(vm.recipientProfile?.first_name ?? "")
                        .font(.system(size: 36))
                        .foregroundColor(Color.secondaryColor)
                        
                    
                    
                    HStack{
                        
                        Button {
                            
                        } label: {
                            HStack{
                                    Spacer()
                                Text(vm.recipientProfile?.class_standing ?? "")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                    Spacer()

                                
                            }
                                .background(Color.secondaryColor)
                                .cornerRadius(24)
                        }.padding(.horizontal, 80)
                    }

                    HStack {
                        Button {
                        }label: {
                            HStack{
                                Text(String(vm.recipientNumMeet ?? 0))
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                        .padding(6)
                                        .padding(.horizontal, 4)
                                    
                                
                            }
                                .background(Color.secondaryColor)
                                .cornerRadius(10)
                                
                                
                        }
                        
                        
                        Text("Meetups already ")
                            .font(.system(size: 24))
                            .foregroundColor(Color.secondaryColor)
                            
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                    
                    Group {
                        
                        if(vm.recipientProfile?.bio != ""){
                            Text("About")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(Color.primaryColor)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                            HStack{
                                

                                    Spacer()
                                    Text(vm.recipientProfile?.bio ?? "")
                                        .font(.system(size: 16))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        
                                        .padding()
                                        .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.primaryColor, lineWidth: 2)
                                        )
                                    Spacer()

                                
                            }
                        }

                        Text("\(vm.recipientProfile?.first_name ?? "") want to")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundColor(Color.primaryColor)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)

                        
                        if (vm.recipientProfile?.goal == "friend") {
                            Button {

                            }label: {
                                HStack{

                                        Spacer()
                                        Text("Make New Friends!")
                                        .foregroundColor(.white)
                                            .font(.system(size: 25))
                                        Spacer()

                                }.padding(.vertical, 25)
                                    .background(Color.primaryColor)
                                    .cornerRadius(15)
                            }
                        }
                        
                        if (vm.recipientProfile?.goal == "career") {
                            Button {

                            }label: {
                                HStack{

                                        Spacer()
                                    Text("Expand Their Network!")
                                        .foregroundColor(.white)
                                            .font(.system(size: 25))
                                        Spacer()

                                }.padding(.vertical, 25)
                                    .background(Color.secondaryColor)
                                    .cornerRadius(15)
                            }
                        }
    //                    HStack {
    //                        Text("Goal")
    //                            .font(.system(size: 24))
    //                            .foregroundColor(Color.primaryColor)
    //
    //                        Text("(Click to change)")
    //                            .font(.system(size: 12))
    //                            .foregroundColor(Color.gray)
    //
    //                    }                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    //
    //                    HStack {
    //                        Button {
    //                            if (vm.recipientProfile?.goal == "career") {
    //                                updateGoal()
    //                            }
    //
    //                        }label: {
    //                            HStack{
    //
    //
    //                                    Spacer()
    //                                    Text("Make New Friends!")
    //                                        .foregroundColor(vm.profile?.goal == "friend" ? .white : .gray)
    //                                        .font(.system(size: 15))
    //                                    Spacer()
    //
    //
    //                            }.padding(.vertical, 25)
    //                                .background(vm.profile?.goal == "friend" ? Color.primaryColor : Color.buttonGray)
    //                                .cornerRadius(15)
    //                        }
    //
    //                        Spacer()
    //                        Spacer()
    //
    //                        Button {
    //                            if (vm.profile?.goal == "friend") {
    //                                updateGoal()
    //                            }
    //                        }label: {
    //                            HStack{
    //
    //                                    Spacer()
    //                                    Text("Meet Like-minded People (Career/Academic)")
    //                                    .foregroundColor(vm.profile?.goal == "career" ? .white : .gray)
    //                                        .font(.system(size: 10))
    //                                    Spacer()
    //
    //                            }.padding(.vertical, 20)
    //                                .background(vm.profile?.goal == "career" ? Color.secondaryColor : Color.buttonGray)
    //                                .cornerRadius(15)
    //
    //                        }
    //
    //
    //
    //                    }
                        
                    
                        

                    }
                    
                    
                    

                }
                .padding([.horizontal,.top], 30)
                        


            }
            
            VStack{
                HStack{
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    }label:{
                        Text("<<")
                            .font(.system(size: 25, weight:.semibold))
                            .foregroundColor(Color.gray)
                            .padding()
                            .padding(.top, 5)
                    }
                    Spacer()
                    
                }
                
                Spacer()
            }
            
            
        }
        
        .navigationBarHidden(true)
        
        
        
        
    }
    
    
    
    
}

struct OtherUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
