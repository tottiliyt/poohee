//
//  MatchView.swift
//  poohee
//
//  Created by Will Zhao on 4/10/22.
//

import SwiftUI

struct SchedulingView: View {
    
    @State var message = ""
    @ObservedObject var vm : ChatViewModel
    @State var cancelMatching = false
    @State var scheduling = false
    @Binding var scheduled: Bool
    
    
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView {
                    ChatbotMessages(message: vm.messages[0], firstName: vm.chat.firstName)
                }
                .background(Color.white)
                .onTapGesture {
                    cancelMatching = false
                }
                .overlay(
                    CancelMatchingButton(show: $cancelMatching)
                )
            
                HStack{
                    Spacer()
                    
                    Button{
                        cancelMatching.toggle()
                    } label: {
                        Image("EggYellow")
                    }
                    .padding(.trailing)
                    
                    Button{
                        scheduling.toggle()
                    } label: {
                        Text("Schedule")
                        .foregroundColor(Color.white)
                        .font(.system(size: 35, weight: .bold))
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    Spacer()
                    
                }
                .padding(.top)
                .background(Color.chatGray)
                    .ignoresSafeArea()
            }
            
            if scheduling{
                SchedulingPopUp(show: $scheduling, vm: vm)
            }
            
        }
    }
    
}


struct ChatbotMessages: View {
    let message : ChatMessage
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
                
                Text ("Chatbot")
                    .foregroundColor(Color.secondaryColor)
                Spacer()
            }
            
            
            HStack{
                Text("We have found your new friend - \(self.firstName)!")
                .foregroundColor(Color.white)
                .padding()
                .background(Color.secondaryColor)
                .cornerRadius(10)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.bottom, 9)
            
            HStack{
                Text("😎 You guys are both \n\(self.message.text)")
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
    
    var body: some View {
        if show {
            
            VStack{
                Spacer()
                HStack{
                    Button{
                        
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

