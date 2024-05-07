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
            .navigationTitle("Support")
            .navigationBarItems(trailing: Button(action: {
                createIssue = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $createIssue, content: {
                CreateIssue()
            })
            .task {
                Task{
                    authViewModel.getSupport()
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
            
        }
    }
}

struct IssueView: View {
    @State var supportData: SupportTicket
    
    var body: some View {
        HStack{
            
            VStack(alignment:.leading){
                
                Text("Subject: ")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                
                Text(supportData.Subject)
                    .font(.system(size: 20, weight: .medium))
                    .padding(.top, 4)
                
                Text("Description: ")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                
                Text(supportData.description)
                    .font(.system(size: 16))
                    .padding(.top, 4)
                
                HStack{
                    Text("Status: \(supportData.status)")
                        .font(.system(size: 14, weight: .regular))
                        .padding(.top, 4)
                }
            }
            Spacer()
        }
        .padding(.vertical, 10)
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



struct Support_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return Support(authViewModel: AuthViewModel()).environmentObject(themeManager)
    }
}

