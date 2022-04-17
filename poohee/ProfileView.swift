//
//  ProfileView.swift
//  poohee
//
//  Created by Will Zhao on 4/8/22.
//

import SwiftUI

struct ProfileView: View {
    
    @State var bio = ""
    @State var friend = true
    @State var career = false
    
    var body: some View {
        VStack {
            
            
            
            Button {
                
            } label: {
                HStack{
                        Spacer()
                        Text("On")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        Spacer()

                    
                }
                    .background(Color.secondaryColor)
                    .cornerRadius(24)
            }.padding(.leading, 250)
            
            Image("plus_photo")
                .frame(width: 200, height: 200)
                .padding()
            

            Text("Tangya")
                .font(.system(size: 36))
                .foregroundColor(Color.secondaryColor)
            
            
            HStack{
                
                
                Image("female_icon")
                    .resizable()
                    .frame(width: 20, height: 30)
                    .padding(.leading, 90)
                    .padding(.trailing, 15)
                
                Spacer()
                
                Button {
                    
                } label: {
                    HStack{
                            Spacer()
                            Text("Age 21")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Spacer()

                        
                    }
                        .background(Color.secondaryColor)
                        .cornerRadius(24)
                }.padding(.trailing, 60)
            }

            HStack {
                Button {
                }label: {
                    HStack{
                    
                            
                            Text("3")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .padding(6)
                                .padding(.horizontal, 4)
                            
                        
                    }
                        .background(Color.secondaryColor)
                        .cornerRadius(10)
                        .border(Color.purple, width: career ? 5 : 0)
                        
                }
                
                
                Text("Meetups already ")
                    .font(.system(size: 24))
                    .foregroundColor(Color.secondaryColor)
                    
                
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
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
                            
                        
                    }
                        .background(Color.primaryColor)
                        .cornerRadius(10)
                        
                }.padding(.top, 20)
                
                Button {
                }label: {

                    Image("share").resizable().frame(width: 40, height:40)
                        
                }.padding(.top, 35)
                
            }
            
            Text("Bio")
                .font(.system(size: 24))
                .italic()
                .foregroundColor(Color.primaryColor)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

            
            Text("Third-year college student daydreaming about the next start-up idea. Interested in VC, tech, and coffee. Study international affairs and economics.")
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.primaryColor, style: StrokeStyle(lineWidth: 2.0)))
            
                
            
            
            HStack {
                Text("Goal")
                    .font(.system(size: 24))
                    .italic()
                    .foregroundColor(Color.primaryColor)

                Text("(Click to change)")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray)

            }                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Button {
                    friend.toggle()
                }label: {
                    HStack{
                        

                            Spacer()
                            Text("Make New Friends!")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            Spacer()

                        
                    }.padding(.vertical, 30)
                        .background(Color.primaryColor)
                        .cornerRadius(15)
                        .border(Color.orange, width: friend ? 3 : 0)
                }
                
                
                
                Button {
                    career.toggle()
                }label: {
                    HStack{
                    
                            Spacer()
                            Text("Meet Like-minded People (Career/Academic)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            Spacer()
                        
                    }.padding(.vertical, 10)
                        .background(Color.secondaryColor)
                        .cornerRadius(15)
                        .border(Color.purple, width: career ? 5 : 0)
                    
                }
            }

            

        }.padding(.horizontal, 50)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
