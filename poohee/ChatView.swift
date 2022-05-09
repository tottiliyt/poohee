//
//  ChatView.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

    let standard = UINavigationBarAppearance()
        standard.backgroundColor = UIColor(Color.chatGray) //When you scroll or you have title (small one)

    navigationBar.standardAppearance = standard
 }
}

class ChatViewModel: ObservableObject {
    
    
    @Published var errorMessage = "successfully stored message"
    @Published var messages = [ChatMessage]()
    @Published var count = 0
    @Published var i = 0
    @Published var uid = ""
    @Published var recipientId = ""
    @Published var chat : Chat
    @Published var recipientProfile : Profile?
    @Published var recipientNumMeet : Int?
    @Published var numMeet : Int?
    @Published var profile: Profile?
    @Published var recipientChoices = [false]
    @Published var needMoreChoices = false
    @Published var similarities = ""
    
    
    let date = Date()
    let calendar = Calendar.current
    let weekdays = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let meals = ["Morning Coffee", "Lunch", "Afternoon Tea", "Dinner"]
    @Published var day = 0
    @Published var matchDay = 0
    
    
    init(chat: Chat) {
        self.chat = chat
        self.fetchMessages()
        self.fetchProfiles()
        self.setCurrentTime()
        self.fetchSchedulingChoices()
    }
    
    private func setCurrentTime(){
        day = calendar.component(.weekday, from: date)
        matchDay = calendar.component(.weekday, from: self.chat.timestamp.dateValue())
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
                self.fetchSimilarities()
                
            }

        DispatchQueue.main.async {
            self.count += 1
        }
        
        
    }
    private func fetchSimilarities(){
        let first = self.messages[0].text
        var array = [Character]()
        for c in first {
            if c == "," {
                array.append("\n")
            } else {
                array.append(c)
            }
            
        }
        self.similarities = String(array)
        
        
    }
    
    
    private func fetchProfiles(){
        FirebaseManager.shared.firestore.collection("users").document(self.uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            self.numMeet = data["num_meet"] as? Int ?? 0
            
            self.profile = Profile(uid: self.uid, data: data["profile"] as? Dictionary<String, Any> ?? [:])
            
        }
        
        FirebaseManager.shared.firestore.collection("users").document(self.recipientId).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            self.recipientNumMeet = data["num_meet"] as? Int ?? 0
            
            self.recipientProfile = Profile(uid: self.recipientId, data: data["profile"] as? Dictionary<String, Any> ?? [:])
            
        }
        
    }
    
    func send (text: String, stage: Int) {
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(self.uid)
            .collection(self.recipientId)
            .document()
        
        let messageContent = ["fromId": self.uid, "toId": self.recipientId, "text":text, "timestamp": Timestamp(), "stage": stage] as [String: Any]
        
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
        
        persistRecentMessage(text: text, stage: stage)
        print(self.errorMessage)
                
        
    }
    
    private func persistRecentMessage(text: String, stage:Int) {
        
        
        let senderContent = ["fromId": self.uid, "toId": self.recipientId, "text":text, "timestamp": Timestamp(), "first_name": self.recipientProfile?.first_name ?? "", "profileImageUrl": self.recipientProfile?.profileImageUrl ?? "", "stage": stage] as [String: Any]
        
        let document = FirebaseManager.shared.firestore.collection("chats")
            .document(self.uid)
            .collection("with")
            .document(self.recipientId)
        
        document.setData(senderContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save recent message into Firebase: \(error)"
            }
        }
        
        let recipientContent = ["fromId": self.uid, "toId": self.recipientId, "text":text, "timestamp": Timestamp(), "first_name": self.profile?.first_name ?? "", "profileImageUrl": self.profile?.profileImageUrl ?? "", "stage" : stage] as [String: Any]
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("chats")
            .document(self.recipientId)
            .collection("with")
            .document(self.uid)
        
        
        
        recipientDocument.setData(recipientContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save message into Firebase: \(error)"
            }
        }
        
    }
    
    private func fetchSchedulingChoices(){
        FirebaseManager.shared.firestore.collection("scheduling").document(self.recipientId).collection("choices").document(self.uid).addSnapshotListener { snapshot, error in
            if let error = error {
                self.errorMessage = "no scheduling choices found: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            
            self.recipientChoices = data["schedulingChoices"] as? [Bool] ?? [false]
            
        }
    }
    
    func setSchedulingChoices(schedulingChoices: [Bool]) {
        var choices = 0
        for b in schedulingChoices{
            if b{
                choices += 1
            }
        }
        
        if choices <= 3 {
            self.needMoreChoices = true
            return
        }
        
        let senderContent = ["fromId": self.uid, "toId": self.recipientId, "schedulingChoices": schedulingChoices] as [String: Any]
        
        let document = FirebaseManager.shared.firestore.collection("scheduling")
            .document(self.uid)
            .collection("choices")
            .document(self.recipientId)
        
        document.setData(senderContent) { error in
            if let error = error{
                self.errorMessage = "Failed to save recent message into Firebase: \(error)"
            }
        }
        self.needMoreChoices = false
        
        
        if self.recipientChoices.count > 1 {
            var x = -1
            for i in 0..<16{
                if self.recipientChoices[i] && schedulingChoices[i]{
                    print(x)
                    x = i
                    break
                }
            }
            if x == -1{
                send(text: "Oops, looks like your availabilities in the upcoming days don't quite match up. Maybe figuring out a time + a public place to meet could be your first icebreaker 😇", stage: 1)
                updateNumMeet()
            } else {
                print("got here")
                send(text: "😇 You two have agreed to meet on  \(weekdays[(self.matchDay + x/4 + 1) % 7]) for \(meals[x%4])! You can now message each other freely. Be the first to break the ice by suggesting a restaurant/coffee shop to meet up at!", stage: 1)
                updateNumMeet()
            }
            
        }
        
        
        
        
        
        print(self.errorMessage)
    }
    
    private func updateNumMeet(){
        let ref = FirebaseManager.shared.firestore.collection("users").document(self.uid)
        let newNumMeet = (self.numMeet ?? 0) + 1
        ref.updateData([
            "num_meet": newNumMeet
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
        
        let recipientRef = FirebaseManager.shared.firestore.collection("users").document(self.recipientId)
        let recipientNewNumMeet = (self.recipientNumMeet ?? 0) + 1
        recipientRef.updateData([
            "num_meet": recipientNewNumMeet
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.fetchProfiles()
            }
        }
            

    }
    
}

struct ChatView: View {
    
    @State var chat : Chat
    @ObservedObject var vm : ChatViewModel
    @State var scheduled = false
    
    
    init(chat: Chat){
        self.chat = chat
        vm = .init(chat: chat)
        let expiration = vm.chat.timestamp.dateValue().addingTimeInterval(259200)
        if (Date() > expiration)  && vm.chat.stage <= 0 {
            vm.send(text: "Looks like at least one of you has been quite busy in the past few days. If you would still like to meet up, figuring out a time + a public place to meet could be your first icebreaker 😇", stage: 1)
        }
        
        
    }
    
    var body: some View {
        if scheduled {
            PostSchedulingView(vm: vm)
            //SchedulingView(vm:vm, scheduled: $scheduled)
                .navigationBarHidden(true)
        } else if vm.chat.stage <= 0 {
            SchedulingView(vm:vm, scheduled: $scheduled)
                .navigationBarHidden(true)
        } else {
            PostSchedulingView(vm: vm)
            //SchedulingView(vm:vm, scheduled: $scheduled)
                .navigationBarHidden(true)
        }
            
    }
    
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
