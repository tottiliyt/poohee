//
//  PostMatchView.swift
//  poohee
//
//  Created by Will Zhao on 4/11/22.
//

import SwiftUI

struct PostSchedulingView: View {
    @State var message = ""
    @ObservedObject var vm : ChatViewModel
    
    var body: some View {
        VStack{
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(vm.messages) { message in
                            if message.stage == 0{
                                ChatbotMessages(message: message, firstName: vm.chat.firstName)
                            } else {
                                SingleMessageView(message: message, recipientId: vm.recipientId)
                            }
                            
                        }

                        HStack{ Spacer() }
                        .id("Empty")
                    }
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                            print(vm.count)
                        }
                    }
                }
            }
            .background(Color.white)

            HStack{
                TextEditor(text: $message)
                    .padding(3.5)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.primaryColor, style: StrokeStyle(lineWidth: 2.0)))
                    .frame(width: UIScreen.main.bounds.width*0.7, height: UIScreen.main.bounds.height*0.05, alignment: .leading)
                    .padding(.horizontal)
                
                
                Button{
                    vm.send(text: self.message, stage: 2)
                    self.message = ""
                } label: {
                    Text("Send")
                        .foregroundColor(Color.primaryColor)
                        .font(.system(size:20))
                }
                
            }
            .padding(.vertical, 6)
            .padding(.horizontal)
            .background(Color.chatGray)
                .ignoresSafeArea()
        }
    }
}




struct SingleMessageView : View{
    let message : ChatMessage
    let recipientId : String
    
    var body: some View {
        if message.stage == 1{
            HStack{

                HStack{
                    Text("\(message.text)")
                        .foregroundColor(Color.white)
                }
                .padding()
                .background(Color.secondaryColor)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        } else if message.toId == self.recipientId{
            HStack{
                Spacer()
                
                HStack{
                    Text("\(message.text)")
                        .foregroundColor(Color.white)
                }
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(10)
                
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
        }else {
            HStack{

                HStack{
                    Text("\(message.text)")
                        
                }
                .padding()
                .background(Color.chatGray)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
        }
    }
}

struct PostMatchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

