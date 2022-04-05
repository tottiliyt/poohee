//
//  HomeView.swift
//  poohee
//
//  Created by Yuntao Li on 4/2/22.
//

import SwiftUI


class HomeViewModel: ObservableObject {
    
    @Published var error_message = ""
    
    @Published var isCurrentlyLoggedOut = true
    
    init() {
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            error_message = "not logged in"
            return
            
        }
        self.error_message = "logged in with uid:" + uid
        print(uid)
    }
    
    public func signOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct HomeView: View {
    
    @ObservedObject private var vm = HomeViewModel()
    
    var body: some View {
        
        VStack{
            Text(vm.error_message)
            
            Button {
                vm.signOut()
            }label: {
                HStack{
                        Spacer()
                        Text("Log out")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        Spacer()

                    
                }.padding(.vertical, 12)
                    .background(Color.primaryColor)
                    .cornerRadius(24)
            }.padding(.top, 130)
        }.fullScreenCover(isPresented: $vm.isCurrentlyLoggedOut, onDismiss: nil) {
            WelcomeView(didCompleteLoginProcess: {
                self.vm.isCurrentlyLoggedOut = false
            })
        }
    
    }
    
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
