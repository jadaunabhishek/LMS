import SwiftUI
import FirebaseAuth

enum Option {
    case CheckIn
    case Membership
    case CheckOut
}

struct NotificationsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var configViewModel: ConfigViewModel
    @ObservedObject var staffViewModel: StaffViewModel
    @StateObject var viewModel = NotificationsViewModel()
    @Binding var selectedOption: Option
    @State var searchText = ""
    @State var notifications: [NotificationItem] = []
    @State var requestedLoans: [Loan] = []
    @State var issuedLoans: [Loan] = []
    @State var isSelectionMode: Bool = false
    @State var showAlert = false
    
    var body: some View {
        NavigationView{
            VStack(){
                HStack() {
                    PickerButton(title: "Issue", isSelected: selectedOption == .CheckOut) {
                        self.selectedOption = .CheckOut
                    }
                    
                    PickerButton(title: "Return", isSelected: selectedOption == .CheckIn) {
                        self.selectedOption = .CheckIn
                    }
                    
                    PickerButton(title: "Membership", isSelected: selectedOption == .Membership) {
                        self.selectedOption = .Membership
                    }
                }
                .padding([.bottom, .leading, .trailing])
                
                if (selectedOption == .CheckOut){
                    if (requestedLoans.isEmpty){
                        EmptySection()
                    } else {
                        BooksSections(LibViewModel: LibViewModel, issue: $issuedLoans, request: $requestedLoans)
                    }
                }
                else if( selectedOption == .CheckIn){
                    if (issuedLoans.isEmpty) {
                        EmptySection()
                    } else {
                        checkInSections(LibViewModel: LibViewModel)
                    }
                }
                else if( selectedOption == .Membership){
                    if (notifications.isEmpty) {
                        EmptySection()
                    } else {
                        MembershipSections(notifs: $notifications)
                    }
                }
            }
            .navigationTitle("Actions")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: NavigationLink(destination: LibProfileView(LibViewModel: LibViewModel, configViewModel: configViewModel, staffViewModel: staffViewModel), label: {
                Image(systemName: "person.crop.circle")
                    .font(.title3)
                    .foregroundColor(Color(themeManager.selectedTheme.primaryThemeColor))
            }))
            
            .onAppear(perform: {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { time in
                    Task{
                        if let currentUser = Auth.auth().currentUser?.uid{
                            print(currentUser)
                            staffViewModel.fetchStaffData(staffID: currentUser)
                        }
                        LibViewModel.getLoans()
                        //try? await Task.sleep(nanoseconds: 1_000_000_000)
                        issuedLoans = LibViewModel.issuedLoans
                        requestedLoans = LibViewModel.requestedLoans
                        viewModel.fetchData()
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        notifications = viewModel.notifications
                    }
                }
            })
            .task{
                Task{
                    if let currentUser = Auth.auth().currentUser?.uid{
                        print(currentUser)
                        staffViewModel.fetchStaffData(staffID: currentUser)
                    }
                    LibViewModel.getLoans()
                    //try? await Task.sleep(nanoseconds: 1_000_000_000)
                    issuedLoans = LibViewModel.issuedLoans
                    requestedLoans = LibViewModel.requestedLoans
                    viewModel.fetchData()
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    notifications = viewModel.notifications
                }
            }
            .searchable(text: $searchText)
        }
    }
}




