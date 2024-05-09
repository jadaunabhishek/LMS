//
//  AdminHomeView.swift
//  Library Management System
//
//  Created by Manvi Singhal on 22/04/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Charts
struct Dashboard: View {
    
    @ObservedObject var librarianViewModel: LibrarianViewModel
    @ObservedObject var staffViewModel: StaffViewModel
    @ObservedObject var userAuthViewModel: AuthViewModel
    @ObservedObject var configViewModel: ConfigViewModel
    @Binding var tabSelection: Int
    @Binding var actionSelection: Option
    
    @State var isPageLoading: Bool = true
    @State var isThemeSelecterSheetPresented: Bool = false
    
    @State var isLogoSelecterSheetPresented: Bool = false
    @State var selectedImage: UIImage = UIImage()
    @State var isLogoSelected = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var memberData: [Int] = [5, 10, 200, 300,0,0,0]
    
    @State private var isMemberSheetPresented: Bool = false
    @State private var isTotalRevenueSheetPresented: Bool = false
    var data: [(type: String, amount: Int)]{
        [(type: "Fine", amount : userAuthViewModel.totalIncome),
         (type: "Membership", amount : userAuthViewModel.allUsers.count * 50)
        ]
        
    }
    @State var TotalRevenue : Int = 0
    var body: some View {
        NavigationStack{
            VStack {
                if !isPageLoading {
                    ScrollView {
                        VStack(spacing:12){
                            
                            VStack(){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 230)
                                        .foregroundColor(Color("requestCard"))
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                    
                                    // MARK: Total Revenue
                                    HStack(spacing:40) {
                                        VStack(alignment: .leading){
                                            VStack(alignment: .leading){
                                                Text("Total Books")
                                                    .foregroundStyle(Color.gray)
                                                    .font(.title3)
                                                Text("\(librarianViewModel.allBooks.count)")
                                                    .font(.title)
                                                    .bold()
                                                    .padding(.top,2)
                                                    .padding(.leading,2)
                                            }
                                            VStack(alignment: .leading){
                                                HStack{
                                                    VStack(alignment:.leading){
                                                        HStack{
                                                            Circle()
                                                                .fill(Color(themeManager.selectedTheme.primaryThemeColor))
                                                                .frame(width: 10, height: 10)
                                                            Text("\(librarianViewModel.categoryStat[0].category)")
                                                                .font(.caption)
                                                        }
                                                        Text("\(librarianViewModel.categoryStat[0].count)")
                                                            .font(.caption)
                                                    }
                                                    VStack(alignment:.leading){
                                                        HStack{
                                                            Circle()
                                                                .fill(Color(themeManager.selectedTheme.primaryThemeColor.opacity(0.85)))
                                                                .frame(width: 10, height: 10)
                                                            Text("\(librarianViewModel.categoryStat[1].category)")
                                                                .font(.caption)
                                                        }
                                                        Text("\(librarianViewModel.categoryStat[1].count)")
                                                            .font(.caption)
                                                    }
                                                }
                                                HStack{
                                                    VStack(alignment:.leading){
                                                        HStack{
                                                            Circle()
                                                                .fill(Color(themeManager.selectedTheme.primaryThemeColor.opacity(0.65)))
                                                                .frame(width: 10, height: 10)
                                                            Text("\(librarianViewModel.categoryStat[2].category)")
                                                                .font(.caption)
                                                        }
                                                        Text("\(librarianViewModel.categoryStat[2].count)")
                                                            .font(.caption)
                                                    }
                                                    VStack(alignment:.leading){
                                                        HStack{
                                                            Circle()
                                                                .fill(Color(themeManager.selectedTheme.primaryThemeColor.opacity(0.5)))
                                                                .frame(width: 10, height: 10)
                                                            Text("\(librarianViewModel.categoryStat[3].category)")
                                                                .font(.caption)
                                                        }
                                                        Text("\(librarianViewModel.categoryStat[3].count)")
                                                            .font(.caption)
                                                    }
                                                }
                                            }
                                        }
                                        VStack{
                                            Chart(0..<librarianViewModel.categoryStat.count, id: \.self) { dataItem in
                                                SectorMark(angle: .value("type", librarianViewModel.categoryStat[dataItem].count),
                                                           angularInset: 1.5)
                                                .foregroundStyle(themeManager.selectedTheme.primaryThemeColor)
                                                .cornerRadius(24)
                                                .opacity(dataItem == 0 ? 1 : dataItem == 1 ? 0.85 : dataItem == 2 ? 0.65 : 0.5)
                                                .annotation(position: .overlay) {
                                                    let percentage = (Float(librarianViewModel.categoryStat[dataItem].count) / Float(librarianViewModel.allBooks.count)) * 100
                                                    let roundedPercentage = round(percentage)
                                                    Text("\(Int(roundedPercentage))%")
                                                        .foregroundColor(.white)
                                                }
                                                
                                            }
                                            .frame(width: 150)
                                        }
                                    }
                                    .padding()
                                }
                                .onTapGesture {
                                    tabSelection = 3
                                }
                                .padding(.horizontal)
                            }
                            .foregroundStyle(themeManager.selectedTheme.bodyTextColor)
                            
                            // MARK: Member and Books
                            HStack(spacing:12){
                                NavigationLink(destination: MembersView()){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(height: 125)
                                            .foregroundColor(Color("requestCard"))
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        VStack(alignment: .leading){
                                            HStack{
                                                Text("Members")
                                                    .font(.title3)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .font(.subheadline)
                                            }
                                            .foregroundStyle(Color.gray)
                                            Text(String("\(userAuthViewModel.allUsers.count)"))
                                                .font(.title)
                                                .bold()
                                                .padding(.top)
                                                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                        }
                                        .padding(.horizontal)
                                    }.sheet(isPresented: $isMemberSheetPresented) {
                                        MemberDetailView(userAuthViewModel: userAuthViewModel, configViewModel: configViewModel)
                                            .presentationDetents([.fraction(0.90)])
                                    }
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 125)
                                        .foregroundColor(Color("requestCard"))
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Pre-Books")
                                                .font(.title3)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.subheadline)
                                        }
                                        .foregroundStyle(Color.gray)
                                        Text(" \(librarianViewModel.preBookedLoans.count)")
                                            .foregroundStyle(Color(themeManager.selectedTheme.bodyTextColor))
                                            .font(.title)
                                            .bold()
                                            .padding(.top)
                                    }
                                    .padding(.horizontal)
                                }
                                .onTapGesture {
                                    isLogoSelecterSheetPresented = true
                                }
                                .sheet(isPresented: $isLogoSelecterSheetPresented){ preBookView(LibViewModel: librarianViewModel)
                                        //.presentationDetents([.fraction(0.50)])
                                }
                            }
                            .padding(.horizontal)
                            
                            // MARK: Staff and Fine
                            HStack(spacing:12){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 125)
                                        .foregroundColor(Color("requestCard"))
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Borrow Requests")
                                                .font(.title3)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.subheadline)
                                        }
                                        .foregroundStyle(Color.gray)
                                        Text(String("\(librarianViewModel.requestedLoans.count)"))
                                            .foregroundStyle(Color(themeManager.selectedTheme.bodyTextColor))
                                            .font(.title)
                                            .bold()
                                            .padding([.top],5)
                                    }
                                    .padding(.horizontal)
                                }
                                .onTapGesture {
                                    actionSelection = .CheckOut
                                    tabSelection = 2
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 125)
                                        .foregroundColor(Color("requestCard"))
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text("Return Requests")
                                                .font(.title3)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.subheadline)
                                        }
                                        .foregroundStyle(Color.gray)
                                        Text(" \(librarianViewModel.issuedLoans.count)")
                                            .foregroundStyle(Color(themeManager.selectedTheme.bodyTextColor))
                                            .font(.title)
                                            .bold()
                                            .padding(.top,5)
                                    }
                                    .padding(.horizontal)
                                }
                                .onTapGesture {
                                    actionSelection = .CheckIn
                                    tabSelection = 2
                                }
                                
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .padding(.vertical)
                        .navigationTitle("Trove")
                        .navigationBarItems(trailing: NavigationLink(destination: LibProfileView(LibViewModel: librarianViewModel, configViewModel: configViewModel, staffViewModel: staffViewModel), label: {
                            Image(systemName: "person.crop.circle")
                                .font(.title3)
                                .foregroundColor(Color(themeManager.selectedTheme.primaryThemeColor))
                        }))
                    }
                }
                else{
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
            .onAppear {
                Task{
                    isPageLoading = true
                    if let currentUser = Auth.auth().currentUser?.uid{
                        print(currentUser)
                        staffViewModel.fetchStaffData(staffID: currentUser)
                    }
                    userAuthViewModel.fetchAllUsers()
                    librarianViewModel.getLoans()
                    librarianViewModel.getBooks()
                    staffViewModel.getStaff()
                    staffViewModel.getAllStaff()
                    await librarianViewModel.getCategoryStat()
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    isPageLoading = false
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Trove")
    }
}

struct preBookView: View {
    
    @ObservedObject var LibViewModel: LibrarianViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray4))
                    .frame(width: 100,height: 5)
                    .padding(.bottom)
                if(LibViewModel.preBookedLoans.count != 0){
                    ScrollView{
                        VStack{
                            ForEach(0..<LibViewModel.preBookedLoans.count, id: \.self) { userDetail in
                                NavigationLink(destination: RecordBookDetail(checkInDetails: LibViewModel.preBookedLoans[userDetail], LibViewModel: LibViewModel)){
                                    BookRequestCustomBox(bookRequestData: LibViewModel.preBookedLoans[userDetail])
                                }
                            }
                        }
                    }
                }
                else{
                    EmptyPage()
                }
            }
            .padding(.vertical, 20)
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        @StateObject var staffViewMod = StaffViewModel()
        @StateObject var LibViewModel = LibrarianViewModel()
        @StateObject var userAuthViewModel = AuthViewModel()
        @StateObject var configViewModel = ConfigViewModel()
        @State var int: Int = 0
        @State var actionSelection: Option = .CheckOut
        return Dashboard(librarianViewModel: LibViewModel, staffViewModel: staffViewMod, userAuthViewModel: userAuthViewModel, configViewModel: configViewModel, tabSelection: $int, actionSelection: $actionSelection)
            .environmentObject(themeManager)
    }
}
