//
//  HomeView.swift
//  poohee
//
//  Created by Yuntao Li on 4/2/22.
//

import SwiftUI
import PermissionsSwiftUINotification
import PermissionsSwiftUIPhoto


struct SurveyView: View {
    
    @ObservedObject var vm: HomeViewModel
    @Binding var firstTime: Bool
    
    
    @State private var createProfileStage = 3
    
    @State private var career_interests = [Bool](repeating: false, count: 15)
    
    @State private var friend = false
    @State private var career = false
    @State private var first = ""
    @State private var last = ""
    @State private var gender = "Select"
    @State private var grad_year = "Select"
    @State private var first_major = "Select"
    @State private var second_major = "Select"
    @State private var hobbies = [Bool](repeating: false, count: 120)
   
    @State private var religious = "Select"
    @State private var political = "Select"
    @State private var questionnaire = [Int](repeating: 0, count: 18)
    @State private var showPushNotificationModal = false
    
    @State private var first_major_isExpanded = false
    @State private var second_major_isExpanded = false
    @State private var gender_isExpanded = false
    @State private var age_isExpanded = false
    @State private var grad_isExpanded = false
    @State private var political_isExpanded = false
    @State private var religious_isExpanded = false
    @State private var show_agree = false
    @State private var show_disagree = false
    @State private var hobbie_count = 0
    
    
    @State private var career_options = ["Healthcare", "Engineering", "Academia","Law","Consulting","Marketing","Journalism","Finance","Tech","StartUps","Arts","Nursing","Education","Government","Military"]
    
    let grad_year_option = ["Select",
                            "2022",
                            "2023",
                            "2024",
                            "2025"]
    
