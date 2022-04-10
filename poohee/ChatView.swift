//
//  ChatView.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import SwiftUI
import Firebase

class ChatViewModel: ObservableObject {
    
    @Published var errorMessage = "successfully stored message"
    @Published var messages = [ChatMessage]()
    @Published var count = 0
    @Published var i = 0
    @Published var uid = ""
    @Published var recipientId = ""
    @Published var chat : Chat
    
    
    init(chat: Chat) {
        self.chat = chat
        
        fetchMessages()
    }
    
    private func fetchMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        self.uid = uid
        
        self.recipientId = self.uid == chat.fromId ? chat.toId : chat.fromId
        
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(self.uid)
            .collection(self.recipientId)
            .order(by: "timestamp")
            .addSnapshotListener{snapshot, error in
                if let error = error{
                    self.errorMessage = "Failed to fetch messages: \(error)"
                    return
                }
                
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added{
                        let data = change.document.data()
                        let chatMessage = ChatMessage(documentId: change.document.documentID, data: data)
                        self.messages.append(chatMessage)
                    }
                    
                })
                
            }
        DispatchQueue.main.async {
            self.count += 1
        }
        
    }
    
    func send (text: String) {
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(self.uid)
            .collection(self.recipientId)
            .document()
        
        let messageContent = ["fromId": self.uid, "toId": self.recipientId, "text":text, "timestamp": Timestamp()] as [String: Any]
        
        document.setData(messageContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
            
            self.count += 1
        }
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(self.recipientId)
            .collection(self.uid)
            .document()
        
        recipientDocument.setData(messageContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
            
        }
        
        persistRecentMessage(text: text)
        print(self.errorMessage)
                
        
    }
    
    private func persistRecentMessage(text: String) {
        
        let senderContent = ["fromId": self.uid, "toId": self.recipientId, "text":text, "timestamp": Timestamp(), "first_name": chat.first_name, "profileImageUrl": chat.profileImageUrl] as [String: Any]
        
        let document = FirebaseManager.shared.firestore.collection("recent_messages")
            .document(self.uid)
            .collection("messages")
            .document(self.recipientId)
        
        document.setData(senderContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save recent message into Firebase: \(error)"
            }
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            
            let profile = data["profile"] as? Dictionary<String, Any> ?? [:]
            
            if (!profile.isEmpty) {
                
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let first_name = profile["first_name"] as? String ?? ""
                let recipientContent = ["fromId": self.uid, "toId": self.recipientId, "text":text, "timestamp": Timestamp(), "first_name": first_name, "profileImageUrl": profileImageUrl] as [String: Any]
                
                let recipientDocument = FirebaseManager.shared.firestore.collection("recent_messages")
                    .document(self.recipientId)
                    .collection("messages")
                    .document(self.uid)
                
                
                
                recipientDocument.setData(recipientContent) { error in
                    if let error = error{
                        self.errorMessage = "Failed to save message into Firebase: \(error)"
                    }
                }
            }
            
        }
        
        
        
    }
    
}

struct ChatView: View {
    
    @State var chat : Chat
    @State var message = ""
    @ObservedObject var vm : ChatViewModel
    
    init(chat: Chat){
        self.chat = chat
        vm = .init(chat: chat)
    }
    
    var body: some View {
        
        VStack{
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(vm.messages) { message in
                            SingleMessageView(message: message, recipientId: vm.recipientId)
                        }

                        HStack{ Spacer() }
                        .id("Empty")
                    }
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                            print(vm.count)
                        }
                    }
                }
            }
        
            HStack{
                TextField("Message", text: $message)
                    .padding()
                    .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.primaryColor, lineWidth: 2)
                        )
                
                Button{
                    vm.send(text: self.message)
                    self.message = ""
                } label: {
                    Image("EggYellow")
                }
                
            }
            .padding(.vertical, 6)
            .padding(.horizontal)
        }
        
        .navigationTitle(self.chat.first_name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SingleMessageView : View{
    let message : ChatMessage
    let recipientId : String
    
    var body: some View {
        if message.toId == self.recipientId{
            HStack{
                Spacer()
                
                HStack{
                    Text("\(message.text)")
                        .foregroundColor(Color.white)
                }
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(10)
                
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
        }else {
            HStack{

                HStack{
                    Text("\(message.text)")
                        
                }
                .padding()
                .background(Color.chatGray)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
