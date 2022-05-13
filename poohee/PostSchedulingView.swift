//
//  PostMatchView.swift
//  poohee
//
//  Created by Will Zhao on 4/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostSchedulingView: View {
    @State var message = ""
    @ObservedObject var vm : ChatViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var canceling = false
    @State var reporting = false
    @State var cancelMatching = false
    
    
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
                
                
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.messages) { message in
                                if message.stage == 0 {
                                    YolkBotMessages(similarities: vm.similarities, firstName: vm.chat.firstName)
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
                .onTapGesture{
                    hideKeyboard()
                    cancelMatching = false
                }
                .overlay(
                    CancelMatchingButton(show: $cancelMatching, canceling: $canceling, reporting:$reporting, blocking_mode: true)
                )

                HStack{
                    Button{
                        cancelMatching.toggle()
                        
                    } label: {
                        Image("EggYellow")
                    }
                    .padding(.leading,-10)
                    
                    TextEditor(text: $message)
                        .padding(3.5)
                        .frame(width: UIScreen.main.bounds.width*0.6, height: UIScreen.main.bounds.height*0.05, alignment: .leading)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.primaryColor, style: StrokeStyle(lineWidth: 2.0)))
                        .padding(.trailing, 5)
                    
                    
                    Button{
                        vm.send(text: self.message, stage: 2)
                        self.message = ""
                    } label: {
                        Text("Send")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size:20))
                    }
                    
                }
                .padding(.top, 5)
                .padding(.bottom, 25)
            }
            .background(Color.chatGray)
                .ignoresSafeArea(.container)
            
            if canceling{
                CancelView(show: $canceling, vm: vm, blocking_mode: true)
            }
            
            if reporting{
                ReportView(show: $reporting, vm:vm)
            }
        }
        
        
        
        
    }
}




struct SingleMessageView : View{
    let message : ChatMessage
    let recipientId : String
    
    var body: some View {
        if message.stage != 2{
            HStack{

                HStack{
                    Text("\(message.text)")
                        .foregroundColor(Color.white)
                        .fixedSize(horizontal: false, vertical: true)
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
                        .fixedSize(horizontal: false, vertical: true)
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
                        .fixedSize(horizontal: false, vertical: true)
                        
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

