//
//  MemberBookDetailView.swift
//  Library Management System
//
//  Created by user2 on 30/04/24.
//

import SwiftUI
import FirebaseAuth

struct MemberBookDetailView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var book: Book
    @State var userData: AuthViewModel
    @State var bookRequest: UserBooksModel
    @State var prebookRequest: UserBooksModel
    @State var navigateToHome = false
    @State var showAlert = false
    
    // TipKit
    var tipBorrow = borrowTip()
    var tipPreBook = preBookTip()
    
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let halfScreenWidth = screenWidth / 2
        let wideScreenWidth = screenWidth * 0.70
        ScrollView{
            ZStack(alignment: .top){
                VStack(spacing:0){
                    Rectangle()
                        .fill(themeManager.selectedTheme.secondaryThemeColor)
                        .cornerRadius(45)
                        .frame(height: 600)
                        .frame(maxWidth: .infinity)
                        .position(CGPoint(x: halfScreenWidth, y: -70.0))
                }
                VStack{
                    VStack{
                        
                        Text(book.bookName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .frame(maxWidth: wideScreenWidth)
                        AsyncImage(url: URL(string: book.bookImageURL)) { image in
                            image.resizable().shadow(color: Color(.systemGray).opacity(0.3), radius: 5, x: 0, y: 4)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 200,height: 300)
                        .cornerRadius(8)
                        
                        
                    }
                    
                    VStack{
                        HStack {
                            Text("By")
                                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                            
                            Text("\(book.bookAuthor)")
                                .fontWeight(.bold)
                                
                        }
                        .padding(5)

                        
                        HStack{
                            VStack{
                                if(book.bookStatus == "PreBook"){
                                    Text("Wait List")
                                    Text(String(book.bookPreBookedCount))
                                }
                                else{
                                    Text("Available")
                                    Spacer()
                                    Text(String(book.bookAvailableCount))
                                }
                            }
                            Divider()
                                .background(.black)
                                .frame( height: 50)
                                .padding(.horizontal,12)
                            VStack{
                                Text("Rating")
                                Spacer()
                                Text(String(book.bookRating))
                            }
                            Divider()
                                .background(.black)
                                .frame( height: 50)
                                .padding(.horizontal,12)
                            VStack{
                                Text("Category")
                                Spacer()
                                Text(book.bookCategory)
                            }
                            
                            
                        }
                        .padding(25)
                        .frame( height: 90)
                        .font(.title3)
                        .background{
                            Rectangle()
                                .fill(themeManager.selectedTheme.secondaryThemeColor)
                                .cornerRadius(24)
                        }
                        .padding(10)
                        
                        if book.bookAvailableCount != 0 {
                             Button(action: {
                                Task{
                                    bookRequest.requestBook(bookId: book.id, bookName: book.bookName, bookImageURL: book.bookImageURL, userId: userData.userID, userName: userData.userName, bookAvailableCount: book.bookAvailableCount, bookTakenCount: book.bookTakenCount, loanPeriod: 1)
                                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                                    if(bookRequest.responseStatus == 200){
                                        showAlert = true
                                        if let userID = Auth.auth().currentUser?.uid {
                                            userData.fetchUserData(userID: userID)
                                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                                        }
                                    }
                                }
                                
                                
                            }) {
                                Text("Get Book")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(themeManager.selectedTheme.primaryThemeColor))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background{
                                        Rectangle()
                                            .fill(Color(.systemGray4))
                                            .cornerRadius(24)
                                    }
                                    .cornerRadius(15)
                                    .padding([.leading, .trailing])
                                    .padding([.leading, .trailing])
                                    .popoverTip(tipBorrow)
                            }
                        } else {
                             Button(action: {
                                
                                Task{
                                    prebookRequest.preBook(bookId: book.id, bookName: book.bookName, bookImageURL: book.bookImageURL, userId: userData.userID, userName: userData.userName, bookPreBookedCount: book.bookPreBookedCount, loanPeriod: 1)
                                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                                    if(prebookRequest.responseStatus == 200){
                                        showAlert = true
                                        if let userID = Auth.auth().currentUser?.uid {
                                            userData.fetchUserData(userID: userID)
                                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                                        }
                                    }
                                }
                                
                                
                            }) {
                                Text("Pre Book")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(themeManager.selectedTheme.primaryThemeColor))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background{
                                        Rectangle()
                                            .fill(Color(.systemGray4))
                                            .cornerRadius(24)
                                    }
                                    .cornerRadius(15)
                                    .padding([.leading, .trailing])
                                    .padding([.leading, .trailing])
                                    .popoverTip(tipPreBook)
                            }
                        }
                        
                        
                        VStack(alignment:.leading){
                            Text("Synopsis")
                                .font(.title.bold())
                                .padding(.horizontal)
                                .padding(.top, 20)
                            Text(book.bookDescription)
                                .padding(.top,8)
                                .padding(.horizontal)
                                .lineSpacing(10)
                        }.padding(10)
                        VStack(alignment:.leading){
                            Text("Reviews")
                                .font(.title.bold())
                                .padding(.horizontal)
                                .padding(.top, 20)
                            List{
                                ForEach(book.bookReviews, id: \.self){ review in
                                    HStack(alignment: .center){
                                        Image(systemName: "person.circle")
                                            .symbolRenderingMode(.hierarchical)
                                            .font(.system(.title))
                                        Text(review)
                                            .font(.system(.subheadline))
                                        Spacer()
                                    }
                                    .padding(.vertical,10)
                                }
                            }
                            .listStyle(.inset)
                        }.padding(10)
                        
                    }
                    
                }
            }
            
        }
        .alert(isPresented: $showAlert) { () -> Alert in
                                let button = Alert.Button.default(Text("OK")) {
                                    print("OK Button Pressed")
                                }
                                return Alert(title: Text("Confirmation"), message: Text("Booking confirmed for selected book"), dismissButton: button)
                     }
        .onAppear {
            Task{
                if let userID = Auth.auth().currentUser?.uid {
                    userData.fetchUserData(userID: userID)
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
        }
        .padding(.bottom)
    }
}