struct EmptySection: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            
            Text("No Data")
                .foregroundColor(.gray)
                .font(.headline)
                .padding()
                .italic()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct MembershipSections: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject var viewModel = NotificationsViewModel()
    @Binding var notifs: [NotificationItem]
    @State private var selectedItems: [String] = []
    @State private var isSelectionMode = false
    
    var body: some View {
        VStack {
            if isSelectionMode {
                selectionBar
                    .padding(.horizontal,20)
                    .transition(.move(edge: .top))
                    .animation(.easeInOut, value: isSelectionMode)
            }
            List {
                ForEach(viewModel.notifications, id: \.id) { key in
                    HStack {
                        if isSelectionMode {
                            Button(action: {
                                toggleSelection(key: key.id)
                            }) {
                                Image(systemName: selectedItems.contains(key.id) ? "checkmark.square.fill" : "square")
                            }
                            .foregroundColor(selectedItems.isEmpty ? Color.black : themeManager.selectedTheme.primaryThemeColor)
                        }
                        MemberRequestCustomBox(viewModel: viewModel, notification: key)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isSelectionMode {
                            toggleSelection(key: key.id)
                        }
                    }
                    .onLongPressGesture {
                        isSelectionMode = true
                        toggleSelection(key: key.id)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            processSwipeAction(key: key.id, approve: false)
                        } label: {
                            Image(systemName: "xmark")
                            Text("Reject")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            processSwipeAction(key: key.id, approve: true)
                        } label: {
                            Image(systemName: "checkmark")
                            Text("Accept")
                        }
                        .tint(.green)
                    }
                }
            }
            .listStyle(.inset)
        }
        .navigationBarItems(trailing: selectionModeButton)
    }
    
    var selectionModeButton: some View {
        Button(action: {
            isSelectionMode.toggle()
            if !isSelectionMode {
                selectedItems.removeAll()
            }
        }) {
            Text(isSelectionMode ? "Done" : "Select")
        }
    }
    
    var selectionBar: some View {
        HStack {
            Button(action: toggleSelectAll) {
                HStack {
                    Image(systemName: selectedItems.count == viewModel.notifications.count ? "checkmark.square.fill" : "square")
                    Text(selectedItems.count == viewModel.notifications.count ? "Unselect All" : "Select All")
                }
            }
            .foregroundColor(selectedItems.isEmpty ? themeManager.selectedTheme.bodyTextColor : themeManager.selectedTheme.primaryThemeColor)
            
            Spacer()
            
            Button(action: {
                processSelectedItems(approve: true)
            }) {
                Text("Approve")
                    .foregroundColor(selectedItems.isEmpty ? Color.green.opacity(0.5): Color.green)
            }
            .cornerRadius(8)
            .disabled(selectedItems.isEmpty)
            
            Button(action: {
                processSelectedItems(approve: false)
            }) {
                Text("Reject")
                    .foregroundColor(selectedItems.isEmpty ? Color.red.opacity(0.5) : Color.red)
            }
            .cornerRadius(8)
            .disabled(selectedItems.isEmpty)
        }
    }
    
    func toggleSelection(key: String) {
        if selectedItems.contains(key) {
            selectedItems.remove(at: selectedItems.firstIndex(of: key)!)
        } else {
            selectedItems.append(key)
        }
    }
    
    func toggleSelectAll() {
        if selectedItems.count == viewModel.notifications.count {
            selectedItems.removeAll()
        } else {
            for i in 0..<viewModel.notifications.count{
                selectedItems.append(viewModel.notifications[i].id)
            }
        }
    }
    
    func processSelectedItems(approve: Bool) {
        for index in selectedItems {
            for i in 0..<viewModel.notifications.count{
                if(viewModel.notifications[i].id == index){
                    if approve {
                        viewModel.approve(notification: viewModel.notifications[i])
                    } else {
                        viewModel.reject(notification: viewModel.notifications[i])
                    }
                }
                
            }
        }
        viewModel.fetchData()
        selectedItems.removeAll()
        isSelectionMode = false
    }
    func processSwipeAction(key: String, approve: Bool) {
        if let index = viewModel.notifications.firstIndex(where: { $0.id == key }) {
            if approve {
                viewModel.approve(notification: viewModel.notifications[index])
            } else {
                viewModel.reject(notification: viewModel.notifications[index])
            }
        }
        viewModel.fetchData()
    }
}



struct checkInSections: View {
    @ObservedObject var LibViewModel: LibrarianViewModel
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(0..<LibViewModel.issuedLoans.count, id: \.self) { userDetail in
                    NavigationLink(destination: CheckInDetailsView(checkInDetails: LibViewModel.issuedLoans[userDetail], LibViewModel: LibViewModel)){
                        BookRequestCustomBox(bookRequestData: LibViewModel.issuedLoans[userDetail])
                    }
                }
            }
        }
    }
}

