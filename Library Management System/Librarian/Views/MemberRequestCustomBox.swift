//
//  MemberRequestCustomBox.swift
//  Library Management System
//
//  Created by Abhishek Jadaun on 03/05/24.
//

import SwiftUI

// View for each notification row
struct MemberRequestCustomBox: View {
    var viewModel: NotificationsViewModel
    var notification: NotificationItem

    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(.orange)
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(notification.name).font(.headline)
                Text(notification.email).font(.subheadline)
                Text("Status: \(notification.role)").font(.subheadline)  // Display the role
                Text(notification.detail).font(.caption)
            }

            Spacer()
        }
    }
}