struct MemberBookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        MemberBookDetailView(
            book: Book(
                id: "ED4x3Tkc2OdiIUhACkGJ",
                bookISBN: "124-435-233",
                bookImageURL: "https://firebasestorage.googleapis.com:443/v0/b/library-management-syste-6cc1e.appspot.com/o/bookImages%2FED4x3Tkc2OdiIUhACkGJ.jpeg?alt=media&token=b0b4217f-93df-4baa-b94d-9858d17ff7ef",
                bookName: "Harry Potter",
                bookAuthor: "JK Rowling",
                bookDescription: "Harry Potter is a series of seven fantasy novels written by British author J. K. Rowling. The novels chronicle the lives of a young wizard, Harry Potter, and his friends Hermione Granger and Ron Weasley, all of whom are students at Hogwarts School of Witchcraft and Wizardry.",
                bookCategory: "Fantasy",
                bookSubCategories: ["Sci-Fi"],
                bookPublishingDate: "26/6/1997, 12:23 PM",
                bookStatus: "Available",
                bookCount: 0,
                bookAvailableCount: 2,
                bookPreBookedCount: 0,
                bookTakenCount: 0,
                bookIssuedTo: ["2432345"],
                bookIssuedToName: ["Rishi"],
                bookIssuedOn: [],
                bookExpectedReturnOn: ["4/5/2024, 8:10 PM"],
                bookRating: 0,
                bookReviews: [],
                bookHistory: [],
                createdOn: "2024-04-29 06:54:48 +0000",
                updayedOn: "29/4/2024, 11:56 PM"
            ),
            userData: AuthViewModel(),
            bookRequest: UserBooksModel(), prebookRequest: UserBooksModel()
            
        ).environmentObject(themeManager)
    }
}
