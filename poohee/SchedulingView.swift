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
    @State var canceled = false
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
                    } else if canceled {
                        HStack{

                            HStack{
                                Text("Unfortunately \(vm.profile?.first_name ?? "") has canceled the meet up. Sorry for the inconvenicence!")
                                    .foregroundColor(Color.white)
                            }
                            .padding()
                            .background(Color.secondaryColor)
                            .cornerRadius(10)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }
                .background(Color.white)
                .onTapGesture {
                    cancelMatching = false
                }
                .overlay(
                    CancelMatchingButton(show: $cancelMatching, canceling: $canceling)
                )
            
                HStack{
                    Spacer()
                    
                    
                    Button{
                        if vm.messages.count == 1 && !canceled {
                            cancelMatching.toggle()
                        }
                        
                    } label: {
                        Image("EggYellow")
                    }
                    .padding(.trailing)
                    
                    if vm.messages.count > 1 || canceled {
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
                CancelView(show: $canceling, canceled: $canceled, vm: vm)
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
    
    var body: some View {
        if show {
            
            VStack{
                Spacer()
                HStack{
                    Button{
                        canceling.toggle()
                        
                    } label: {
                        Text("Cancel This Meetup")
                        .foregroundColor(Color.white)
                        .font(.system(size: 16))
                        .padding()
                        .frame(width: 250, height: 40)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
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

