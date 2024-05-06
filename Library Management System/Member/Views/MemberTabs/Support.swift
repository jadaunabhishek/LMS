import SwiftUI

struct Support: View {
    @State private var createIssue = false
    @State private var showDetails = false
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                if(!authViewModel.allSupports.isEmpty){
                    ScrollView{
                        VStack{
                            ForEach(0..<authViewModel.allSupports.count, id: \.self) { supportDetail in
                                IssueView(supportData: authViewModel.allSupports[supportDetail])
                            }
                        }
                    }
                }
                else{
                    EmptyPage()
                }
            }
            .listStyle(.inset)
            .background(.black.opacity(0.05))
            .navigationTitle("Books")
            .navigationTitle("Support")
            .navigationBarItems(trailing: Button(action: {
                createIssue = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $createIssue, content: {
                CreateIssue()
            })
            .onAppear(
                perform: {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { time in
                        Task{
                            authViewModel.getSupport()
                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                        }
                    }
                }
            )
        }
    }
}

// View for each issue in the list
//struct IssueView: View {
//    @State var supportData: SupportTicket
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text(supportData.Subject)
//                .font(.headline)
//                .foregroundColor(.primary)
//            Text(supportData.description)
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//                .lineLimit(1)
//            HStack {
//                Spacer()
//                Text(supportData.status)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//        }
//        .cornerRadius(10)
//        .padding(.leading)
//        .padding(.top)
//    }
//}

struct IssueView: View {
    @State var supportData: SupportTicket
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) { // Increased spacing for better visual separation
            Text(supportData.Subject)
                .font(.headline)
                .foregroundColor(.primary)
            Text(supportData.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3) // Increased line limit for better content visibility
            HStack {
                Spacer()
                Text(supportData.status)
                    .font(.caption)
                    .foregroundColor(colorForStatus(supportData.status)) // Dynamic color based on status
            }
        }
    }

    // Function to determine color based on ticket status
    private func colorForStatus(_ status: String) -> Color {
        switch status {
        case "Resolved":
            return Color.green
        case "Pending":
            return Color.orange
        default:
            return Color.gray
        }
    }
}

//// Detailed view that appears in a modal sheet
//struct DetailedIssueView: View {
//    @State private var replyText: String = "" // To hold reply text if needed
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Detailed Description")
//                        .font(.title2)
//                        .bold()
//                        .padding(.bottom, 2)
//
//                    Text(issue.description)
//                        .padding(.bottom, 20)
//
//                    Text("Reply from Librarian:")
//                        .font(.headline)
//                        .padding(.bottom, 2)
//
//                    if let reply = issue.reply {
//                        Text(reply)
//                    } else {
//                        Text("No reply yet...")
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding()
//            Spacer()
//        }
//        .padding()
//        .navigationTitle(issue.title) // Adds a navigation title if this view is embedded in a navigation stack
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}


struct Support_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return Support(authViewModel: AuthViewModel()).environmentObject(themeManager)
    }
}

