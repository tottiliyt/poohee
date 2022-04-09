//
//  HomeView.swift
//  poohee
//
//  Created by Will Zhao on 4/7/22.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var uid = ""
    
    @Published var error_message = ""
    
    @Published var isCurrentlyLoggedOut = true
    
    @Published var user: User?
    
    @Published var profile: Profile?
    
    @Published var matchedUsers = [Profile]()
    
    init() {
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
            
            print(self.isCurrentlyLoggedOut)
        }
        
        fetchCurrentUser()
    }
    
    public func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.error_message = "not logged in"
            self.isCurrentlyLoggedOut = true
            return
        }
        
        self.uid = uid
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.error_message = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                self.isCurrentlyLoggedOut = true
                return
            }

            guard let data = snapshot?.data() else {
                self.error_message = "No data found"
                self.isCurrentlyLoggedOut = true
                return

            }
            
            
            let email = data["email"] as? String ?? ""
            
            let profile = data["profile"] as? Dictionary<String, Any> ?? [:]
            
            let matched = data["matchedUsers"] as? [String] ?? [String]()
            
            for uid in matched{
                self.fetchProfile(uid:uid)
            }
            
            if (!profile.isEmpty) {
                
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let first_name = profile["first_name"] as? String ?? ""
                let gender = profile["gender"] as? String ?? ""
                let goal = profile["goal"] as? String ?? ""
                let graduation_year = profile["graduation_year"] as? String ?? ""
                let last_name = profile["last_name"] as? String ?? ""
                let political = profile["political"] as? String ?? ""
                let religious = profile["religious"] as? String ?? ""
                
                let career_interests = profile["career_interests"] as? [String] ?? []
                let hobbies = profile["hobbies"] as? [String] ?? []
                let majors = profile["majors"] as? [String] ?? []
                let questionnaire = profile["questionnaire"] as? [String] ?? []
                
                self.profile = Profile(uid: self.uid, first_name: first_name, gender: gender, goal: goal, graduation_year: graduation_year, last_name: last_name, political: political, religious: religious, profileImageUrl: profileImageUrl, career_interests: career_interests, hobbies: hobbies, majors: majors, questionnaire: questionnaire)
                
                self.user = User(uid: self.uid, email: email, profile: self.profile!)
            }
        }
    }
    
    public func signOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
    private func fetchProfile(uid:String){
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.error_message = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                self.error_message = "No data found"
                return

            }
            
            let profile = data["profile"] as? Dictionary<String, Any> ?? [:]
            
            if (!profile.isEmpty) {
                
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let first_name = profile["first_name"] as? String ?? ""
                let gender = profile["gender"] as? String ?? ""
                let goal = profile["goal"] as? String ?? ""
                let graduation_year = profile["graduation_year"] as? String ?? ""
                let last_name = profile["last_name"] as? String ?? ""
                let political = profile["political"] as? String ?? ""
                let religious = profile["religious"] as? String ?? ""
                
                let career_interests = profile["career_interests"] as? [String] ?? []
                let hobbies = profile["hobbies"] as? [String] ?? []
                let majors = profile["majors"] as? [String] ?? []
                let questionnaire = profile["questionnaire"] as? [String] ?? []
                
                let profile = Profile(uid:uid, first_name: first_name, gender: gender, goal: goal, graduation_year: graduation_year, last_name: last_name, political: political, religious: religious, profileImageUrl: profileImageUrl, career_interests: career_interests, hobbies: hobbies, majors: majors, questionnaire: questionnaire)
                
                self.matchedUsers.append(profile)
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