struct BooksSections: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var LibViewModel: LibrarianViewModel
    @Binding var issue: [Loan]
    @Binding var request: [Loan]
    @State private var selectedItems: [String] = []
    @State private var isSelectionMode = false
    
    var body: some View {
        VStack {
            if isSelectionMode {
                selectionBar
                    .padding(.horizontal, 20)
                    .transition(.move(edge: .top))
                    .animation(.easeInOut, value: isSelectionMode)
            }
            List {
                ForEach(LibViewModel.requestedLoans, id: \.loanId) { key in
                    HStack {
                        if isSelectionMode {
                            Button(action: {
                                toggleSelection(key: key.loanId)
                            }) {
                                HStack{
                                    Image(systemName: selectedItems.contains(key.loanId) ? "checkmark.square.fill" : "square")
                                    
                                }
                            }
                            .foregroundColor(selectedItems.isEmpty ? Color.black : themeManager.selectedTheme.primaryThemeColor)
                        }
                        BookRequestCustomBox(bookRequestData: key)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isSelectionMode {
                            toggleSelection(key: key.loanId)
                        }
                    }
                    .onLongPressGesture {
                        isSelectionMode = true
                        toggleSelection(key: key.loanId)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button{
                            Task {
                                await LibViewModel.rejectRequest(loanId: key.loanId, bookId: key.bookId)
                                LibViewModel.getLoans()
                            }
                        } label: {
                            Image(systemName: "xmark")
                            Text("Reject")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            LibViewModel.checkOutBook(loanId: key.loanId)
                            LibViewModel.getLoans()
                        } label: {
                            Image(systemName: "checkmark")
                            Text("Accept")
                        }
                        .tint(.green)
                    }
                }
            }
            .listStyle(.inset)
        }
        .navigationBarItems(trailing: selectionModeButton)
    }
    
    var selectionModeButton: some View {
        Button(action: {
            isSelectionMode.toggle()
            if !isSelectionMode {
                selectedItems.removeAll()
            }
        }) {
            Text(isSelectionMode ? "Done" : "Select")
        }
    }
    
    var selectionBar: some View {
        HStack {
            Button(action: toggleSelectAll) {
                HStack {
                    Image(systemName: selectedItems.count == LibViewModel.requestedLoans.count ? "checkmark.square.fill" : "square")
                    Text(selectedItems.count == LibViewModel.requestedLoans.count ? "Unselect All" : "Select All")
                }
            }
            .foregroundColor(selectedItems.isEmpty ? themeManager.selectedTheme.primaryThemeColor : themeManager.selectedTheme.primaryThemeColor)
            
            Spacer()
            
            Button(action: {
                processSelectedItems(approve: true)
            }) {
                Text("Approve")
                    .foregroundColor(selectedItems.isEmpty ? Color.green.opacity(0.5) : Color.green)
            }
            .cornerRadius(8)
            .disabled(selectedItems.isEmpty)
            
            Button(action: {
                processSelectedItems(approve: false)
            }) {
                Text("Reject")
                    .foregroundColor(selectedItems.isEmpty ? Color.red.opacity(0.5) : Color.red)
            }
            .cornerRadius(8)
            .disabled(selectedItems.isEmpty)
        }
    }
    
    func toggleSelection(key: String) {
        if selectedItems.contains(key) {
            selectedItems.remove(at: selectedItems.firstIndex(of: key)!)
        } else {
            selectedItems.append(key)
        }
    }
    
    func toggleSelectAll() {
        if selectedItems.count == LibViewModel.requestedLoans.count {
            selectedItems.removeAll()
        } else {
            for i in 0..<LibViewModel.requestedLoans.count{
                selectedItems.append(LibViewModel.requestedLoans[i].loanId)
            }
        }
    }
    
    func processSelectedItems(approve: Bool) {
        for index in selectedItems {
            if approve {
                LibViewModel.checkOutBook(loanId: index)
                
                LibViewModel.getLoans()
            } else {
                Task {
                    for i in 0..<LibViewModel.requestedLoans.count{
                        if(LibViewModel.requestedLoans[i].loanId == index){
                            await LibViewModel.rejectRequest(loanId: index, bookId: LibViewModel.requestedLoans[i].bookId)
                            LibViewModel.getLoans()
                        }
                    }
                }
            }
        }
        LibViewModel.getLoans()
        selectedItems.removeAll()
        isSelectionMode = false
    }
}


struct TestNotificationView_Previews: PreviewProvider {
    static var previews: some View {
    let themeManager = ThemeManager()
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    @StateObject var staffViewModel = StaffViewModel()
    @State var selectedOption: Option = .CheckOut
        
    return NotificationsView(LibViewModel: LibViewModel, configViewModel: ConfiViewModel, staffViewModel: staffViewModel, selectedOption: $selectedOption)
        .environmentObject(themeManager)
    }
}

