//
//  PopUpView.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import SwiftUI

struct HomePopUp: View {
    
    @Binding var show : Bool
    @ObservedObject var vm : HomeViewModel
    
    private func updateAvailability(available: Bool){
        vm.user?.available = available
        let ref = FirebaseManager.shared.firestore.collection("users").document(vm.uid)
        if available {
            
            ref.updateData([
                "available": available
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
            }
        } else {
            guard let current_match = vm.user?.current_match else {
                print ("couldn't")
                return
            }
            vm.user?.current_match = ""
            let match_ref = FirebaseManager.shared.firestore.collection("users").document(current_match)
            match_ref.updateData([
                "new_match": false,
                "current_match": ""
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
            }
            
            ref.updateData([
                "available": available,
                "current_match": ""
                
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
            }
            
            
        }
        
    }
    
    private func updateNewMatch(new_match: Bool){
        vm.user?.new_match = new_match
        let ref = FirebaseManager.shared.firestore.collection("users").document(vm.uid)
        ref.updateData([
            "new_match": new_match
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
        
    }
    
    
    var body: some View {
        
        ZStack{
            VStack (alignment: .center, spacing: 20){
                
                Text("Hey \(vm.profile?.first_name ?? ""),")
                    .font(.system(size: 25))
                    .padding(.horizontal)
                
                Text("we are trying to match you with someone.")
                    .font(.system(size: 25))
                    .padding(.horizontal)
                
                Text("Would you be available anytime in the next 4 days?")
                    .font(.system(size: 25))
                    .padding(.horizontal)
                
                Button(action: {
                    updateNewMatch(new_match: false)
                    if vm.matchIsAvailable {
                        vm.match()
                        show.toggle()
                    } else {
                        updateAvailability(available: true)
                        show.toggle()
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
                    updateNewMatch(new_match: false)
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

