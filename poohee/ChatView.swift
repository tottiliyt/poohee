//
//  ChatView.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import SwiftUI
import Firebase
import simd

class ChatViewModel: ObservableObject {
    
    @Published var errorMessage = "successfully stored message"
    @Published var messages = [ChatMessage]()
    @Published var count = 0
    @Published var i = 0
    
    let recipient : Profile
    
    init(recipient: Profile) {
        self.recipient = recipient
        
        fetchMessages()
    }
    
    private func fetchMessages(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        let toId = self.recipient.uid
        
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
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
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        let toId = self.recipient.uid
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageContnet = ["fromId":fromId, "toId": toId, "text":text, "timestamp": Timestamp()] as [String: Any]
        
        document.setData(messageContnet) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
            
            self.count += 1
        }
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientDocument.setData(messageContnet) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
            
        }
        
        print(self.errorMessage)
                
        
    }
}

struct ChatView: View {
    
    @State var recipient : Profile
    @State var message = ""
    @ObservedObject var vm : ChatViewModel
    
    init(recipient: Profile){
        self.recipient = recipient
        vm = .init(recipient: recipient)
    }
    
    var body: some View {
        
        VStack{
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(vm.messages) { message in
                            SingleMessageView(message: message, recipient: self.recipient)
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
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 30))
                    .foregroundColor(Color.gray)
                
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
            .padding(6)
        }
        
        .navigationTitle(self.recipient.first_name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SingleMessageView : View{
    let message : ChatMessage
    let recipient: Profile
    
    var body: some View {
        if message.toId == self.recipient.uid{
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
