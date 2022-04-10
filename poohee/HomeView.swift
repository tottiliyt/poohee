//
//  HomeView.swift
//  poohee
//
//  Created by Will Zhao on 4/7/22.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var uid = ""
    @Published var errorMessage = ""
    @Published var isCurrentlyLoggedOut = true
    @Published var user: User?
    @Published var profile: Profile?
    @Published var chats = [Chat]()
    
    init() {
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
            
            print(self.isCurrentlyLoggedOut)
        }
        
        fetchCurrentUser()
        
        fetchRecentMessages()
    }
    
    public func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "not logged in"
            self.isCurrentlyLoggedOut = true
            return
        }
        
        self.uid = uid
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                self.isCurrentlyLoggedOut = true
                return
            }

            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                self.isCurrentlyLoggedOut = true
                return

            }
            
            
            let email = data["email"] as? String ?? ""
            
            self.profile = Profile(uid: self.uid, data: data["profile"] as? Dictionary<String, Any> ?? [:])
            
            self.user = User(uid: self.uid, email: email, profile: self.profile!)
        }
    }
    
    public func signOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
    private func fetchRecentMessages() {
        let uid = self.uid
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener{ snapshot, error in
                if let error = error{
                    self.errorMessage = "failed to retrieve recent messages: \(error)"
                    return
                }
                
                
                
                snapshot?.documentChanges.forEach({ change in
                    
                    if let index = self.chats.firstIndex(where: { rm in
                        return rm.documentId == change.document.documentID
                    }) {
                        self.chats.remove(at: index)
                    }
                    
                    
                    self.chats.insert(.init(documentId: change.document.documentID,  data: change.document.data()), at: 0)
                    
                })
                
            }
        
        print (self.errorMessage)
    }
}


struct HomeView: View {
    
    @ObservedObject var vm = HomeViewModel()
    @State var isMessageMode = true
    @State var isPopUp = false
    @State var accepted = false
    
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ZStack{
                    if isMessageMode {
                        MessageView(isPopUp: $isPopUp, vm : vm, accepted: $accepted)
                    } else {
                        ProfileView()
                    }
                }
                
                HStack(){
                    Button(action: {
                        isMessageMode = true
                    }, label: {
                        HStack(spacing:0){
                            Spacer()
                            if isMessageMode{
                                Image("MessageWhite")
                                    .resizable()
                                    .frame(width:47, height:47)
                            } else {
                                Image("MessageGrey")
                                    .resizable()
                                    .frame(width:47, height:47)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 21)
                            .background(isMessageMode ? Color.primaryColor: Color.white)
                            .cornerRadius(20)
                    })
                    
                    Button(action: {
                        isMessageMode = false
                    }, label: {
                        HStack(spacing:0){
                            Spacer()
                            if isMessageMode{
                                Image("ProfileGrey")
                                    .font(.system(size: 100))
                            } else {
                                Image("ProfileWhite")
                                    .font(.system(size: 100))
                            }
                                
                            Spacer()
                        }
                        .padding(.vertical, 20)
                            .background(isMessageMode ? Color.white: Color.secondaryColor)
                            .cornerRadius(20)
                        
                    })
                   
                }
                
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarHidden(true)
        }
        
    }
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
