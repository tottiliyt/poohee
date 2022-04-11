//
//  MatchingPopUpView.swift
//  poohee
//
//  Created by Will Zhao on 4/10/22.
//

import SwiftUI

struct SchedulingView: View {
    
    @Binding var show : Bool
    @ObservedObject var vm : ChatViewModel
    @State var selected = 0
    
    let weekdays = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"]
    let meals = ["Morning Coffee", "Lunch", "Afternoon Tea", "Dinner"]
    @State var schedulingChoices = [[false, false, false, false], [false, false, false, false], [false, false, false, false], [false, false, false, false]]
    
    var body: some View {
        VStack{
            Spacer()
            
            VStack (alignment: .center, spacing: 8){
                    
                Text("Please select below when you would like to meet up")
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                HStack{
                    
                    ForEach(0..<4, id: \.self) {i in
                        VStack (spacing: 0){
                            Button(action: {
                                selected = i
                            }, label: {
                                Text("\(weekdays[(vm.matchDay+i+1)%7])")
                                    .font(.system(size: 23, weight: .semibold))
                                    .foregroundColor(i == self.selected ? Color.white: Color.gray)
                                    .frame(width: 60, height: 60)
                                    .background(i == self.selected ? Color.primaryColor: Color.chatGray)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(.horizontal,3)
                            })
                            
                            if selected == i {
                                Image("Triangle")
                                    .resizable()
                                    .frame(width: 25, height: 20, alignment: .center)
                            } else {
                                Image("a")
                                    .resizable()
                                    .frame(width: 25, height: 20, alignment: .center)
                            }
                        }

                    }
                    
                }
                
                timeButtons
                
                Button {
                    show.toggle()
                } label: {
                    Text("Done")
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                }
                .padding(.top)
                    
                
            }
            .padding(20)
            .background(Color.lightBlack)
            .cornerRadius(25)
            .padding(.horizontal, 36)
            
            Spacer(minLength: 220)
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.01)
            .onTapGesture {
                    show.toggle()
            })
        .ignoresSafeArea()
        
        
        
        
    }
    
    var timeButtons: some View {
        
        VStack{
            
            ForEach(0..<4, id: \.self) {j in
                Button(action: {
                    schedulingChoices[selected][j].toggle()
                }, label: {
                    Text("\(meals[j])")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(schedulingChoices[selected][j] ? Color.white: Color.gray)
                        .frame(width: 285, height: 40)
                        .background(schedulingChoices[selected][j] ? Color.primaryColor: Color.chatGray)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal,5)
                })
                
            }
            
        }
            
        
    }
    
        
    
    
    
}



/*struct MatchingPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulingView()
    }
}*/
