//
//  ProfileView.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @ObservedObject var vm : HomeViewModel
    @State var bio = ""
    @State var editing = false
    let download_url = "apple.com"
    
    @State private var imageURL = URL(string: "")
    @State private var copied = false {
        didSet {
            if copied == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        copied = false
                    }
                }
            }
        }
    }
    @State private var logoutactionsheetisopen = false
    
    var body: some View {
        
        //ScrollView {
            
            
            GeometryReader { geo in
                
                ZStack {
                    
                    
                    VStack() {
                        
                        HStack {
                            
                            Button {
                                logoutactionsheetisopen.toggle()
                            } label: {
                                Image("logout").resizable().frame(width: 30, height:30)
                            }
                            
                            Spacer()
                            
                            Button {
                                vm.updateMatching()
                            } label: {
                                HStack{
                                    Text("Matching \(vm.user?.matching ?? "Off")")
                                            .foregroundColor(.white)
                                            .font(.system(size: 22))
                                            .padding(.horizontal)
                                            .padding(5)
                                        
                                    
                                }
                                .background(vm.user?.matching == "On" ? Color.primaryColor : Color.secondaryColor)
                                    .cornerRadius(12)
                            }
                        }.padding(.bottom)
                        
                        
                        WebImage(url: imageURL)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                            .cornerRadius(200)
                            .onReceive(vm.$profile_img_url) { _ in
                                loadImageFromFirebase()
                            }
                            .overlay(RoundedRectangle(cornerRadius: 200)
                                .stroke(lineWidth: 2)
                                .foregroundColor(Color.secondaryColor)
                            )
                            
                            
                        

                        Text(vm.profile?.first_name ?? "")
                            .font(.system(size: 36))
                            .foregroundColor(Color.secondaryColor)
                        
                        HStack{
                            
                            Button {
                                
                            } label: {
                                HStack{
                                        Spacer()
                                    Text(vm.profile?.class_standing ?? "")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24))
                                        Spacer()

                                    
                                }
                                    .background(Color.secondaryColor)
                                    .cornerRadius(24)
                            }.padding(.horizontal, 80)
                        }

                        HStack {
                            Button {
                            }label: {
                                HStack{
                                
                                        
                                    Text(String(vm.user?.num_meet ?? 0))
                                            .foregroundColor(.white)
                                            .font(.system(size: 24))
                                            .padding(6)
                                            .padding(.horizontal, 4)
                                        
                                    
                                }
                                    .background(Color.secondaryColor)
                                    .cornerRadius(10)
                                    
                                    
                            }
                            
                            
                            Text("Meetups already ")
                                .font(.system(size: 24))
                                .foregroundColor(Color.secondaryColor)
                                
                            
                        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                        
                        Group {
                            HStack {
                                VStack {
                                    Text("Invite more friends!")
                                        .foregroundColor(Color.primaryColor)
                                        .font(.system(size: 23, weight: .heavy))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    Text("appstore.com")
                                        .foregroundColor(Color.black)
                                        .background(Color.buttonGray)
                                        .font(.system(size: 16))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    Text("Hey! I’m trying out this super cool app called Yolk where you can meet new ppl in the community!")
                                        .foregroundColor(Color.primaryColor)
                                        .font(.system(size: 9))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                }
                                Button {
                                }label: {
                                    HStack{
                                    
                                            
                                            Text("COPY")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                                .padding(6)
                                                .padding(.vertical, 12)
                                                .onTapGesture{
                                                    UIPasteboard.general.string = self.download_url
                                                    withAnimation {
                                                        copied = true
                                                    }
                                                }
                                            
                                        
                                    }
                                        .background(Color.primaryColor)
                                        .cornerRadius(10)
                                        
                                }.padding(.top, 20)
                                
                                Button {
                                    actionSheet()
                                }label: {

                                    Image("share").resizable().frame(width: 40, height:40)
                                        
                                }.padding(.top, 35)
                                
                            }
                            
                            
                            
                            VStack (spacing: 7) {
                                HStack(){
                                    Text("Bio")
                                        .font(.system(size: 24))
                                        .bold()
                                        .foregroundColor(Color.primaryColor)
                                    
                                    if !editing {
                                        Button {
                                            self.bio = vm.profile?.bio ?? ""
                                            editing.toggle()
                                        } label: {
                                            Text("Edit")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color.gray)
                                            
                                            
                                        }
                                    }
                                    
                                    
                                    
                                    Spacer()
                                    
                                    
                                }
                                
                                

                                VStack{
                                    if editing {
                                        TextEditor(text: $bio)
                                            .font(.system(size: 16))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(8)
                                            .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.primaryColor, lineWidth: 2))
                                        
                                        Button {
                                            updateBio()
                                            editing.toggle()
                                        } label: {
                                            Text("Done")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(Color.gray)
                                            
                                            
                                        }
                                        
                                    } else {
                                        Text(vm.profile?.bio ?? "")
                                            .font(.system(size: 16))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.primaryColor, lineWidth: 2)
                                            )
                                        
                                    }
                                    

                                        

                                    
                                }
                            }
                            
                            VStack (spacing: 7) {
                                HStack {
                                    Text("Goal")
                                        .font(.system(size: 24))
                                        .bold()
                                        .foregroundColor(Color.primaryColor)

                                    Text("(Click to change)")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.gray)

                                }                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Button {
                                        if (vm.profile?.goal == "career") {
                                            updateGoal()
                                        }
                                        
                                    }label: {
                                        HStack {
                                            Spacer()
                                            VStack{
                                                    Text("Make New")
                                                        .foregroundColor(vm.profile?.goal == "friend" ? .white : .gray)
                                                        .font(.system(size: 15))
                                                Text("Friends!")
                                                    .foregroundColor(vm.profile?.goal == "friend" ? .white : .gray)
                                                    .font(.system(size: 15))

                                                
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(vm.profile?.goal == "friend" ? Color.primaryColor : Color.buttonGray)
                                        .cornerRadius(15)
                                    }
                                    
                                    
                                    Button {
                                        if (vm.profile?.goal == "friend") {
                                            updateGoal()
                                        }
                                    }label: {
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Text("Expand My")
                                                .foregroundColor(vm.profile?.goal == "career" ? .white : .gray)
                                                .font(.system(size: 15))
                                                
                                                Text("Network!")
                                                .foregroundColor(vm.profile?.goal == "career" ? .white : .gray)
                                                .font(.system(size: 15))

                                                    
                                                    
                                                
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(vm.profile?.goal == "career" ? Color.secondaryColor : Color.buttonGray)
                                        .cornerRadius(15)
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                            
                            
                        }
                        
                        

                    }
                    .padding(.horizontal, 30)
                    
                    if copied {
                        Text("Download link copied")
                            .padding()
                            .font(.system(size: 16))
                            .background(Color.primaryColor.cornerRadius(20))
                            .foregroundColor(Color.white)
                            .position(x: geo.frame(in: .local).width/2)
                            .transition(.move(edge: .top))
                            .padding(.top)
                            .animation(Animation.easeInOut(duration: 1), value: copied)
                    }
                    
                    
                       
                }
            }
            .actionSheet(isPresented: $logoutactionsheetisopen) {
                .init(title: Text("Do you want to sign out?"), buttons: [.destructive(Text("Sign Out"), action: {
                    vm.logout()
                }), .cancel()])
            }
        }

    
    private func loadImageFromFirebase(){
        self.imageURL = URL(string: vm.profile?.profileImageUrl ?? "")
    }
    
    
    private func actionSheet() {
            let text = "Hey! I’m trying out this super cool app called Yolk where you can meet new ppl in the community! Link to download: \(self.download_url)"
           let activityVC = UIActivityViewController(activityItems: [text] as [AnyObject], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    private func updateGoal(){
        let ref = FirebaseManager.shared.firestore.collection("users").document(vm.uid)
        if (vm.profile?.goal == "friend") {
            
            vm.profile?.goal = "career"
            ref.updateData([
                "profile.goal": "career"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    
                    vm.fetchCurrentUser()
                }
            }
        }
        else {
            vm.profile?.goal = "friend"
            ref.updateData([
                "profile.goal": "friend"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    
                    vm.fetchCurrentUser()
                }
            }
        }
    }
    
    private func updateBio(){
        let ref = FirebaseManager.shared.firestore.collection("users").document(vm.uid)
        vm.profile?.bio = self.bio
        ref.updateData([
            "profile.bio": self.bio
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                
                vm.fetchCurrentUser()
            }
        }
            

    }
    
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
