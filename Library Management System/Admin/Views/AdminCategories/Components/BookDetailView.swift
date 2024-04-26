//
//  BookDetailView.swift
//  Library Management System
//
//  Created by user2 on 25/04/24.
//

import SwiftUI

struct BookDetailView: View {
    
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var ConfiViewModel: ConfigViewModel
    @State var currentBookId: String = "H47KYrYF7tw60pDcxIzu"
    
    @State var bookISBN: String = "123-456-789"
    @State var bookImage: UIImage = UIImage()
    @State var bookImageURL: String = "https://firebasestorage.googleapis.com:443/v0/b/library-management-syste-6cc1e.appspot.com/o/bookImages%2FHYPN2p1ppcF08iMXPUBy.jpeg?alt=media&token=f1b0226d-b3c6-434c-a117-f63f73ca13db"
    @State var bookName: String = "Harry Potter"
    @State var bookAuthor: String = "J.K Rowling"
    @State var bookStatus: String = "Active"
    @State var bookDescription: String = "skygakjhvbejgfvkajsvhbekjhvbskjvbekjhvbskjvhkjshgvsjvsjvbkdsjhvkhjvdkjbdvf"
    @State var bookPublishingDate: Date = Date.now
    @State var bookCategory: String = "Adventure"
    @State var bookSubCategory: String = ""
    @State var bookSubCategories: [String] = ["Sci-Fi","Fantasy"]
    @State var bookIssuedTo: String = ""
    @State var bookIssuedToName: String = ""
    @State var bookIssuedOn: String = ""
    @State var bookExpectedReturnOn: String = ""
    @State var bookRating: Float = 0.0
    @State var bookReviews: [String] = []
    @State var bookHistory: [History] = []
    @State var createdOn: String = ""
    @State var updayedOn: String = ""
    
    @State var fileName: String = ""
    @State var isImageSelected: Bool = false
    @State var openPhotoPicker: Bool = false
    
    @State var isPageLoading: Bool = false
    @State var isButtonLoading: Bool = false
    @State var isPopupShown: Bool = false
    @State var popupMessage: String = ""
    
    @State var canEdit: Bool = false
    
    @State private var docState: DocState? = .setup
    
    enum DocState: Int {
        case setup = 0
        case ready = 1
    }
    
