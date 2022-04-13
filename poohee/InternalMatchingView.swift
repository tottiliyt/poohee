//
//  InternalMatchingView.swift
//  poohee
//
//  Created by Will Zhao on 4/12/22.
//

import SwiftUI
import Firebase


class InternalMatchingViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var profile:Profile?
    @Published var recipientProfile:Profile?
    
    
    func fetchProfiles(fromId: String, toId: String){
        FirebaseManager.shared.firestore.collection("users").document(fromId).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                print(self.errorMessage)
                return

            }
            
            self.profile = Profile(uid: fromId, data: data["profile"] as? Dictionary<String, Any> ?? [:])
            
        }
        
        FirebaseManager.shared.firestore.collection("users").document(toId).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                print(self.errorMessage)
                return

            }
            
            self.recipientProfile = Profile(uid: toId, data: data["profile"] as? Dictionary<String, Any> ?? [:])
            print ("receiving: \(self.recipientProfile?.first_name ?? "empty")" )
            print ("sending: \(self.profile?.first_name ?? "empty")")
            print("finished")
            
        }
        
    }
    
    func send (text: String, stage: Int, fromId: String, toId: String) {
        
        
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageContent = ["fromId": fromId, "toId": toId, "text":text, "timestamp": Timestamp(), "stage": stage] as [String: Any]
        
        document.setData(messageContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
        }
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientDocument.setData(messageContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
            
        }
        
        persistRecentMessage(text: text, stage: stage, fromId: fromId, toId: toId)
        
        print(self.errorMessage)
                
        
    }

    private func persistRecentMessage(text: String, stage:Int, fromId: String, toId: String) {
        
        
        let senderContent = ["fromId": fromId, "toId": toId, "text":text, "timestamp": Timestamp(), "first_name": self.recipientProfile?.first_name ?? "", "profileImageUrl": self.recipientProfile?.profileImageUrl ?? "", "stage": stage] as [String: Any]
        
        let document = FirebaseManager.shared.firestore.collection("chats")
            .document(fromId)
            .collection("with")
            .document(toId)
        
        document.setData(senderContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save recent message into Firebase: \(error)"
            }
        }
        
        let recipientContent = ["fromId": fromId, "toId": toId, "text":text, "timestamp": Timestamp(), "first_name": self.profile?.first_name ?? "", "profileImageUrl": self.profile?.profileImageUrl ?? "", "stage" : stage] as [String: Any]
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("chats")
            .document(toId)
            .collection("with")
            .document(fromId)
        
        
        
        recipientDocument.setData(recipientContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
        }
        
        print(self.errorMessage)
        
    }
    
    
    func setSchedulingChoices(schedulingChoices: String, fromId: String, toId: String) {
        
        var data = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        var i = 0
        
        for c in schedulingChoices{
            if c == "1"{
                data[i] = true
            }
            i += 1
        }
        
        
        let senderContent = ["fromId": fromId, "toId": toId, "schedulingChoices": data] as [String: Any]
        
        let document = FirebaseManager.shared.firestore.collection("scheduling")
            .document(fromId)
            .collection("choices")
            .document(toId)
        
        document.setData(senderContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save recent message into Firebase: \(error)"
            }
        }
        
        
        
        
        
        print(self.errorMessage)
    }
}





struct InternalMatchingView: View {
    @ObservedObject var vm = InternalMatchingViewModel()
    @State var fromId = ""
    @State var toId = ""
    @State var text = ""
    @State var stage = ""
    @State var schedulingChoices = "0000000000000000"
    
    var body: some View {
        VStack (spacing: 10){
            TextField("FromID", text: $fromId)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            .cornerRadius(10)
            
            TextField("ToID", text: $toId)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            .cornerRadius(10)
            
            TextField("Text", text: $text)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            .cornerRadius(10)
            
            TextField("Stage", text: $stage)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            .cornerRadius(10)
            
            TextField("Scheduling", text: $schedulingChoices)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
            .cornerRadius(10)
            
            Button {
                if fromId != "" && toId != "" && stage != ""{
                    vm.fetchProfiles(fromId: fromId, toId: toId)
                    fromId = ""
                    toId = ""
                }
                
            } label: {
                Text("Fetch Profiles")
            }
            
            Button {
                if fromId != "" && toId != "" && stage != ""{
                    vm.send(text: text, stage: Int(stage) ?? 2, fromId: fromId, toId: toId)
                    text = ""
                    stage = ""
                    fromId = ""
                    toId = ""
                    schedulingChoices = "0000000000000000"
                }
                
            } label: {
                Text("Send")
            }
            
            Button {
                if fromId != "" && toId != ""{
                    vm.setSchedulingChoices(schedulingChoices: schedulingChoices, fromId: fromId, toId: toId)
                    text = ""
                    stage = ""
                    fromId = ""
                    toId = ""
                    schedulingChoices = "0000000000000000"
                }
                
            } label: {
                Text("Schedule")
            }
            
            
        }
    }
}

struct InternalMatchingView_Previews: PreviewProvider {
    static var previews: some View {
        InternalMatchingView()
    }
}
