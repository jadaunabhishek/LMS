import SwiftUI

struct StaffDetailsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let userID: String
    @StateObject var staffViewModel = StaffViewModel()
    
    var body: some View {
        VStack {
            if let staffMember = staffViewModel.currentStaff.first(where: { $0.userID == userID }) {
    
                if let profileURL = URL(string: staffMember.profileImageURL) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(themeManager.selectedTheme.secondaryThemeColor)
                            .frame(height: 240)
                            .cornerRadius(15)
                        VStack{
                            AsyncImage(url: profileURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .padding(.top, 20)
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                            }
                            VStack(alignment: .center, spacing: 10) {
                                Text(staffMember.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(staffMember.role)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                        
                    }
                    .padding(.bottom, 20)
                }
                
                // Staff member name and role
                
                
                List {
                    Section(header: Text("Details").font(.headline).foregroundColor(themeManager.selectedTheme.bodyTextColor)) {
                        Text("Email: \(staffMember.email)").font(.subheadline)
                        Text("Mobile: \(staffMember.mobile)").font(.subheadline)
                        Text("Aadhar: \(staffMember.aadhar)").font(.subheadline)
                        Text("Created On: \(staffMember.createdOn)").font(.subheadline)
                        Text("Updated On: \(staffMember.updatedOn)").font(.subheadline)
                        Text("Status: \(staffMember.status.rawValue)").font(.subheadline)
                    }
                }
                .listStyle(GroupedListStyle())
                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarItems(
                    leading: Spacer(),
                    trailing:
                        NavigationLink(
                            destination: EditStaffDetailsView(staffMember: staffMember),
                            label: {
                                Image(systemName: "pencil")
                                    .font(.title3)
                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                            }
                        )
                )
            } else {
                Text("Staff member details not found.")
            }
        }
        
        .padding()
        .onAppear {
            staffViewModel.getStaff()
        }
        .navigationTitle("Staff Details")
      
    }
}


struct StaffDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return StaffDetailsView(userID: "35PmRqJThks5zqXgn02g")
            .environmentObject(themeManager)
    }
}
