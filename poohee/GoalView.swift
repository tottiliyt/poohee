//
//  GoalView.swift
//  poohee
//
//  Created by Yuntao Li on 4/2/22.
//

import SwiftUI

struct GoalView: View {
    
    @State var friend = false
    @State var career = false
    
    var body: some View {
        
        VStack(spacing:50) {
            Text("What brings you to Yolk?")
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))
            
            Button {
                friend.toggle()
            }label: {
                HStack{
                    

                        Spacer()
                        Text("Make New Friends!")
                            .foregroundColor(.white)
                            .font(.system(size: 26))
                        Spacer()

                    
                }.padding(.vertical, 65)
                    .background(Color.primaryColor)
                    .cornerRadius(15)
                    .border(Color.orange, width: friend ? 5 : 0)
            }
            
            
            Button {
                career.toggle()
            }label: {
                HStack{
                    

                        Spacer()
                        Text("Expand My Network")
                            .foregroundColor(.white)
                            .font(.system(size: 26))
                        Spacer()

                    
                }.padding(.vertical, 50)
                    .background(Color.secondaryColor)
                    .cornerRadius(15)
                    .border(Color.purple, width: career ? 5 : 0)
                
            }
        }
        .padding(.horizontal, 50)
    }
    
    
    private func bothToggle() {
        friend = true
        career = true
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
