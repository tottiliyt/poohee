//
//  ChatView.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import SwiftUI

struct ChatView: View {
    
    @State var user : Profile
    @State var message = ""
    
    var body: some View {
        
        VStack{
            
            ScrollView{
                ForEach(0..<20){num in
                    HStack{
                        
                        
                        HStack{
                            Text("Hello, I am a simp")
                                
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
            
            HStack{
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 30))
                    .foregroundColor(Color.gray)
                
                TextField("Message", text: $message)
                    .padding()
                    .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.primaryColor, lineWidth: 2)
                        )
                
                Button{
                    
                } label: {
                    Image("EggYellow")
                }
                
            }
            .padding(6)
        }
        
        .navigationTitle(user.first_name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
