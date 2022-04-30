//
//  PopUpView.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import SwiftUI

struct HomePopUp: View {
    
    @Binding var show : Bool
    @Binding var accepted: Bool
    @ObservedObject var vm : HomeViewModel
    
    private func updateAvailability(available: Bool){
        let ref = FirebaseManager.shared.firestore.collection("users").document(vm.uid)
        ref.updateData([
            "available": available
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
        
    }
    
    
    var body: some View {
        
        ZStack{
            VStack (alignment: .center, spacing: 20){
                if (accepted){
                    Text("Awesome!")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                    
                    Text("We will set up the meet up as soon as your match confirms their availability too.")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                    
                    Button(action: {
                        show.toggle()
                    }, label: {
                        Text("Alrighty")
                            .font(.system(size: 35, weight: .semibold))
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(width: 200, height: 80)
                            .background(Color.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    })
                    
                    
                }else {
                    Text("Hey \(vm.profile?.first_name ?? ""),")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                    
                    Text("We might have just found you your next best friend!")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                    
                    Text("Will you be available anytime in the next 3 days to meetup?")
                        .font(.system(size: 25))
                        .padding(.horizontal)
                    
                    Button(action: {
                        if vm.matchIsAvailable {
                            print("asdasdasdasd")
                            vm.match()
                        } else {
                            accepted.toggle()
                            updateAvailability(available: true)
                        }
                        
                    }, label: {
                        Text("Yes, I'd love to")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(width: 250, height: 60)
                            .background(Color.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    
                    
                    Button(action: {
                        updateAvailability(available: false)
                        show.toggle()
                    }, label: {
                        Text("Too busy, I'll pass")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                            .padding()
                            .frame(width: 250, height: 60)
                            .background(Color.buttonGray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    
                }
                
            }
            .padding(30)
            .background()
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

