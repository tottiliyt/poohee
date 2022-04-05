//
//  GoalView.swift
//  poohee
//
//  Created by Yuntao Li on 4/2/22.
//

import SwiftUI

struct GoalView: View {
    var body: some View {
        
        
        VStack(spacing:50) {
            Text("What brings you to Yolk?")
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))
            
            Button {
                
            }label: {
                HStack{
                    

                        Spacer()
                        Text("Make New Friends!")
                            .foregroundColor(.white)
                            .font(.system(size: 26))
                        Spacer()

                    
                }.padding(.vertical, 65)
                    .background(Color.primaryColor)
                    .cornerRadius(24)
            }
            
            Text("Actually both!")
                .foregroundColor(Color.gray)
                .font(.system(size: 36))
            
            Button {
                
            }label: {
                HStack{
                    

                        Spacer()
                        Text("Meet Like-minded People (Career/Academic)")
                            .foregroundColor(.white)
                            .font(.system(size: 26))
                        Spacer()

                    
                }.padding(.vertical, 50)
                    .background(Color.secondaryColor)
                    .cornerRadius(24)
            }
        }
        .padding(.horizontal, 50)
        
        
        
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
