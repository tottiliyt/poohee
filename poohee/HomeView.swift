//
//  HomeView.swift
//  poohee
//
//  Created by Will Zhao on 4/7/22.
//

import SwiftUI
import Firebase

class HomeViewModel: ObservableObject {
    
    @Published var uid = ""
    @Published var errorMessage = ""
    @Published var isCurrentlyLoggedOut = true
    @Published var isProfileFinished = false
    @Published var user: User?
    @Published var profile: Profile?
    @Published var matchProfile: Profile?
    @Published var chats = [Chat]()
    @Published var profile_img_url = ""
    @Published var matchIsAvailable = false
    
    
    init() {
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
            
        }
        
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    public func logout() {
        
        do {
          try FirebaseManager.shared.auth.signOut()
        
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
        self.uid = ""
        self.errorMessage = ""
        self.isCurrentlyLoggedOut = true
        self.isProfileFinished = false
        self.user = nil
        self.profile = nil
        self.chats = []
    }
    
    public func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "not logged in"
            self.isCurrentlyLoggedOut = true
            return
        }

        self.uid = uid

        FirebaseManager.shared.firestore.collection("users").document(uid).addSnapshotListener { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }


            let email = data["email"] as? String ?? ""
            let profile_image_url = data["profileImageUrl"] as? String ?? ""
            let matching = data["matching"] as? String ?? ""
            let num_meet = data["num_meet"] as? Int ?? 0
            
            self.profile_img_url = data["profileImageUrl"] as? String ?? ""
            
            print("fetched url is \(self.profile_img_url)")

            if ((data["profile"] as? Dictionary<String, Any> ?? [:]).count > 0) {
                print("user has profile uploaded")
                self.isProfileFinished = true
            } else {
                self.isProfileFinished = false
            }

            self.profile = Profile(uid: self.uid, data: data["profile"] as? Dictionary<String, Any> ?? [:])

            self.user = User(uid: self.uid, email: email, profileImageUrl: profile_image_url, matching: matching, current_match: data["current_match"] as? String ?? "", match_similarity: data["match_similarity"] as? String ?? "", available: data["available"] as? Bool ?? false, new_match: data["new_match"] as? Bool ?? false, profile: self.profile!, num_meet: num_meet)
            
            self.fetchMatch()
            
        }
    }
    
    public func signOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
    private func fetchMatch() {
        guard let currentMatch = self.user?.current_match else {
            print ("couldn't")
            return
        }
        
        if currentMatch != "" {
            FirebaseManager.shared.firestore.collection("users").document(currentMatch).addSnapshotListener { snapshot, error in
                if let error = error {
                    self.errorMessage = "no match found: \(error)"
                    print("Failed to fetch matched user:", error)
                    return
                }
                
                guard let data = snapshot?.data() else {
                    self.errorMessage = "No data found"
                    return

                }

                self.matchProfile = Profile(uid: currentMatch, data: data["profile"] as? Dictionary<String, Any> ?? [:])
                
                self.matchIsAvailable = data["available"] as? Bool ?? false
                print ("could")
                
            }
        }
        
    }
    
    public func fetchRecentMessages() {
        let uid = self.uid
        
        
        if uid == "" {
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("chats")
            .document(uid)
            .collection("with")
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
    
    func match() {
        guard let currentMatch = self.user?.current_match else {
            return
        }
        
        if currentMatch != "" {
            let document = FirebaseManager.shared.firestore.collection("messages")
                .document(self.uid)
                .collection(currentMatch)
                .document()
            
            let senderContent = ["fromId": self.uid, "toId": currentMatch, "text": self.user?.match_similarity ?? "", "timestamp": Timestamp(), "stage": 0] as [String: Any]
            
            let recipientContent = ["fromId": currentMatch, "toId": self.uid, "text":self.user?.match_similarity ?? "", "timestamp": Timestamp(), "stage": 0] as [String: Any]
            
            document.setData(senderContent) { error in
                if let error = error{
                    self.errorMessage = "Failed to save message into Firebase: \(error)"
                }
                
            }
            
            let recipientDocument = FirebaseManager.shared.firestore.collection("messages")
                .document(currentMatch)
                .collection(self.uid)
                .document()
            
            recipientDocument.setData(recipientContent) { error in
                if let error = error{
                    self.errorMessage = "Failed to save message into Firebase: \(error)"
                }
                
            }
            
            persistRecentMessage(text: self.user?.match_similarity ?? "", stage: 0, currentMatch: currentMatch)
            print(self.errorMessage)
        }
        
    }
    
    private func persistRecentMessage(text: String, stage:Int, currentMatch: String) {
        
        
        let senderContent = ["fromId": self.uid, "toId": currentMatch, "text":text, "timestamp": Timestamp(), "first_name": self.matchProfile?.first_name ?? "", "profileImageUrl": self.matchProfile?.profileImageUrl ?? "", "stage": stage] as [String: Any]
        
        let document = FirebaseManager.shared.firestore.collection("chats")
            .document(self.uid)
            .collection("with")
            .document(currentMatch)
        
        document.setData(senderContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save recent message into Firebase: \(error)"
            }
        }
        
        let recipientContent = ["fromId": currentMatch, "toId": self.uid, "text":text, "timestamp": Timestamp(), "first_name": self.profile?.first_name ?? "", "profileImageUrl": self.profile?.profileImageUrl ?? "", "stage" : stage] as [String: Any]
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("chats")
            .document(currentMatch)
            .collection("with")
            .document(self.uid)
        
        
        
        recipientDocument.setData(recipientContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
        }
        
    }
    
    func updateMatching(){
        let ref = FirebaseManager.shared.firestore.collection("users").document(self.uid)
        if (self.user?.matching == "On") {
            
            self.user?.matching = "Off"
            ref.updateData([
                "matching": "Off"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    
                    self.fetchCurrentUser()
                }
            }
        }
        else {
            self.user?.matching = "On"
            ref.updateData([
                "matching": "On"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    
                    self.fetchCurrentUser()
                }
            }
        }
    }
}


struct HomeView: View {
    
    @ObservedObject var vm = HomeViewModel()
    @State var isMessageMode = true
    @State var isPopUp = false
    @State var accepted = false
    
    var body: some View {
        
        if (!vm.isProfileFinished) {

            SurveyView(vm : vm)
            
        } else {
            NavigationView{
                VStack(spacing:0){
                    ZStack{
                        if isMessageMode {
                            MessageView(isPopUp: $isPopUp, vm : vm)
                        } else {
                            ProfileView(vm : vm)
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
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
