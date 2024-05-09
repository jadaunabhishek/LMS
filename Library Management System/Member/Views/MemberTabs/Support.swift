import SwiftUI

struct Support: View {
    @State private var createIssue = false
    @State private var showDetails = false
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if(!authViewModel.allSupports.isEmpty){
                            ForEach(0..<authViewModel.allSupports.count, id: \.self) { supportDetail in
                                NavigationLink(destination: SupportReply(supportData: authViewModel.allSupports[supportDetail], authViewModel: authViewModel)) {
                                    supportCard(supportData: authViewModel.allSupports[supportDetail])
                                }
                            }
                }
                else{
                    EmptyPage()
                }
                Spacer()
            }
            .background(.black.opacity(0.05))
            .navigationTitle("Support")
            .navigationBarItems(trailing: Button(action: {
                createIssue = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $createIssue, content: {
                CreateIssue()
                    .presentationDetents([.medium])
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



struct Support_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return Support(authViewModel: AuthViewModel()).environmentObject(themeManager)
    }
}

