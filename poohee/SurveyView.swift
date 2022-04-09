//
//  HomeView.swift
//  poohee
//
//  Created by Yuntao Li on 4/2/22.
//

import SwiftUI


class SurveyViewModel: ObservableObject {
    
    @Published var uid = ""
    
    @Published var error_message = ""
    
    @Published var question_now = 0
    
    @Published var isCurrentlyLoggedOut = true
    
    @Published var isProfileFinished = false
    
    @Published var user: User?
    
    @Published var profile: Profile?
    
    private var db = FirebaseManager.shared.firestore
    
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
            
            
            
            if (profile.isEmpty) {
                self.isProfileFinished = false
            } else {
                
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
                
                self.isProfileFinished = true
            }
        }
    }
    
    public func signOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct SurveyView: View {
    
    @ObservedObject private var vm = SurveyViewModel()
    @State private var createProfileStage = 0
    @State private var friend = false
    @State private var career = false
    @State private var first = ""
    @State private var last = ""
    @State private var gender = "Select"
    @State private var grad_year = "Select"
    @State private var first_major = "Select"
    @State private var second_major = "Select"
    @State private var hobbies = []
    @State private var career_interests = [false, false,false, false,false, false,false, false,false, false,false, false]
    @State private var religious = "Select"
    @State private var political = "Select"
    @State private var questionnaire = [Int](repeating: 0, count: 17)
    
    @State private var first_major_isExpanded = false
    @State private var second_major_isExpanded = false
    @State private var gender_isExpanded = false
    @State private var grad_isExpanded = false
    @State private var political_isExpanded = false
    @State private var religious_isExpanded = false
    
    
    let grad_year_option = ["Select",
                            "2022",
                            "2023",
                            "2024",
                            "2025"]
    
    let gender_option = ["Select","Female", "Male", "Non-binary", "Transgender", "Intersex", "Not listed", "I prefer not to say"]
    
    
    let majors_option = ["Select",
                         "Africana Studies",
                         "Anthropology",
                         "Applied Mathematics & Statistics",
                         "Archaeology",
                         "Behavioral Biology",
                         "Biology",
                         "Biomedical Engineering",
                         "Biophysics",
                         "Chemical & Biomolecular Engineering",
                         "Chemistry",
                         "Civil Engineering",
                         "Classics",
                         "Cognitive Science",
                         "Computer Engineering",
                         "Computer Science",
                         "Earth & Planetary Sciences",
                         "East Asian Studies",
                         "Economics",
                         "Electrical Engineering",
                         "Engineering Mechanics",
                         "English",
                         "Environmental Engineering",
                         "Environmental Science",
                         "Environmental Studies",
                         "Film & Media Studies",
                         "French",
                         "General Engineering",
                         "German",
                         "History",
                         "History of Art",
                         "History of Science, Medicine & Technology",
                         "Interdisciplinary Studies",
                         "International Studies",
                         "Italian",
                         "Materials Science & Engineering",
                         "Mathematics",
                         "Mechanical Engineering",
                         "Medicine, Science & the Humanities",
                         "Molecular & Cellular Biology",
                         "Natural Sciences",
                         "Near Eastern Studies",
                         "Neuroscience",
                         "Philosophy",
                         "Physics",
                         "Political Science",
                         "Psychology",
                         "Public Health Studies",
                         "Romance Languages",
                         "Sociology",
                         "Spanish",
                         "Systems Engineering",
                         "Writing Seminars"]
    
    let political_option = ["Select", "Democratic", "Independent", "Republican", "Other Affiliation", "Unaffiliated"]
    
    let religious_option = ["Select","Buddhist", "Christian", "Hindu", "Muslim", "Sikh","Other religion", "Unaffiliated"]
    
    @State var question_list = ["I like to stick with people I know at social events","I feel comfortable striking up conversations with strangers","The best thing to do after an exam is PARTY","I like to be the center of attention","I have cried over movie scenes","I get sentimental over small things","I think with my head, not my heart", "I am a straight shooter", "I like to organize my schedule with tools", "Real traveling isn’t planned", "I keep myself busy with tasks", "I procrastinate more than others around me", "I wonder what the meaning of life is sometimes", "I like to analyze different interpretations of fiction", "I like to talk about theoretical things with my friends", "I watch movies for the experience not the meaning behind them", "Mistakes I made a long time ago still bother me"]
    
    @State var card_x : [CGFloat] = [CGFloat](repeating: 0, count: 17)
    @State var current_question_num = 16
    @State var isShowingPhotoPicker = false
    @State var image: UIImage?
    
    var body: some View {
        
        if(vm.isCurrentlyLoggedOut) {
            WelcomeView(didCompleteLoginProcess: {
                self.vm.isCurrentlyLoggedOut = false
            })
        }
        
        else if (vm.isProfileFinished) {
            
            HomeView()
            /*VStack{
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
            }*/
        }
        else {

            
            if (createProfileStage == 0) {
                VStack(spacing:50) {
                    Text("What brings you to Yolk?")
                        .foregroundColor(Color.primaryColor)
                        .font(.system(size: 36))
                        .padding(.bottom, 50)
                    
                    Button {
                        friend.toggle()
                    }label: {
                        HStack{
                            

                                Spacer()
                                Text("Make New Friends!")
                                    .foregroundColor(.white)
                                    .font(.system(size: 26))
                                Spacer()

                            
                        }.padding(.vertical, 65)
                            .background(Color.primaryColor)
                            .cornerRadius(15)
                            .border(Color.orange, width: friend ? 5 : 0)
                    }
                    
                    
                    
                    Button {
                        career.toggle()
                    }label: {
                        HStack{
                        
                                Spacer()
                                Text("Meet Like-minded People (Career/Academic)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 26))
                                Spacer()
                            
                        }.padding(.vertical, 50)
                            .background(Color.secondaryColor)
                            .cornerRadius(15)
                            .border(Color.purple, width: career ? 5 : 0)
                        
                    }
                    
                    Button {
                        nextStage()
                    }label: {
                        Text("> Next")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26))
                    }
                    .padding(.leading, 250)
                    .padding(.top, 100)
                }
                .padding(.horizontal, 50)
                
                
            }
            if(createProfileStage == 1) {
                
                ScrollView {
                    VStack{
                        
                        Button {
                            prevStage()
                        }label: {
                            Text("< Back")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                        }
                        .padding(.trailing, 250)
                        .padding(.bottom, 100)
                        
                        
                        Text("Tell us a little about yourself")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size: 36))
                            .padding(.bottom, 50)
                        
                        Group {
                            Text("NAME")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 20))
                                .padding(.trailing, 270)
                        
                            HStack{
                                TextField("First", text: $first)
                                    .font(.system(size: 18))
                                    .multilineTextAlignment(.center)
                                .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
                                .cornerRadius(10)
                                
                                TextField("Last", text: $last)
                                    .font(.system(size: 18))
                                    .multilineTextAlignment(.center)
                                .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
                                .cornerRadius(10)
                            }
                            
                            Text("Only your first name will be shared")
                                .foregroundColor(Color(.init(white: 0, alpha: 0.2)))
                                .font(.system(size: 10))
                                .padding(.trailing, 155)
                                .padding(.bottom, 5)
                                
                            Group {
                                Text("GENDER")
                                    .foregroundColor(Color.primaryColor)
                                    .font(.system(size: 20))
                                    .padding(.trailing, 250)
                                
                                DisclosureGroup("\(gender)", isExpanded: $gender_isExpanded) {
                                    ScrollView {
                                        
                                        VStack {
                                            ForEach(gender_option, id: \.self) {
                                                gender in
                                                Text("\(gender)")
                                                    .foregroundColor(Color.gray)
                                                
                                                    .onTapGesture {
                                                        withAnimation{self.gender_isExpanded.toggle()}
                                                        self.gender = gender
                                                    }
                                                    
                                            }
                                        }
                                    }.frame(height: 150)
                                }
                                    .foregroundColor(Color.gray)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.primaryColor, lineWidth: 1)
                                        )
                                    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                    .onTapGesture {
                                        withAnimation{self.gender_isExpanded.toggle()}
                                    }
                                    .padding(.top, -10)
                                    .padding(.bottom, 5)
                            }
                            
                            Group {
                                Text("GRADUATION YEAR")
                                    .foregroundColor(Color.primaryColor)
                                    .font(.system(size: 20))
                                    .padding(.trailing, 150)

                                DisclosureGroup("\(self.grad_year)", isExpanded: $grad_isExpanded) {
                                    ScrollView {
                                        
                                        VStack {
                                            ForEach(grad_year_option, id: \.self) {
                                                grad in
                                                Text("\(grad)")
                                                    .foregroundColor(Color.gray)
                                                    .onTapGesture {
                                                        withAnimation{self.grad_isExpanded.toggle()}
                                                        grad_year = grad
                                                    }
                                            }
                                        }
                                    }.frame(height: 150)
                                }
                                    .foregroundColor(Color.gray)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.primaryColor, lineWidth: 1)
                                        )
                                    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                    .onTapGesture {
                                        withAnimation{self.grad_isExpanded.toggle()}
                                    }
                                    .padding(.top, -10)
                                    .padding(.bottom, 5)
                            }
                            
                            Group {
                                Text("FIRST MAJOR")
                                    .foregroundColor(Color.primaryColor)
                                    .font(.system(size: 20))
                                    .padding(.trailing, 202)
                                
                                
                                DisclosureGroup("\(first_major)", isExpanded: $first_major_isExpanded) {
                                    ScrollView {
                                        
                                        VStack {
                                            ForEach(majors_option, id: \.self) {
                                                major in
                                                Text("\(major)")
                                                    .foregroundColor(Color.gray)
                                                
                                                    .onTapGesture {
                                                        withAnimation{self.first_major_isExpanded.toggle()}
                                                        first_major = major
                                                    }
                                                    
                                            }
                                        }
                                    }.frame(height: 150)
                                }
                                    .foregroundColor(Color.gray)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.primaryColor, lineWidth: 1)
                                        )
                                    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                    .onTapGesture {
                                        withAnimation{self.first_major_isExpanded.toggle()}
                                    }
                                    .padding(.top, -10)
                                    .padding(.bottom, 5)

                            }
                            
                            Group {
                                Text("SECOND MAJOR")
                                    .foregroundColor(Color.primaryColor)
                                    .font(.system(size: 20))
                                    .padding(.trailing, 175)
                                
                                DisclosureGroup("\(second_major)", isExpanded: $second_major_isExpanded) {
                                    ScrollView {
                                        
                                        VStack {
                                            ForEach(majors_option, id: \.self) {
                                                major in
                                                Text("\(major)")
                                                    .foregroundColor(Color.gray)
                                                
                                                    .onTapGesture {
                                                        withAnimation{self.second_major_isExpanded.toggle()}
                                                        second_major = major
                                                    }
                                                    
                                            }
                                        }
                                    }.frame(height: 150)
                                }
                                    .foregroundColor(Color.gray)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.primaryColor, lineWidth: 1)
                                        )
                                    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                    .onTapGesture {
                                        withAnimation{self.second_major_isExpanded.toggle()}
                                    }
                                    .padding(.top, -10)
                                    .padding(.bottom, 5)

                            }
                            }
                            
                            
                        
                        
                        
                        Button {
                            nextStage()
                        }label: {
                            Text("> Next")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                        }
                        .padding(.leading, 250)
                        .padding(.top, 100)
                        
                    }.padding(.horizontal, 50)
                }
                
                
            }
            if(createProfileStage == 2) {
                
                ScrollView {
                    VStack{
                        
                        Button {
                            prevStage()
                        }label: {
                            Text("< Back")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                        }
                        .padding(.trailing, 250)
                        .padding(.bottom, 50)
                        
                        
                        Text("Are any of these things also really important to you?")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size: 36))
                            .padding(.bottom, 20)
                        
                    
                        HStack {
                            Text("HOBBIES")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 20))
                            
                            Text("(optional)")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 10))
                                .padding(.top, 5)
                        }.padding(.trailing, 190)
                        
                        HStack {
                            Text("CAREER INTERESTS")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 20))
                            
                            Text("(optional)")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 10))
                                .padding(.top, 5)
                        }.padding(.trailing, 90)
                        
                        
                        Group {
                            HStack {
                                Button {
                                    career_interests[0].toggle()
                                    
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Pre-Med")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)
                                        .background(career_interests[0] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                                
                                Button {
                                    career_interests[1].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Finance")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)
                                        .background(career_interests[1] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                                
                                Button {
                                    career_interests[2].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Consulting")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)
                                        .background(career_interests[2] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                            }
                            
                            HStack {
                                Button {
                                    career_interests[3].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Art/Design")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)
                                        .background(career_interests[3] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                                
                                Button {
                                    career_interests[4].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Pre-Law")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)
                                        .background(career_interests[4] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                                
                                Button {
                                    career_interests[5].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Tech")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)                                        .background(career_interests[5] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                            }
                            
                            HStack {
                                Button {
                                    career_interests[6].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Engineering")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)                                        .background(career_interests[6] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                                
                                Button {
                                    career_interests[7].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Business")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)                                        .background(career_interests[7] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                                
                                Button {
                                    career_interests[8].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Research")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)                                        .background(career_interests[8] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                            }
                            
                            HStack {
                                Button {
                                    career_interests[9].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Grad School")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)                                        .background(career_interests[9] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                                
                                Button {
                                    career_interests[10].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Government")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)                                        .background(career_interests[10] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                                
                                Button {
                                    career_interests[11].toggle()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Healthcare")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))

                                        Spacer()
                                    }.padding(.vertical)                                        .background(career_interests[11] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(24)
                                }
                            }
                        }
                        
                        HStack {
                            Text("RELIGIOUS AFFILIATION")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 20))
                            
                            Text("(optional)")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 10))
                                .padding(.top, 5)
                        }.padding(.trailing, 50)
                        
                        DisclosureGroup("\(religious)", isExpanded: $religious_isExpanded) {
                            ScrollView {
                                
                                VStack {
                                    ForEach(religious_option, id: \.self) {
                                        religious in
                                        Text("\(religious)")
                                            .foregroundColor(Color.gray)
                                        
                                            .onTapGesture {
                                                withAnimation{self.religious_isExpanded.toggle()}
                                                self.religious = religious
                                            }
                                            
                                    }
                                }
                            }.frame(height: 150)
                        }
                            .foregroundColor(Color.gray)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.primaryColor, lineWidth: 1)
                                )
                            .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                            .onTapGesture {
                                withAnimation{self.religious_isExpanded.toggle()}
                            }
                            .padding(.top, -10)
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("POLITICAL AFFILIATION")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 20))
                            
                            Text("(optional)")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 10))
                                .padding(.top, 5)
                        }.padding(.trailing, 50)
                        
                        DisclosureGroup("\(political)", isExpanded: $political_isExpanded) {
                            ScrollView {
                                
                                VStack {
                                    ForEach(political_option, id: \.self) {
                                        political in
                                        Text("\(political)")
                                            .foregroundColor(Color.gray)
                                        
                                            .onTapGesture {
                                                withAnimation{self.political_isExpanded.toggle()}
                                                self.political = political
                                            }
                                            
                                    }
                                }
                            }.frame(height: 150)
                        }
                            .foregroundColor(Color.gray)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.primaryColor, lineWidth: 1)
                                )
                            .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                            .onTapGesture {
                                withAnimation{self.political_isExpanded.toggle()}
                            }
                            .padding(.top, -10)
                            .padding(.bottom, 5)
                        
                        Button {
                            nextStage()
                        }label: {
                            Text("> Next")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                        }
                        .padding(.leading, 250)
                        .padding(.top, 100)
                        
                    }.padding(.horizontal, 50)
                }
                
            }
            if (createProfileStage == 3) {
                
                    
                    VStack {
                        Button {
                            prevStage()
                        }label: {
                            Text("< Back")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                        }
                        .padding(.trailing, 250)
                        .padding(.bottom, 50)
                        
                        Text("Nice to Meet You, \(self.first)!")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size: 36))
                            .padding(.bottom, 50)
                        
                        
                        Group{
                            Text("Let’s now see who might share your unique tastes & sensibilities").foregroundColor(Color.gray)
                                .font(.system(size: 24))
                                .padding(.bottom, 50)
                            
                            HStack{
                                Text("If you").foregroundColor(Color.gray)
                                Text("Agree").foregroundColor(Color.primaryColor)
                                Text("--> Swipe").foregroundColor(Color.gray)
                                Text("Right!").foregroundColor(Color.primaryColor)
                                
                                
                            }.font(.system(size: 18))
                            
                            HStack{
                                Text("If you").foregroundColor(Color.gray)
                                Text("Disagree").foregroundColor(Color.primaryColor)
                                Text("--> Swipe").foregroundColor(Color.gray)
                                Text("Left!").foregroundColor(Color.primaryColor)
                            }.font(.system(size: 18))
                        }.padding(.horizontal, 30)
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding(.vertical, 40)
                        
                        Button {
                            nextStage()
                        }label: {
                            Text("> I'M READY")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 24))
                        }
                        .padding(.leading, 180)
                        .padding(.top, 80)
                        
                    }.padding(.horizontal, 50)
                    
            }
            if (createProfileStage == 4) {
                

                    ZStack {
                        
                        
                        
                        ForEach(0..<17, id: \.self) {i in
                            Card(text: self.$question_list[(question_list.count-1-i)])
                                .offset(x: self.card_x[i])
                                .gesture(DragGesture()
                                        .onChanged({(value) in
                                            
                                            self.card_x[i] = value.translation.width

                                        })
                                        .onEnded({(value) in
                                            
                                            if value.translation.width > 0 {
                                                
                                                if value.translation.width > 200 {
                                                    self.card_x[i] = 600
                                                    current_question_num -= 1
                                                    
                                                    self.questionnaire[i] = 1
                                                } else {
                                                    self.card_x[i] = 0
                                                }
                                                
                                            } else {
                                                if value.translation.width < -200 {
                                                    self.card_x[i] = -600
                                                    current_question_num -= 1
                                                    self.questionnaire[i] = -1
                                                } else {
                                                    self.card_x[i] = 0
                                                }
                                                
                                            }
                                            
                                        })
                                )
                        }
                        
                        VStack {
                            
                            if current_question_num != 16 {
                                Text("< Back")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 26))
                                    .padding(.trailing, 250)
                                    .onTapGesture{
                                        self.card_x[current_question_num+1] = 0
                                        current_question_num += 1
                                        self.questionnaire[current_question_num] = 0
                                        
                                    }
                            }

                                
                            
                            Image("logo")
                                .resizable()
                                .frame(width: 200, height: 200, alignment: .center)
                                .padding(.top, 400)
                            
                            if current_question_num != 0{
                                Text("Skip")
                                    .font(.system(size: 26))
                                    .padding(.top, 100)
                                    .foregroundColor(Color.gray)
                                    .onTapGesture{
                                        self.card_x[current_question_num] = 600
                                        self.questionnaire[current_question_num] = 0
                                        current_question_num -= 1
                                    }
                            }
                            
                            if current_question_num == 0{
                                Text("> Next")
                                    .font(.system(size: 26))
                                    .padding(.top, 100)
                                    .foregroundColor(Color.gray)
                                    .onTapGesture{
                                        handleSubmit()
                                    }
                            }

                                
                        }
                        

                    }
                
                
            }
            if (createProfileStage == 5) {
                
                
                VStack {
                    
                    
                    
                    Button {
                        handleSubmit()
                    } label: {
                        HStack{
                                Spacer()
                                Text("Done")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                                Spacer()

                            
                        }
                            .background(Color.primaryColor)
                            .cornerRadius(24)
                    }.padding(.leading, 250)
                    
                    
                    Button {
                        isShowingPhotoPicker.toggle()
                    } label: {
                        
                        VStack{
                            if let image = self.image {
                                Image(uiImage:image)
                                    .resizable()
                                    .frame(width: 128, height: 128)
                                    .scaledToFill()
                                    .cornerRadius(64)
                            }
                            else {
                                Image("plus_photo")
                                    .font(.system(size: 64))
                                    .padding()
                            }
                        }

                    }
                    
                    
                    

                        
                    
                }.padding(.horizontal, 50)
                    .fullScreenCover(isPresented: $isShowingPhotoPicker, onDismiss: nil) {
                        ImagePicker(image: $image)
                    }
                    
                    
            }
            
            
        }
    }
    
    
    private func nextStage() {
        
        if (createProfileStage == 0) {
            if (!friend && !career) {
                return
            }
        }
        createProfileStage = createProfileStage + 1
    }
    
    private func prevStage() {
        createProfileStage = createProfileStage - 1
    }
    

    
    private func handleSubmit() {
        
        let ref = FirebaseManager.shared.firestore.collection("users").document(vm.uid)
        
//        let storage_ref = FirebaseManager.shared.storage.reference(withPath: vm.uid)
//        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
//        storage_ref.putData(imageData, metadata: nil) { metadata, err in
//            if let err = err {
//                print("Failed to push image to Storage: \(err)")
//                return
//            }
//
//            storage_ref.downloadURL { url, err in
//                if let err = err {
//                    print("Failed to retrieve downloadURL: \(err)")
//                    return
//                }
//
//                ref.updateData([
//                    "profileImageUrl": url?.absoluteString ?? ""
//                ]) { err in
//                    if let err = err {
//                        print("Error updating document: \(err)")
//                    } else {
//                        FirebaseManager.shared.auth.currentUser?.reload() {
//                            error in
//                            if let error = error {
//                                print("reload failed" + error.localizedDescription)
//                                return
//                            }
//                        }
//                    }
//                }
//
//                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
//            }
//        }
        
        var profile: [String: Any] = [:]
        
        profile["first_name"] = self.first
        profile["gender"] = self.gender
        profile["goal"] = friend ? "friend" : "career"
        profile["graduation_year"] = self.grad_year
        profile["last_name"] = self.last
        profile["political"] = self.political
        profile["religious"] = self.religious
        
        profile["career_interests"] = self.career_interests
        profile["hobbies"] = self.hobbies
        profile["majors"] = [self.first_major, self.second_major]
        profile["questionnaire"] = self.questionnaire
        


        // Set the "capital" field of the city 'DC'
        ref.updateData([
            "profile": profile
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                FirebaseManager.shared.auth.currentUser?.reload() {
                    error in
                    if let error = error {
                        print("reload failed" + error.localizedDescription)
                        return
                    }
                    vm.fetchCurrentUser()
            }
        }
    }
        
    }

}

struct Card: View {
    @Binding var text: String
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))
                .padding(.bottom, 300)
                .padding(.horizontal, 50)
                
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
          )
          .background(Color.white)
            
        
    }
}


struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
