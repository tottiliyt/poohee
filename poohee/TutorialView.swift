//
//  TutorialView.swift
//  poohee
//
//  Created by Will Zhao on 5/8/22.
//

import SwiftUI

struct TutorialView: View {
    @Binding var show:Bool
    
    
    var body: some View {
        ZStack{
            VStack (alignment: .center, spacing: 20){
                
                
                VStack(alignment: .leading, spacing: 20){
                    Text("Welcome to Yolk! We have started processing your survey results.")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                    
                    Text("You will be notified everytime we find a compatible match!")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                    
                }
                
                
                
                Button(action: {
                    show.toggle()
                    
                }, label: {
                    Text("Got It")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.white)
                        .padding()
                        .padding(.horizontal, 50)
                        .background(Color.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                .padding()
                
                
                
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(25)
            .padding()
            
            
            
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.45)
            .onTapGesture {
                    show.toggle()
            })
        .ignoresSafeArea()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
