//
//  ReportView.swift
//  poohee
//
//  Created by Will Zhao on 5/13/22.
//

import SwiftUI




struct ReportView: View {
    @Binding var show : Bool
    @ObservedObject var vm : ChatViewModel
    var body: some View {
        ZStack (){
            
            VStack (alignment: .center, spacing: 8){
                
                Text("REPORT")
                    .foregroundColor(Color.primaryColor)
                    .font(.system(size: 22))
                    .padding(.horizontal)
                
                Text("you can report this chat to Yolk if you think it has any problem listed in the next page. We won't notify the account that you submitted this report.")
                    .foregroundColor(Color.white)
                    .font(.system(size: 16))
                
                
                NavigationLink{
                    ReportDetailView(vm:vm)
                } label: {
                    
                        Text("Report")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(width: 200, height: 45)
                            .background(Color.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                }
                
                Text("Cancel")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(Color.primaryColor)
                    .padding()
                    .frame(width: 200, height: 45)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom)
                    .onTapGesture{
                        show.toggle()
                    }
                
                    
                
                
                
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

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