    func dataLoader() async{
        print(currentBookId)
        LibViewModel.getBook(bookId: currentBookId)
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        ConfiViewModel.fetchConfig()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.date(from:String(LibViewModel.currentBook[0].bookPublishingDate.split(separator: ",")[0]))!
        bookISBN = LibViewModel.currentBook[0].bookISBN
        bookImageURL = LibViewModel.currentBook[0].bookImageURL
        bookName = LibViewModel.currentBook[0].bookName
        bookAuthor = LibViewModel.currentBook[0].bookAuthor
        bookStatus = LibViewModel.currentBook[0].bookStatus
        bookPublishingDate = date
        bookCategory = LibViewModel.currentBook[0].bookCategory
        bookSubCategories = LibViewModel.currentBook[0].bookSubCategories
        bookDescription = LibViewModel.currentBook[0].bookDescription
        bookIssuedOn = LibViewModel.currentBook[0].bookIssuedOn
        bookIssuedTo = LibViewModel.currentBook[0].bookIssuedTo
        bookIssuedToName = LibViewModel.currentBook[0].bookIssuedToName
        bookExpectedReturnOn = LibViewModel.currentBook[0].bookExpectedReturnOn
        bookRating = LibViewModel.currentBook[0].bookRating
        bookReviews = LibViewModel.currentBook[0].bookReviews
        bookHistory = LibViewModel.currentBook[0].bookHistory
        createdOn = LibViewModel.currentBook[0].createdOn
        updayedOn = LibViewModel.currentBook[0].updayedOn
        isPageLoading.toggle()
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("BgColor")
                    
                ScrollView{
                    VStack(spacing: 26){
                        HStack{
                            Text("Update Book")
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity)
                            Button(action:{
                                canEdit.toggle()
                            }){
                                if(!canEdit){
                                    VStack{
                                        HStack{
                                            Spacer()
                                            Text("Edit")
                                                .font(.system(size: 18, weight: .regular))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                else{
                                    VStack{
                                        HStack{
                                            Spacer()
                                            Text("Cancel")
                                                .font(.system(size: 18, weight: .regular))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        if(isPageLoading){
                            Spacer()
                            
                            ProgressView()
                                .font(.system(size: 24, weight: .regular))
                            Spacer()
                        }
                        else{
                            VStack(spacing: 20){
                                HStack{
                                    Button(action:{
                                        openPhotoPicker.toggle()
                                    }){
                                        if(!isImageSelected){
                                            AsyncImage(url: URL(string: bookImageURL)) { image in
                                                image.resizable()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 120,height: 180)
                                            .cornerRadius(8)
                                        }
                                        else{
                                            Image(uiImage: bookImage)
                                                .resizable()
                                                .frame(width: 120,height: 180)
                                                .cornerRadius(8)
                                        }
                                    }
                                    .disabled(!canEdit)
                                    VStack(spacing: 20){
                                        HStack{
                                            Text("ISBN")
                                                .font(.system(size: 18, weight: .bold))
                                            Spacer()
                                            TextField(bookISBN,text: $bookISBN)
                                                .font(.system(size: 18, weight: .regular))
                                                .scaledToFit()
                                                .disabled(!canEdit)
                                        }
                                        .frame(maxWidth: .infinity)
                                        HStack{
                                            Text("Name")
                                                .font(.system(size: 18, weight: .bold))
                                            Spacer()
                                            TextField(bookName,text: $bookName)
                                                .font(.system(size: 18, weight: .regular))
                                                .scaledToFit()
                                                .disabled(!canEdit)
                                        }
                                        .frame(maxWidth: .infinity)
                                        HStack{
                                            Text("Author")
                                                .font(.system(size: 18, weight: .bold))
                                            Spacer()
                                            TextField(bookAuthor,text: $bookAuthor)
                                                .font(.system(size: 18, weight: .regular))
                                                .scaledToFit()
                                                .disabled(!canEdit)
                                        }
                                        .frame(maxWidth: .infinity)
                                        HStack{
                                            Text("Status")
                                                .font(.system(size: 18, weight: .bold))
                                            Spacer()
                                            if(canEdit){
                                                Picker("",selection: $bookStatus){
                                                    Text("Available").tag("Available")
                                                    Text("PreBooked").tag("PreBooked")
                                                    Text("Taken").tag("Taken")
                                                }
                                                .padding(0)
                                                .accentColor(.black)
                                                .labelsHidden()
                                                .disabled(!canEdit)
                                            }
                                            else{
                                                Text("\(bookStatus)")
                                                    .font(.system(size: 18, weight: .regular))
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(8)
                                }
                                VStack(spacing: 20){
                                    HStack{
                                        Text("Publishing Date")
                                            .font(.system(size: 18, weight: .bold))
                                        Spacer()
                                        if(canEdit){
                                            DatePicker("", selection: $bookPublishingDate, displayedComponents: .date)
                                                .disabled(!canEdit)
                                        }
                                        else{
                                            Text("\(bookPublishingDate.formatted(date: .abbreviated,time: .omitted))")
                                                .font(.system(size: 18, weight: .regular))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    HStack{
                                        Text("Category")
                                            .font(.system(size: 18, weight: .bold))
                                        Spacer()
                                        if(canEdit){
                                            Picker("", selection: $bookCategory){
                                                Text("Choose").tag("Choose")
                                                if(!ConfiViewModel.currentConfig.isEmpty){
                                                    ForEach(ConfiViewModel.currentConfig[0].categories, id: \.self){ category in
                                                        Text(category).tag(category)
                                                    }
                                                }
                                            }
                                            .accentColor(.black)
                                            .labelsHidden()
                                            .disabled(!canEdit)
                                        }
                                        else{
                                            Text("\(bookCategory)")
                                                .font(.system(size: 18, weight: .regular))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .padding(10)
                                .background(.white)
                                .cornerRadius(8)
                                VStack(spacing: 20){
                                    HStack{
                                        Text("Sub Category")
                                            .font(.system(size: 18, weight: .bold))
                                        Spacer()
                                        if(canEdit){
                                            Picker("", selection: $bookSubCategory){
                                                Text("Choose").tag("Choose")
                                                if(!ConfiViewModel.currentConfig.isEmpty){
                                                    ForEach(ConfiViewModel.currentConfig[0].categories, id: \.self){ category in
                                                        Text(category).tag(category)
                                                    }
                                                }
                                            }
                                            .accentColor(.black)
                                            .labelsHidden()
                                            .disabled(!canEdit)
                                            .onChange(of: bookSubCategory, initial: true){ (oldValue,newValue)  in
                                                if(newValue != oldValue && newValue != "Choose" && !bookSubCategories.contains(newValue)){
                                                    bookSubCategories.append(bookSubCategory)
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    if(!bookSubCategories.isEmpty){
                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], content: {
                                            ForEach(0..<bookSubCategories.count, id: \.self){ index in
                                                HStack{
                                                    Text(bookSubCategories[index])
                                                    Spacer()
                                                    Button(action:{
                                                        bookSubCategories.remove(at: bookSubCategories.firstIndex(of: bookSubCategories[index])!)
                                                    }){
                                                        Image(systemName: "xmark")
                                                    }
                                                    .disabled(!canEdit)
                                                }
                                                .padding(10)
                                                .foregroundColor(.black)
                                                .background(Color("PrimaryColor").opacity(0.25))
                                                .cornerRadius(8)
                                            }
                                        })
                                    }
                                }
                                .padding(10)
                                .background(.white)
                                .cornerRadius(8)
                                VStack(alignment: .leading,spacing: 20){
                                    Text("Description")
                                        .font(.system(size: 18, weight: .bold))
                                    TextField(bookDescription, text: $bookDescription, axis: .vertical)
                                        .lineLimit(3...7)
                                        .disabled(!canEdit)
                                }
                                .padding(10)
                                .background(.white)
                                .cornerRadius(8)
                                Spacer()
                                if(canEdit){
                                    Button(action:{
                                        Task{
                                            isButtonLoading.toggle()
                                            LibViewModel.updateBook(bookId: currentBookId, bookISBN: bookISBN, bookImageURL: bookImageURL, bookName: bookName, bookAuthor: bookAuthor, bookDescription: bookDescription, bookCategory: bookCategory, bookSubCategories: bookSubCategories, bookPublishingDate: bookPublishingDate.formatted(), bookStatus: bookStatus, bookImage: bookImage, isImageUpdated: isImageSelected, bookIssuedTo: bookIssuedTo, bookIssuedToName: bookIssuedToName, bookIssuedOn: bookIssuedOn, bookExpectedReturnOn: bookExpectedReturnOn, bookRating: bookRating, bookReviews: bookReviews, bookHistory: bookHistory, createdOn: createdOn, updatedOn: updayedOn)
                                            if(isImageSelected){
                                                try? await Task.sleep(nanoseconds: 5_000_000_000)
                                                isButtonLoading.toggle()
                                                isPageLoading.toggle()
                                                await dataLoader()
                                            }
                                            else{
                                                try? await Task.sleep(nanoseconds: 2_000_000_000)
                                                isButtonLoading.toggle()
                                                isPageLoading.toggle()
                                                await dataLoader()
                                            }
                                        }
                                    }){
                                        if(isButtonLoading){
                                            Text("Updating....")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .frame(maxWidth: .infinity)
                                                .background(Color("PrimaryColor").opacity(0.5))
                                                .cornerRadius(8)
                                                .disabled(isButtonLoading)
                                        }
                                        else{
                                            Text("Update Book")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .frame(maxWidth: .infinity)
                                                .background(Color("PrimaryColor"))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                else{
                                    NavigationLink(destination: BooksPage(LibViewModel: LibViewModel, ConfiViewMmodel: ConfiViewModel), tag: .ready, selection: $docState){
                                        Button(action:{
                                            Task{
                                                isButtonLoading.toggle()
                                                LibViewModel.deleteBook(bookId: currentBookId)
                                                try? await Task.sleep(nanoseconds: 3_000_000_000)
                                                print(LibViewModel.responseStatus)
                                                if(LibViewModel.responseStatus == 200){
                                                    docState = .ready
                                                }
                                                else{
                                                    isButtonLoading = false
                                                    popupMessage = LibViewModel.responseMessage
                                                    isPopupShown.toggle()
                                                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                                                    withAnimation{
                                                        isPopupShown.toggle()
                                                    }
                                                }
                                            }
                                        }){
                                            if(isButtonLoading){
                                                Text("Deleting....")
                                                    .font(.system(size: 18, weight: .medium))
                                                    .foregroundColor(.white)
                                                    .padding(10)
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color("PrimaryColor").opacity(0.5))
                                                    .cornerRadius(8)
                                                    .disabled(isButtonLoading)
                                            }
                                            else{
                                                Text("Delete Book")
                                                    .font(.system(size: 18, weight: .medium))
                                                    .foregroundColor(.white)
                                                    .padding(10)
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color("PrimaryColor"))
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal,10)
                }
                .fullScreenCover(isPresented: $openPhotoPicker) {
                    ImagePicker(selectedImage: $bookImage, isImageSelected: $isImageSelected, sourceType: .photoLibrary).frame(maxHeight: .infinity).ignoresSafeArea(.all)
                }
                
                if(isPopupShown){
                    VStack{
                        Text("\(popupMessage)")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color("PrimaryColor").opacity(0.75))
                            .cornerRadius(100)
                    }
                    .offset(y:-320)
                }
            }
            .padding(.vertical,20)
            .background(.black.opacity(0.05))
            
            .task {
                do{
                    isPageLoading.toggle()
                    await dataLoader()
                    
                }
            }
        }
    }
}

struct ADPrev: View {
    
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    
    var body: some View {
        UpdateBookPage(LibViewModel: LibViewModel, ConfiViewModel: ConfiViewModel)
    }
}

#Preview {
    UBPrev()
}
