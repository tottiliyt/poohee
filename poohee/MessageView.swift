//
//  MyChatView.swift
//  poohee
//
//  Created by Will Zhao on 4/1/22.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        
        NavigationView {
            VStack{
                
                topBar
                messageQueue
            }
            .navigationBarHidden(true)
        
        }
    }
    
    private var topBar: some View {
        HStack (spacing: 16){
            Text("No Upcmoing Meetups").font(.system(size: 24, weight: .bold))
                .padding(.vertical, 40)
        }
        .padding()
    }
    
    private var messageQueue: some View {
        ScrollView{
            ForEach(0..<13, id:\.self) {num in
                VStack{
                    HStack(spacing: 16){
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44).stroke(lineWidth: 1))
                        
                        VStack (alignment: .leading){
                            Text("Username")
                                .font(.system(size: 16, weight:
                                        .bold))
                            Text("Message sent")
                                .foregroundColor(Color(.lightGray)).font(.system(size:14))
                        }
                        
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight:
                                    .semibold))
                        
                    }
                    
                    Divider()
                        .padding(.vertical, 5)
                }
                .foregroundColor(Color.orange)
                .padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
        
        MessageView()
            .preferredColorScheme(.dark)
    }
}
