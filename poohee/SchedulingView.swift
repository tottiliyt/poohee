//
//  MatchView.swift
//  poohee
//
//  Created by Will Zhao on 4/10/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct SchedulingView: View {
    
    @State var message = ""
    @ObservedObject var vm : ChatViewModel
    @State var cancelMatching = false
    @State var scheduling = false
    @State var canceling = false
    @Binding var scheduled: Bool
    @State var reporting = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    
                    NavigationLink{
                        OtherUserProfileView(vm: vm)
                    } label: {
                        
                        
                            HStack{
                                
                                
                                Spacer()
                                
                                WebImage(url: URL(string: vm.recipientProfile?.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(60)
                                    .overlay(RoundedRectangle(cornerRadius: 60)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(Color.primaryColor)
                                    )
                                    
                                
                                HStack{
                                    Text("\(vm.chat.firstName)")
                                        .font(.system(size:25))
                                        .foregroundColor(Color.black)
                                    Text(">")
                                        .font(.system(size:25))
                                        .foregroundColor(Color.gray)
                                }
                                
                                Spacer()
                                
                            }

                    }
                    
                    HStack{
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        }label:{
                            Text("<<")
                                .font(.system(size: 25, weight:.semibold))
                                .foregroundColor(Color.gray)
                                .padding()
                        }
                        Spacer()
                    }
                    
                    
                    
                }
                .padding(.top, 50)
                
                ScrollView(showsIndicators: false) {
                    YolkBotMessages(similarities: vm.similarities, firstName: vm.chat.firstName)
                    
                    if vm.messages.count > 1{
                        SingleMessageView(message: vm.messages[1], recipientId: vm.recipientId)
                    }
                }
                .background(Color.white)
                .onTapGesture {
                    cancelMatching = false
                }
                .overlay(
                    CancelMatchingButton(show: $cancelMatching, canceling: $canceling, reporting:$reporting, blocking_mode: false)
                )
            
                HStack{
                    Spacer()
                    
                    
                    Button{
                        
                        if vm.messages.count == 1{
                            cancelMatching.toggle()
                        }
                        
                    } label: {
                        Image("EggYellow")
                    }
                    .padding(.trailing)
                    
                    if vm.messages.count > 1 {
                        Button{
                            
                        }label: {
                            HStack{
                                Spacer()
                                Text("Canceled")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 35, weight: .bold))
                                    
                                 Spacer()
                            }
                            .padding(.vertical, 5)
                            .background(Color.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                       
                        
                        
                    } else {
                        Button{
                            scheduling.toggle()
                        } label: {
                            HStack{
                                Spacer()
                                Text("Schedule")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 35, weight: .bold))
                                    
                                 Spacer()
                            }
                            .padding(.vertical, 5)
                            .background(Color.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                }
                .padding(.top, 5)
                .padding(.bottom, 25)
                
            }
            .background(Color.chatGray)
                .ignoresSafeArea(.container)
            
            if scheduling{
                SchedulingPopUp(show: $scheduling, vm: vm)
            }
            
            if canceling{
                CancelView(show: $canceling, vm: vm, blocking_mode: false)
            }
            
            if reporting{
                ReportView(show: $reporting, vm:vm)
            }
            
        }
    }
    
}


struct YolkBotMessages: View {
    let similarities : String
    let firstName: String
    
    var body: some View {
        VStack (spacing: 7){
            HStack{
                Image("logo")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(4)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color.secondaryColor)
                    )
                    .padding(.leading)
                
                Text ("YolkBot")
                    .foregroundColor(Color.secondaryColor)
                Spacer()
            }
            
            HStack{
                Text("We have found your new friend - \(self.firstName)! You can check out their profile above")
                    .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color.white)
                .padding()
                .background(Color.secondaryColor)
                .cornerRadius(10)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.bottom, 9)
            
            HStack{
                Text("😎 You two are both interested in\n\(similarities)")
                    .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color.white)
                .padding()
                .background(Color.secondaryColor)
                .cornerRadius(10)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.bottom, 9)
            
            HStack{
                Text("Let's schedule a time to meet by clicking on the button below")
                    .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color.white)
                .padding()
                .background(Color.secondaryColor)
                .cornerRadius(10)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.bottom, 9)
        }
        .padding(.top)
    }
}


struct CancelMatchingButton: View {
    @Binding var show : Bool
    @Binding var canceling: Bool
    @Binding var reporting:Bool
    @State var blocking_mode:Bool
    
    var body: some View {
        if show {
            
            VStack{
                Spacer()
                HStack{
                    VStack{
                        Button{
                            canceling.toggle()
                            
                        } label: {
                            Text(blocking_mode ? "Block User" :"Cancel Meetup" )
                            .foregroundColor(Color.white)
                            .font(.system(size: 16))
                            .padding()
                            .frame(width: 150, height: 35)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button{
                            reporting.toggle()
                            
                        } label: {
                            Text("Report User")
                            .foregroundColor(Color.white)
                            .font(.system(size: 16))
                            .padding()
                            .frame(width: 150, height: 35)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                    .padding()
                        .background(Color.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                    .padding()
                    
                    
                    Spacer()
                }
            }
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

