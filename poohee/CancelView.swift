//
//  MatchingPopUpView.swift
//  poohee
//
//  Created by Will Zhao on 4/10/22.
//

import SwiftUI


struct CancelView: View {
    
    @Binding var show : Bool
    @Binding var canceled : Bool
    @ObservedObject var vm : ChatViewModel
    @State var selected = 0
    @State var done = false
    
    
    
    var body: some View {
        ZStack (){
            
            VStack (alignment: .center, spacing: 8){
                
                Text("Are you sure that you want to cancel this meet up?")
                    .foregroundColor(Color.primaryColor)
                    .font(.system(size: 22))
                    .padding(.horizontal)
                
                Text("You will not be able to reinitiate a meetup once you cancel")
                    .foregroundColor(Color.primaryColor)
                    .font(.system(size: 22))
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Button {
                    vm.send(text: "Unfortunately \(vm.profile?.first_name ?? "") has canceled the meet up. Sorry for the inconvenicence!", stage: -1)
                    
                    show.toggle()
                } label: {
                    Text("Yes")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(Color.red)
                        .padding()
                        .frame(width: 200, height: 45)
                        .background(Color.buttonGray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                
                Button {
                    show.toggle()
                } label: {
                    Text("No")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width: 200, height: 45)
                        .background(Color.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                .padding(.bottom)
                
            }
            .padding(20)
            .background(Color.lightBlack)
            .cornerRadius(25)
            .padding(.horizontal, 36)
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.25)
            .onTapGesture {
                    show.toggle()
            })
        .ignoresSafeArea()
        
        
        
        
    }
    
        
    
    
    
}



struct CancelView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
