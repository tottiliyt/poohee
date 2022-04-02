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
            Image(systemName: "person.fill")
                .font(.system(size: 36))
            
            VStack (alignment: .leading, spacing: 4){
                Text("Username").font(.system(size: 24, weight: .bold))
                HStack{
                    Circle().foregroundColor(Color.green).frame(width:14, height: 14)
                    Text("Online").foregroundColor(Color(.lightGray)).font(.system(size:12))
                }
            }
            
            Spacer()
            
            Button {
                //need update
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(Color.orange)
                    .font(.system(size: 24, weight: .bold))
            }
            
        }.padding()
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
