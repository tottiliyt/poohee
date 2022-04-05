//
//  PersonalInfoView.swift
//  poohee
//
//  Created by Yuntao Li on 4/2/22.
//

import SwiftUI

struct PersonalInfoView: View {
    @State var first = ""
    @State var last = ""
    @State var password = ""
    @State var status = ""
    
    var body: some View {
        VStack{
            Text("Tell us a little about yourself")
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))
            
            Text("Name")
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))
            
            HStack{
                TextField("First", text: $first)
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
                .cornerRadius(10)
                
                TextField("Last", text: $first)
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
                .cornerRadius(10)
            }
            
            Text("Gender")
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))
            
            Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
            }
            
            Text("Hometown")
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))
            
            
            
            Text("Graduation Year")
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))

            
            Text("Major")
                .foregroundColor(Color.primaryColor)
                .font(.system(size: 36))
            
            
        }.padding(.horizontal, 50)
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoView()
    }
}
