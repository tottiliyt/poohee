//
//  ReportDetailView.swift
//  poohee
//
//  Created by Yuntao Li on 5/13/22.
//

import SwiftUI

struct ReportDetailView: View {
    @State private var problem = ""
    @State private var actionsheetisopen = false
    @State private var submitSuccess = false
    @ObservedObject var vm : ChatViewModel
    var body: some View {
        
     
            if submitSuccess {
                VStack {
                    Text("Your report has been submitted successfully.").font(.system(size: 45)).foregroundColor(Color.primaryColor)
                    Image("logo")
                        .resizable()
                        .frame(width: 180, height: 180, alignment: .center)
                        .padding(.vertical, 40)
                    
                }.padding(.horizontal)
            }
            else {
                List {
                    
                    
                    Section(header: ListHeader(), footer: ListFooter()) {
                        Text("Nudity or sexual activity")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Nudity or sexual activity"
                            }
                        Text("Hate speech or symbols")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Hate speech or symbols"
                            }
                        Text("Scam or fraud")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Scam or fraud"
                            }
                        Text("Violence")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Violence"
                            }
                        Text("Sale of illegal or regulated goods")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Sale of illegal or regulated goods"
                            }
                        Text("Bullying or harassment")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Bullying or harassment"
                            }
                        Text("Pretending to be someone else")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Pretending to be someone else"
                            }
                        Text("Suicide or self-injury")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Suicide or self-injury"
                            }
                        Text("Spam")
                            .onTapGesture{
                                actionsheetisopen = true
                                problem = "Spam"
                            }
                    }
                    
                    

                }.actionSheet(isPresented: $actionsheetisopen) {
                    .init(title: Text("Submit report"), buttons: [.default(Text("Submit"), action: {
                        submitSuccess = true
                        vm.report(problem: problem)
                    }), .cancel()])
                }
            }
        
        
        
            
            
            
    }
}

struct ReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ListHeader: View {
    var body: some View {
        HStack {
            Text("Select a problem to report")
        }
    }
}

struct ListFooter: View {
    var body: some View {
        Text("You can email us at support@yolkapps.com to report any other problems")
    }
}
