//
//  MyChatView.swift
//  poohee
//
//  Created by Will Zhao on 4/1/22.
//

import SwiftUI

struct MessageView: View {
    
    @Binding var isPopUp : Bool
    @ObservedObject var vm : ViewModel
    
    
    var body: some View {
        ZStack{
            VStack(){
                    topBar
                    messageQueue
            }
            
            if isPopUp{
                PopUpView(show: $isPopUp, vm: vm)
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
                ForEach(0..<13, id:\.self) {num in
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
                            Text("Username")
                                .font(.system(size: 20, weight:
                                        .semibold))
                            Spacer()
                            Text("Message sent")
                                .foregroundColor(Color(.lightGray)).font(.system(size:14))
                        }
                        
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight:
                                    .semibold))
                        
                    }
                    
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

/*struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
        
        MessageView()
            .preferredColorScheme(.dark)
    }
}
*/
