//
//  Membership.swift
//  Library Management System
//
//  Created by admin on 22/04/24.
//

import SwiftUI

struct Membership: View {
    enum MembershipStatus {
        case requested
        case received
        case approved
        case new
    }
    
    
    @State private var status_sent: MembershipStatus = .new
    
    
    private func colorForStatus(_ status: MembershipStatus) -> Color {
        switch status {
        case .requested, .received, .approved:
            return .green             case .new:
            return .gray
        }
    }
    
    var body: some View {
        VStack{
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 255/255, green: 183/255, blue: 21/255))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .frame(height: 250)
                
                VStack( spacing: 10) {
                    Text("Membership Access")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Unlock Priority Access")
                        .font(.title3)
                        .fontWeight(.semibold)
                }.padding(.top, 80)
                Spacer()
            }.ignoresSafeArea()
            HStack {
                VStack(alignment: .leading) {
                    Text("What's Included")
                        .font(.headline)
                        .padding(.bottom, 5)
                    HStack {
                        Image(systemName: "clock")
                        Text("3-4 weeks duration")
                    }
                    HStack {
                        Image(systemName: "doc.text")
                        Text("Access to Resources")
                    }
                    HStack {
                        Image(systemName: "star")
                        Text("Gets Priority Access")
                    }
                    HStack {
                        Image(systemName: "globe")
                        Text("24/7: Explore Anytime")
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("User")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text("-")
                    Text("-")
                    Text("-")
                    Text("-")
                }
                
                VStack{
                    Text("Member")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text("✓")
                    Text("✓")
                    Text("✓")
                    Text("✓")
                }
            }
            .padding()
            HStack{
                Text("Request Status")
                    .font(.headline)
                    .padding()
                Spacer()
            }
            HStack{
                
                VStack(alignment: .leading){
                    HStack{
                        statusIndicator(imageName: "clock", text: "Request Sent", status: status_sent)
                    }
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 2, height: 50)
                        .padding(.leading,10)
                    HStack{
                        statusIndicator(imageName: "clock", text: "Request Received by Librarian", status: .received)
                        
                    }
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 2, height: 50)
                        .padding(.leading,10)
                    HStack{
                        statusIndicator(imageName: "clock", text: "Approved", status: .approved)
                    }
                    
                }.padding(.trailing, 60)
                
            }.padding(.vertical)
            VStack {
                Spacer()
                Button(action: {
                    self.status_sent = .requested
                }) {
                    Text("Request Membership")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(Color(red: 255/255, green: 183/255, blue: 21/255))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom)
                
            }.padding(.bottom,35)
        }
    }
    private func statusIndicator(imageName: String, text: String, status: MembershipStatus) -> some View {
        HStack {
            Circle()
                .fill(colorForStatus(status))
                .frame(width: 20, height: 20)
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .padding(.trailing, 25)
            Text(text)
        }
    }
}

#Preview {
    Membership()
}