    let gender_option = ["Select","Female", "Male", "Non-binary", "Transgender", "Intersex", "Not listed", "I prefer not to say"]
    
    
    let majors_option = ["Select",
                         "Undecided",
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
    
    let political_option = ["Select", "Democratic", "Republican", "Libertarian", "Socialist", "Other", "Unaffiliated"]
    
    let religious_option = ["Select", "Christian", "Jewish", "Buddhist", "Hindu", "Muslim", "Sikh","Other", "Unaffiliated"]
    
    @State private var question_list = [
        "I like to stick with people I know at social events",
        "I think with my head, not my heart",
        "I like to organize my schedule with tools",
        "The best thing to do after an exam is PARTY",
        "Real traveling isn’t planned",
        "I have cried over movie scenes",
        "Men and women can just be friends",
        "It’s important for me to live up to societal expectations",
        "I wonder what the meaning of life is sometimes",
        "I am a straight shooter",
        "I like to take the risks that make life exciting",
        "I like to talk about theoretical things with my friends",
        "It’s important for me to have the power that money can bring",
        "I keep myself busy with tasks",
        "It’s important to follow rules even when no one is watching",
        "It’s important to not make anyone mad",
        "I like to analyze different interpretations of fiction",
        "I want to start a firm someday"]
    
    @State private var card_x : [CGFloat] = [CGFloat](repeating: 0, count: 18)
    @State private var current_question_num = 17
    @State private var isShowingPhotoPicker = false
    @State private var image: UIImage?
    @State private var show_class = true
    @State private var bio = ""
    @State private var sportIsExpanded = false
    @State private var filmIsExpanded = false
    @State private var musicIsExpanded = false
    @State private var socialIsExpanded = false
    @State private var artIsExpanded = false
    @State private var fashionIsExpanded = false
    @State private var lifestyleIsExpanded = true
    @State private var requiredmsg1 = ""
    @State private var requiredmsg2 = ""
    @State private var addProfileImageMsg = ""
    
    
    let lifestyleIndex = 0
    let sportIndex = 20
    let filmIndex = 40
    let musicIndex = 60
    let artIndex = 80
    let socialIndex = 100
    
    
    var careerSelector: some View{
        VStack{
            HStack {
                Button {
                    career_interests[0].toggle()
                    
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[0])
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
                        Text(career_options[1])
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
                        Text(career_options[2])
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
                        Text(career_options[3])
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
                        Text(career_options[4])
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
                        Text(career_options[5])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[5] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
            }
            
            HStack {
                Button {
                    career_interests[6].toggle()
                    
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[6])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[6] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
                
                Button {
                    career_interests[7].toggle()
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[7])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[7] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
                
                Button {
                    career_interests[8].toggle()
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[8])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[8] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
            }
            
            HStack {
                Button {
                    career_interests[9].toggle()
                    
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[9])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[9] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
                
                Button {
                    career_interests[10].toggle()
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[10])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[10] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
                
                Button {
                    career_interests[11].toggle()
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[11])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[11] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
            }
            
            HStack {
                Button {
                    career_interests[12].toggle()
                    
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[12])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[12] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
                
                Button {
                    career_interests[13].toggle()
                }label: {
                    HStack{
                        Spacer()
                        VStack{
                            Text("Government/")
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                            
                            Text("NGOs")
                                .foregroundColor(.black)
                                .font(.system(size: 12))

                        }
                        Spacer()
                    }
                    .padding(.vertical, 9)
                        .background(career_interests[13] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
                
                Button {
                    career_interests[14].toggle()
                }label: {
                    HStack{
                        Spacer()
                        Text(career_options[14])
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                    }.padding(.vertical)
                        .background(career_interests[14] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                        .cornerRadius(24)
                }
            }
        }
    }
    
    var body: some View {
        
        if(vm.isCurrentlyLoggedOut) {
            WelcomeView(didCompleteLoginProcess: {
                self.vm.fetchCurrentUser()
                self.vm.fetchRecentMessages()
                self.vm.isCurrentlyLoggedOut = false
                
            })
        }
        else {
            if (createProfileStage == 0) {
                VStack(spacing:50) {
                    Text("What brings you to Yolk?")
                        .foregroundColor(Color.primaryColor)
                        .font(.system(size: 36))
                        .padding(.vertical)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        friend = true
                        nextStage()
                    }label: {
                        HStack{
                            
                            Spacer()
                            Text("Make New Friends!")
                                .foregroundColor(.white)
                                .font(.system(size: 28))
                            Spacer()
                            
                            
                        }.padding(.vertical, 65)
                            .background(Color.primaryColor)
                            .cornerRadius(15)
                    }
                    
                    
                    
                    Button {
                        career = true
                        nextStage()
                    }label: {
                        HStack{
                            
                            Spacer()
                            Text("Expand My Network!")
                                .foregroundColor(.white)
                                .font(.system(size: 28))
                            Spacer()
                            
                        }.padding(.vertical, 65)
                            .background(Color.secondaryColor)
                            .cornerRadius(15)
                        
                    }
                    
                }
                .padding(.horizontal, 50)
            }
            if(createProfileStage == 1) {
                VStack{
                    Button {
                        friend = true
                        career = false
                        prevStage()
                    }label: {
                        Text("< Back")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    
                    VStack{
                        
                        Text("Tell us a little about yourself")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size: 36))
                            .padding(.bottom)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(showsIndicators: false) {
                            Group {
                                Text("NAME")
                                    .foregroundColor(Color.primaryColor)
                                    .font(.system(size: 20))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                
                                HStack{
                                    TextField("First", text: $first)
                                        .font(.system(size: 18))
                                        .multilineTextAlignment(.center)
                                        .background(Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(10)
                                    
                                    TextField("Last", text: $last)
                                        .font(.system(size: 18))
                                        .multilineTextAlignment(.center)
                                        .background(Color(.init(white: 0, alpha: 0.05)))
                                        .cornerRadius(10)
                                }
                                
                                Text("Only your first name will be shared")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 10))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 5)
                                
                                Group {
                                    Text("GENDER")
                                        .foregroundColor(Color.primaryColor)
                                        .font(.system(size: 20))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    
                                    DisclosureGroup("\(gender)", isExpanded: $gender_isExpanded) {
                                        ScrollView(showsIndicators: false) {
                                            
                                            VStack {
                                                ForEach(gender_option, id: \.self) {
                                                    gender in
                                                    Text("\(gender)")
                                                        .foregroundColor(Color.gray)
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                                        .onTapGesture {
                                                            withAnimation{self.gender_isExpanded.toggle()}
                                                            self.gender = gender
                                                        }
                                                }
                                            }
                                        }.frame(height: 150)
                                    }
                                    .foregroundColor(Color.gray)
                                    .padding(.leading, 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(Color.primaryColor, lineWidth: 1)
                                    )
                                    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                    .onTapGesture {
                                        withAnimation{self.gender_isExpanded.toggle()}
                                    }
                                    .padding(.bottom, 5)
                                }
                                
                                
                                Group {
                                    Text("GRADUATION YEAR")
                                        .foregroundColor(Color.primaryColor)
                                        .font(.system(size: 20))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    
                                    DisclosureGroup("\(self.grad_year)", isExpanded: $grad_isExpanded) {
                                        ScrollView(showsIndicators: false) {
                                            
                                            VStack {
                                                ForEach(grad_year_option, id: \.self) {
                                                    grad in
                                                    Text("\(grad)")
                                                        .foregroundColor(Color.gray)
                                                        .onTapGesture {
                                                            withAnimation{self.grad_isExpanded.toggle()}
                                                            grad_year = grad
                                                        }
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                                }
                                            }
                                        }
                                        .frame(height: 110)
                                    }
                                    .foregroundColor(Color.gray)
                                    .padding(.leading, 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(Color.primaryColor, lineWidth: 1)
                                    )
                                    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                    .onTapGesture {
                                        withAnimation{self.grad_isExpanded.toggle()}
                                    }
                                    .padding(.bottom, 5)
                                }
                                
                                Group {
                                    HStack {
                                        Text("PRIMARY MAJOR")
                                            .foregroundColor(Color.primaryColor)
                                            .font(.system(size: 20))
                                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    DisclosureGroup("\(first_major)", isExpanded: $first_major_isExpanded) {
                                        ScrollView(showsIndicators: false)  {
                                            
                                            VStack {
                                                ForEach(majors_option, id: \.self) {
                                                    major in
                                                    Text("\(major)")
                                                        .foregroundColor(Color.gray)
                                                    
                                                        .onTapGesture {
                                                            withAnimation{self.first_major_isExpanded.toggle()}
                                                            first_major = major
                                                        }
                                                        .multilineTextAlignment(.center)
                                                    
                                                }
                                            }
                                        }.frame(height: 150)
                                    }
                                    .foregroundColor(Color.gray)
                                    .padding(.leading, 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(Color.primaryColor, lineWidth: 1)
                                    )
                                    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                    .onTapGesture {
                                        withAnimation{self.first_major_isExpanded.toggle()}
                                    }
                                    .padding(.bottom, 5)
                                    
                                }
                                
                                Group {
                                    HStack {
                                        Text("SECONDARY MAJOR")
                                            .foregroundColor(Color.primaryColor)
                                            .font(.system(size: 20))
                                        
                                        Text("(optional)")
                                            .foregroundColor(Color.gray)
                                            .font(.system(size: 10))
                                            .padding(.top, 5)
                                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    DisclosureGroup("\(second_major)", isExpanded: $second_major_isExpanded) {
                                        ScrollView(showsIndicators: false) {
                                            
                                            VStack {
                                                ForEach(majors_option, id: \.self) {
                                                    major in
                                                    Text("\(major)")
                                                        .foregroundColor(Color.gray)
                                                    
                                                        .onTapGesture {
                                                            withAnimation{self.second_major_isExpanded.toggle()}
                                                            second_major = major
                                                        }
                                                        .multilineTextAlignment(.center)
                                                    
                                                }
                                            }
                                        }.frame(height: 150)
                                    }
                                    .foregroundColor(Color.gray)
                                    .padding(.leading, 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(Color.primaryColor, lineWidth: 1)
                                    )
                                    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                    .onTapGesture {
                                        withAnimation{self.second_major_isExpanded.toggle()}
                                    }
                                    .padding(.bottom, 5)
                                    
                                }
                            }
                        }
                        
                        
                        
                        
                        ZStack{
                            Text("\n").foregroundColor(Color.white)
                                .font(.system(size: 20))
                            
                            Text(self.requiredmsg1).foregroundColor(Color.primaryColor)
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            if (self.first=="" || self.last=="" || self.gender=="Select" || self.first_major == "Select") {
                                self.requiredmsg1 = "Please fill out all required fields"
                            }
                            else {
                                nextStage()
                                self.requiredmsg1 = ""
                            }
                            
                            
                        }label: {
                            Text("> Next")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        
                        
                        
                    }
                    .padding(.horizontal, 50)
                    .background(Color.white)
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                
                
                
                
                
            }
            if(createProfileStage == 2) {
                
                
                VStack{
                    
                    Button {
                        prevStage()
                    }label: {
                        Text("< Back")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    VStack{
                        Text("Are any of these also important?")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size: 36))
                            .padding(.bottom, 20)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        
                        HStack {
                            Text("CAREER INTERESTS")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 20))
                            
                            Text("(optional)")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 10))
                                .padding(.top, 5)
                        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                            careerSelector
                                
                            HStack {
                                Text("RELIGIOUS AFFILIATION")
                                    .foregroundColor(Color.primaryColor)
                                    .font(.system(size: 20))
                                
                                Text("(optional)")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 10))
                                    .padding(.top, 5)
                            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            DisclosureGroup("\(religious)", isExpanded: $religious_isExpanded) {
                                ScrollView(showsIndicators: false) {
                                    
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
                            .padding(.leading, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.primaryColor, lineWidth: 1)
                            )
                            .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                            .onTapGesture {
                                withAnimation{self.religious_isExpanded.toggle()}
                            }
                            .padding(.bottom, 5)
                            
                            HStack {
                                Text("POLITICAL AFFILIATION")
                                    .foregroundColor(Color.primaryColor)
                                    .font(.system(size: 20))
                                
                                Text("(optional)")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 10))
                                    .padding(.top, 5)
                            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            DisclosureGroup("\(political)", isExpanded: $political_isExpanded) {
                                ScrollView(showsIndicators: false) {
                                    
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
                            .padding(.leading, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.primaryColor, lineWidth: 1)
                            )
                            .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                            .onTapGesture {
                                withAnimation{self.political_isExpanded.toggle()}
                            }
                            .padding(.bottom, 5)
                        }
                        
                        
                        ZStack{
                            Text("\n").foregroundColor(Color.white)
                                .font(.system(size: 20))
                            
                            Text(self.requiredmsg2).foregroundColor(Color.primaryColor)
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                        
                        Button {

                            nextStage()
                            
                        }label: {
                            Text("> Next")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        
                    }.padding(.horizontal, 50)
                    
                    
                }
                
                
            }
            if (createProfileStage == 3) {
                VStack{
                    Button {
                        prevStage()
                    }label: {
                        Text("< Back")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    VStack {
                        Text("Nice to Meet You, \(self.first)!")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size: 32))
                            .padding(.bottom)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        
                        VStack(alignment:.leading, spacing: 20){
                            Text("Let’s now see who might share your unique sensibilities").foregroundColor(Color.gray)
                                .font(.system(size: 24))
                                .padding(.vertical)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                
                            
                            HStack{
                                Text("If you").foregroundColor(Color.gray)
                                Text("Agree").foregroundColor(Color.primaryColor)
                                
                                
                            }.font(.system(size: 24))
                            
                            HStack{
                                Spacer()
                                Text("--->").foregroundColor(Color.primaryColor)
                                Text("Swipe").foregroundColor(Color.gray)
                                Text("Right!").foregroundColor(Color.primaryColor)
                            }.font(.system(size: 24))
                            
                            HStack{
                                Text("If you").foregroundColor(Color.gray)
                                Text("Disagree").foregroundColor(Color.primaryColor)
                            }.font(.system(size: 24))
                            
                            HStack{
                                Spacer()
                                Text("<---").foregroundColor(Color.primaryColor)
                                Text("Swipe").foregroundColor(Color.gray)
                                Text("Left!").foregroundColor(Color.primaryColor)
                            }.font(.system(size: 24))
                            
                            
                        }
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .padding(.vertical)
                        
                        Spacer()
                        
                        Button {
                            nextStage()
                        }label: {
                            Text("> I'M READY")
                                .foregroundColor(Color.primaryColor)
                                .font(.system(size: 24))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, -50)
                        .padding()
                    }
                    .padding(.horizontal, 50)
                }
            }
            if (createProfileStage == 4) {
                
                
                ZStack {
                    
                    
                    
                    ForEach(0..<18, id: \.self) {i in
                        Card(text: self.$question_list[(question_list.count-1-i)])
                            .offset(x: self.card_x[i])
                            .gesture(DragGesture()
                                .onChanged({(value) in
                                    
                                    self.card_x[i] = value.translation.width
                                    
                                    if value.translation.width > 0 {
                                        show_agree = true
                                        show_disagree = false
                                    } else if value.translation.width < 0  {
                                        show_agree = false
                                        show_disagree = true
                                    } else {
                                        show_agree = false
                                        show_disagree = false
                                    }
                                    
                                })
                                    .onEnded({(value) in
                                        show_agree = false
                                        show_disagree = false
                                        if value.translation.width > 0 {
                                            
                                            if value.translation.width > 150 {
                                                self.card_x[i] = 600
                                                current_question_num -= 1
                                                self.questionnaire[i] = 1
                                            } else {
                                                self.card_x[i] = 0
                                            }
                                            
                                        } else if value.translation.width < 0  {

                                            if value.translation.width < -150 {
                                                self.card_x[i] = -600
                                                current_question_num -= 1
                                                self.questionnaire[i] = -1
                                            } else {
                                                self.card_x[i] = 0
                                            }
                                        }
                                        
                                        if (self.current_question_num < 0) {
                                            nextStage()
                                        }
                                        
                                    })
                            )
                    }
                    
                    VStack {
                        
                        if current_question_num != 17 {
                            Text("< Back")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .onTapGesture{
                                    self.card_x[current_question_num+1] = 0
                                    current_question_num += 1
                                    self.questionnaire[current_question_num] = 0
                                    
                                }
                                .padding(.horizontal, -50)
                                .padding()
                        } else{
                            Text("< Back")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .onTapGesture{
                                    
                                    prevStage()
                                }.padding(.horizontal, -50)
                                .padding()
                        }
                        
                        Text(show_agree ? "Agree" : show_disagree ? "Disagree" : "").foregroundColor(Color.primaryColor)
                            .font(.system(size: 20))
        
                        
                        

                        
                        Spacer()
                        
                        Text("Skip")
                            .font(.system(size: 26))
                            .foregroundColor(Color.gray)
                            .onTapGesture{
                                self.card_x[current_question_num] = 600
                                self.questionnaire[current_question_num] = 0
                                current_question_num -= 1
                                if (self.current_question_num < 0) {
                                    nextStage()
                                }
                            }
                        
                    }
                    
                    
                }.padding(.horizontal, 50)
                
                
            }
            if (createProfileStage == 5) {
                
                VStack {
                    
                    Button {
                        self.card_x[current_question_num+1] = 0
                        current_question_num += 1
                        self.questionnaire[current_question_num] = 0
                        prevStage()
                    }label: {
                        Text("< Back")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    
                    VStack{
                        Text("What do you enjoy talking with your peers about? And what are your hobbies? (10 Max)")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size: 24))
                            .padding(.vertical)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                    ScrollView(showsIndicators: false) {
                        
                        DisclosureGroup(
                            isExpanded: $lifestyleIsExpanded,
                            content: {
                                HStack {
                                    Button {
                                        
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+0)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+0)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+0)].toggle()
                                        
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Fitness")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+0)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+1)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+1)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+1)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Gaming")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+1)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+2)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+2)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+2)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("BeautyCare")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+2)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                }
                                HStack {
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+3)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+3)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        
                                        hobbies[(lifestyleIndex+3)].toggle()
                                        
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Traveling")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+3)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+4)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+4)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+4)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Reading")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+4)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+5)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+5)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+5)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Text("Cooking")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                Text("& Baking")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                            }
                                            
                                            
                                            Spacer()
                                        }.padding(.vertical, 9)
                                            .background(hobbies[(lifestyleIndex+5)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                }
                                
                                
                                HStack {
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+6)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+6)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+6)].toggle()
                                        
                                    }label: {
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Text("Food &")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                Text("Cuisine")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                            }
                                            
                                            
                                            Spacer()
                                        }.padding(.vertical, 9)
                                            .background(hobbies[(lifestyleIndex+6)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+7)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+7)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+7)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Clubbing")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+7)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+8)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+8)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+8)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            VStack{
                                        
                                                Text("Fishing")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                            }
                                            
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+8)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                }
                                
                                HStack {
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+9)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+9)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+9)].toggle()
                                        
                                    }label: {
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Text("Board")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                Text("Games")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                            }
                                            
                                            
                                            Spacer()
                                        }.padding(.vertical, 9)
                                            .background(hobbies[(lifestyleIndex+9)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+10)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+10)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+10)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Chess")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+10)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+11)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+11)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+11)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Text("Poker")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                            }
                                            
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+11)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                }
                                
                                HStack {
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+12)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+12)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+12)].toggle()
                                        
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Fashion")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+12)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+13)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+13)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+13)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Astrology")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+13)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(lifestyleIndex+14)] == false) {
                                            return
                                        }
                                        hobbies[(lifestyleIndex+14)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(lifestyleIndex+14)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Text("Karaoke")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                            }
                                            
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(lifestyleIndex+14)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                }
                            },
                            label: {
                                HStack(spacing: 20) {
                                    Image("Lifestyle 1")
                                    Text("Lifestyle")
                                }
                            }
                        ).foregroundColor(Color.black)
                            .accentColor(Color.black)
                        
                            DisclosureGroup(
                                isExpanded: $sportIsExpanded,
                                content: {
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+0)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+0)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+0)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Football")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+0)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+1)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+1)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+1)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Basketball")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+1)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+2)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+2)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+2)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Soccer")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+2)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+3)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+3)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+3)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Baseball")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+3)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+4)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+4)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+4)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Lacrosse")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+4)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+5)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+5)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+5)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Hockey")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+5)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+6)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+6)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+6)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Tennis")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+6)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+7)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+7)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+7)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Water")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Sports")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(sportIndex+7)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+8)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+8)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+8)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Running")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+8)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+9)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+9)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+9)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Hiking")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+9)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+10)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+10)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+10)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Field")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Hockey")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(sportIndex+10)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+11)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+11)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+11)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Volleyball")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+11)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+12)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+12)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+12)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Golf")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+12)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+13)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+13)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+13)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Rugby")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+13)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+14)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+14)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+14)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Cycling")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+14)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+15)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+15)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+15)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Skiing &")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 11))
                                                    Text("Snowboarding")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 11))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 10)
                                                .background(hobbies[(sportIndex+15)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+16)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+16)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+16)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Yoga")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+16)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(sportIndex+17)] == false) {
                                                return
                                            }
                                            hobbies[(sportIndex+17)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(sportIndex+17)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Badminton")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(sportIndex+17)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                },
                                label: {
                                    HStack(spacing: 20) {
                                        Image("Sports 1")
                                        Text("Sports & Fitness")
                                    }
                                }
                            ).foregroundColor(Color.black)
                                .accentColor(Color.black)
                            
                            DisclosureGroup(
                                isExpanded: $filmIsExpanded,
                                content: {
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+0)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+0)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 0)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Comedy")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 0)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+1)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+1)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 1)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Romance")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 11))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 1)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+2)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+2)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 2)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Action")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 2)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+3)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+3)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 3)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Anime")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 3)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+4)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+4)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 4)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Drama")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 4)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+5)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+5)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 5)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Reality TV")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 5)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+6)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+6)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 6)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Sci-Fi")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 6)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+7)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+7)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 7)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Horror/")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Thriller")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(filmIndex + 7)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+8)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+8)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 8)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("K-Drama")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 8)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+9)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+9)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 9)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("History")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 9)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+10)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+10)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 10)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Crime")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 10)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(filmIndex+11)] == false) {
                                                return
                                            }
                                            hobbies[(filmIndex+11)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(filmIndex + 11)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Musical")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(filmIndex + 11)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                },
                                label: {
                                    HStack(spacing: 20) {
                                        Image("Film")
                                            .resizable()
                                            .frame(width: 35, height: 35, alignment: .center)
                                        Text("Film & TV")
                                    }
                                }
                            ).foregroundColor(Color.black)
                                .accentColor(Color.black)
                            
                            DisclosureGroup(
                                isExpanded: $musicIsExpanded,
                                content: {
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+0)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+0)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+0)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Pop")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+0)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+1)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+1)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+1)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Hip-Hop")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+1)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+2)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+2)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+2)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("EDM")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+2)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+3)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+3)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+3)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Rap")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+3)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+4)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+4)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+4)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Country")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+4)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+5)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+5)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+5)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Classical")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+5)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+6)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+6)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+6)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("K-Pop")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+6)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+7)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+7)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+7)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Latin")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+7)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+8)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+8)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+8)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Jazz")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+8)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+9)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+9)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+9)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Rock")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(musicIndex+9)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(musicIndex+10)] == false) {
                                                return
                                            }
                                            hobbies[(musicIndex+10)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(musicIndex+10)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Indie")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Rock")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(musicIndex+10)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                Spacer()
                                            }.padding(.vertical)
                                        }.opacity(0)
                                    }
                                },
                                label: {
                                    HStack(spacing: 20) {
                                        Image("Music")
                                            .resizable()
                                            .frame(width: 35, height: 35, alignment: .center)
                                        Text("Music")
                                    }
                                }
                            ).foregroundColor(Color.black)
                                .accentColor(Color.black)
                            
                        DisclosureGroup(
                            isExpanded:$artIsExpanded,
                            content: {
                                HStack {
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(artIndex+0)] == false) {
                                            return
                                        }
                                        hobbies[(artIndex+0)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(artIndex+0)].toggle()
                                        
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Dance")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(artIndex+0)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(artIndex+1)] == false) {
                                            return
                                        }
                                        hobbies[(artIndex+1)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(artIndex+1)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Photography")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(artIndex+1)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(artIndex+2)] == false) {
                                            return
                                        }
                                        hobbies[(artIndex+2)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(artIndex+2)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            VStack{
                                                Text("Visual")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                Text("Arts")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                            }
                                            
                                            Spacer()
                                        }.padding(.vertical, 9)
                                            .background(hobbies[(artIndex+2)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                }
                                
                                HStack {
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(artIndex+3)] == false) {
                                            return
                                        }
                                        hobbies[(artIndex+3)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(artIndex+3)].toggle()
                                        
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Acapella")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(artIndex+3)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(artIndex+4)] == false) {
                                            return
                                        }
                                        hobbies[(artIndex+4)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(artIndex+4)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Theater")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(artIndex+4)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                    
                                    Button {
                                        if (hobbie_count >= 10 && hobbies[(artIndex+5)] == false) {
                                            return
                                        }
                                        hobbies[(artIndex+5)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                        hobbies[(artIndex+5)].toggle()
                                    }label: {
                                        HStack{
                                            Spacer()
                                            Text("Museums")
                                                .foregroundColor(.black)
                                                .font(.system(size: 12))
                                            
                                            Spacer()
                                        }.padding(.vertical)
                                            .background(hobbies[(artIndex+5)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                            .cornerRadius(24)
                                    }
                                }
                                
                            },
                            label: {
                                HStack(spacing: 20) {
                                    Image("Arts 1")
                                    Text("Arts")
                                }
                            }
                        ).foregroundColor(Color.black)
                            .accentColor(Color.black)
                        
                            DisclosureGroup(
                                isExpanded: $socialIsExpanded,
                                content: {
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+0)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+0)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+0)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Climate")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Change")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(socialIndex+0)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+1)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+1)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+1)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Racial")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Justice")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(socialIndex+1)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+2)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+2)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+2)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("LGBTQ")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(socialIndex+2)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+3)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+3)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+3)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Women's")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Rights")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(socialIndex+3)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+4)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+4)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+4)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Mental")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Health")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(socialIndex+4)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+5)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+5)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+5)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                
                                                Text("Immigration")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(socialIndex+5)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+6)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+6)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+6)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Freedom")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("of Speech")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(socialIndex+6)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+7)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+7)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+7)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Text("Health")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Equity")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(socialIndex+7)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+8)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+8)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+8)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                
                                                VStack{
                                                    Text("Wealth")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Inequality")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(socialIndex+8)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                    
                                    HStack {
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+9)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+9)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+9)].toggle()
                                            
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Education")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(socialIndex+9)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+10)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+10)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+10)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                Text("Privacy")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 12))
                                                
                                                Spacer()
                                            }.padding(.vertical)
                                                .background(hobbies[(socialIndex+10)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                        
                                        Button {
                                            if (hobbie_count >= 10 && hobbies[(socialIndex+11)] == false) {
                                                return
                                            }
                                            hobbies[(socialIndex+11)] ? (hobbie_count -= 1) : (hobbie_count += 1)
                                            hobbies[(socialIndex+11)].toggle()
                                        }label: {
                                            HStack{
                                                Spacer()
                                                
                                                VStack{
                                                    Text("Animal")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                    Text("Rights")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12))
                                                }
                                                
                                                
                                                Spacer()
                                            }.padding(.vertical, 9)
                                                .background(hobbies[(socialIndex+11)] ? Color.primaryColor : Color(.init(white: 0, alpha: 0.05)))
                                                .cornerRadius(24)
                                        }
                                    }
                                },
                                label: {
                                    HStack(spacing: 20) {
                                        Image("Charity 1")
                                        Text("Social Causes")
                                    }
                                }
                            ).foregroundColor(Color.black)
                                .accentColor(Color.black)
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    .padding(.horizontal, 50)
                    
                    Spacer()
                    Text("> Next")
                        .font(.system(size: 26))
                        .foregroundColor(Color.gray)
                        .onTapGesture{
                            nextStage()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 50)
                    
                    
                }
                
            }
            if (createProfileStage == 6) {
                VStack {
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .center)
                        .padding(.top, 200)
                        .padding(.bottom, UIScreen.main.bounds.height*0.1)
                    
                    Text("Find out when you get matches!").font(.system(size: 28)).foregroundColor(Color.primaryColor)
                        .padding(.bottom, UIScreen.main.bounds.height*0.05)
                    
                    
                    Button {
                        self.showPushNotificationModal=true
                    } label: {
                        HStack{
                            Spacer()
                            Text("Turn on Notifications")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .padding(.vertical, 20)
                            Spacer()
                        }
                        .background(Color.primaryColor)
                        .cornerRadius(12)
                    }.padding(.bottom, 30)
                        .JMModal(showModal: $showPushNotificationModal, for: [.notification, .photo], onAppear: {}, onDisappear: {nextStage()})
                        .setPermissionComponent(for: .photo,
                                                description: "We want you to upload a picture of yourself")
                        .setPermissionComponent(for: .notification,
                                                description: "We want to send you notification when you get matches")
                        .changeHeaderDescriptionTo("Yolk needs certain permissions in order for all the features to work. See description for each permission")
                    
                    
                    Text("NVM for now").font(.system(size: 18)).foregroundColor(Color.gray)
                        .onTapGesture{
                            nextStage()
                        }
                    
                }.padding(.horizontal, 50)
            }
            if (createProfileStage == 7) {
                
                VStack {

                    
                    Button {
                        isShowingPhotoPicker.toggle()
                    } label: {
                        
                        VStack{
                            if let image = self.image {
                                Image(uiImage:image)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.height*0.15, height: UIScreen.main.bounds.height*0.15)
                                    .scaledToFill()
                                    .cornerRadius(90)
                            }
                            else {
                                Image("plus_photo")
                                    .font(.system(size: 64))
                                    .padding()
                            }
                        }
                        
                    }.padding(.top, UIScreen.main.bounds.height*0.05)
                    
                    Text(self.first)
                        .font(.system(size: 36))
                        .foregroundColor(Color.primaryColor)
                    
                    
                    HStack{
                        if (self.show_class) {
                            Button {
                                
                            } label: {
                                HStack{
                                    Spacer()
                                    Text(self.grad_year == "2022" ? "Senior": self.grad_year == "2023" ? "Junior" : self.grad_year == "2024" ? "Sophomore": "Freshman")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    Spacer()
                                    
                                    
                                }
                                .background(Color.primaryColor)
                                .cornerRadius(24)
                            }.padding(.horizontal, UIScreen.main.bounds.width*0.2)
                        }
                        
                        
                        
                        
                    }
                    
                    Group {
                        Toggle("Display class year", isOn: $show_class)
                            .font(.system(size: 24))
                            .foregroundColor(Color.primaryColor)
                            .toggleStyle(SwitchToggleStyle(tint: Color.primaryColor))
                        
                        Text("Add a short bio about yourself")
                            .font(.system(size: 20))
                            .italic()
                            .foregroundColor(Color.primaryColor)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        
                        TextEditor(text: $bio)
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.primaryColor, style: StrokeStyle(lineWidth: 2.0)))
                            .frame(width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.height*0.10, alignment: .leading)
                        
                        
                        Text("Sample Bio")
                            .font(.system(size: 22, weight:.bold))
                            .foregroundColor(Color.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            
                            VStack{
                                Image("tangya_profile_pic")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.height*0.08, height: UIScreen.main.bounds.height*0.08)
                                Spacer()
                            }

                            
                            Spacer()
                            
                            ScrollView {
                                Text("Tangya is a Junior studying in IS + Econ and daydreaming about the next start-up idea. Passionate in photography, scuba diving and coffee.")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black)
                            }
                        }
                    }.padding(.vertical, 5)
                    
                    Spacer()
                    
                    
                    Text(self.addProfileImageMsg)
                        .foregroundColor(Color.primaryColor)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                        .font(.system(size: 14))
                    
                    
                    
                    HStack{
                        Spacer()
                        
                        Button {
                            firstTime = true
                            handleSubmit()
                        } label: {
                            
                                
                            Text("Done")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color.primaryColor)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, -50)
                    .padding()
                    
                    
                }.padding(.horizontal, 50)
                    .background(Color.white)
                    .onTapGesture {
                        hideKeyboard()
                    }
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
        
        if (self.image == nil) {
            self.addProfileImageMsg = "Please add a profile picture"
            return
        }
        if (self.bio.count > 140) {
            self.addProfileImageMsg = "The maximum length of the bio is 140 characters"
            return
        }
        
        let ref = FirebaseManager.shared.firestore.collection("users").document(vm.uid)
        
        
        
        let storage_ref = FirebaseManager.shared.storage.reference(withPath: "profilePictures/" + vm.uid)
        guard let imageData = (self.image ?? UIImage(named: "logo"))?.jpegData(compressionQuality: 0.5) else { return }
        
        storage_ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            
            storage_ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    return
                }
                
                var profile: [String: Any] = [:]
                
                profile["first_name"] = self.first
                profile["gender"] = self.gender
                profile["goal"] = friend ? "friend" : "career"
                profile["graduation_year"] = self.grad_year
                profile["last_name"] = self.last
                profile["political"] = self.political
                profile["religious"] = self.religious
                profile["profileImageUrl"] = url?.absoluteString ?? ""
                profile["career_interests"] = self.career_interests
                profile["hobbies"] = self.hobbies
                profile["majors"] = [self.first_major, self.second_major]
                profile["questionnaire"] = self.questionnaire
                profile["bio"] = self.bio
                profile["class_standing"] = self.grad_year == "2022" ? "Senior": self.grad_year == "2023" ? "Junior" : self.grad_year == "2024" ? "Sophomore": "Freshman"
                profile["display_class"] = self.show_class
                
                
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
                            vm.fetchRecentMessages()
                            vm.fetchCurrentUser()
                        }
                    }
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
            
            Image("logo")
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
            
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
        HomeView()
    }
}
