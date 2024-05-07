import SwiftUI

struct AddBookPage: View {
    
    @ObservedObject var LibViewModel: LibrarianViewModel
    @ObservedObject var ConfiViewModel: ConfigViewModel
    
    @State var bookISBN: String = ""
    @State var bookName: String = ""
    @State var bookAuthor: String = ""
    @State var bookDescription: String = ""
    @State var bookCategory: String = ""
    @State var bookSubCategories: [String] = []
    @State var bookSubCategory: String = ""
    @State var bookPublishingDate: Date = Date.now
    @State var bookStatus: String = "Available"
    @State var bookCount: String = ""
    @State var bookImage: UIImage = UIImage()
    
    @State var fileName: String = ""
    @State var isImageSelected: Bool = false
    @State var openPhotoPicker: Bool = false
    
    @State var isPageLoading: Bool = false
    @State var isPopupShown: Bool = false
    @State var popupMessage: String = ""
    
    @State private var docState: DocState? = .setup
        
    @EnvironmentObject var themeManager: ThemeManager
    enum DocState: Int {
        case setup = 0
        case ready = 1
    }
    
    func formValidation() -> Bool{
        var formValid: Bool = true
        if(bookName.isEmpty){
            formValid = false
        }
        if(bookISBN.isEmpty){
            formValid = false
        }
        if(bookAuthor.isEmpty){
            formValid = false
        }
        if(bookDescription.isEmpty){
            formValid = false
        }
        if(bookCount.isEmpty){
            formValid = false
        }
        if(bookCategory.isEmpty || bookCategory == "Choose"){
            formValid = false
        }
        if(bookSubCategories.isEmpty){
            formValid = false
        }
        if(!isImageSelected){
            formValid = false
        }
        if(formValid){
            return true
        }
        else{
            popupMessage = "Please fill all the fields"
            return false
        }
    }
    
    func getData(){
        ConfiViewModel.fetchConfig()
        //try? await Task.sleep(nanoseconds: 3_000_000_000)
        
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    VStack(spacing: 26){
                        HStack(alignment: .center){
                            NavigationLink( destination: BooksPage(LibViewModel: LibViewModel, ConfiViewMmodel: ConfiViewModel) ){
                                VStack(alignment: .leading){
                                    HStack{
                                        Image(systemName: "chevron.left")
                                            .symbolRenderingMode(.hierarchical)
                                            .font(.system(size: 18, weight: .medium))
                                        Spacer()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            Text("Add Bok")
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity)
                            Text("   ")
                                .frame(maxWidth: .infinity)
                        }
                        if(!isImageSelected){
                            VStack{
                                Button(action:{
                                    openPhotoPicker.toggle()
                                }){
                                    VStack(spacing:9){
                                        Image(systemName: "icloud.and.arrow.up")
                                            .font(.system(size: 28, weight: .bold))
                                        Text("Select book image")
                                            .font(.system(size: 18, weight: .thin))
                                    }
                                }
                                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                            }
                            .padding(20)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5]))
                                    .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                            .frame(width: 360, height: 111)
                            })
                        }
                        else{
                            Button(action:{openPhotoPicker.toggle()}){
                                Image(uiImage: bookImage)
                                    .resizable()
                                    .frame(width: 120, height: 180)
                                    .cornerRadius(8)
                            }
                        }
                        VStack(spacing: 20){
                            VStack(spacing:20){
                                TextField("Book ISBN", text: $bookISBN)
                                    .padding(5)
                                    .autocorrectionDisabled()
                                    .autocapitalization(.none)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1, alignment: .bottom)
                                            .foregroundColor(.black.opacity(0.1)),
                                        alignment: .bottom
                                    )
                                TextField("Book Name", text: $bookName)
                                    .padding(5)
                                    .autocorrectionDisabled()
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1, alignment: .bottom)
                                            .foregroundColor(.black.opacity(0.1)),
                                        alignment: .bottom
                                    )
                                TextField("Book Author", text: $bookAuthor)
                                    .padding(5)
                                    .autocorrectionDisabled()
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1, alignment: .bottom)
                                            .foregroundColor(.black.opacity(0.1)),
                                        alignment: .bottom
                                    )
                                TextField("No of Copies", text: $bookCount)
                                    .padding(5)
                                    .autocorrectionDisabled()
                                    .keyboardType(.numberPad)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1, alignment: .bottom)
                                            .foregroundColor(.black.opacity(0.1)),
                                        alignment: .bottom
                                    )
                            }
                            .padding(10)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                            TextField("Book Description", text: $bookDescription, axis: .vertical)
                                .lineLimit(5...5)
                                .padding(10)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                                .autocorrectionDisabled()
                                .autocapitalization(.sentences)
                        VStack{
                                HStack(){
                                    Text("Book Status").foregroundColor(Color(.systemGray))
                                    Spacer()
                                    Picker("", selection: $bookStatus){
                                        Text("Available").tag("Available")
                                        Text("PreBooked").tag("PreBooked")
                                        Text("Taken").tag("Taken")
                                    }
                                    .accentColor(themeManager.selectedTheme.bodyTextColor)
                                    .labelsHidden()
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                                HStack{
                                    Text("Book publish Date").foregroundColor(Color(.systemGray))
                                    Spacer()
                                    DatePicker("", selection: $bookPublishingDate, displayedComponents: .date)
                                        .labelsHidden()
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                            }
                            VStack(spacing:20){
                                HStack{
                                    Text("Categories")
                                    Spacer()
                                    Picker("", selection: $bookCategory){
                                        Text("Choose").tag("Choose")
                                        if(!ConfiViewModel.currentConfig.isEmpty){
                                            ForEach(ConfiViewModel.currentConfig[0].categories, id: \.self){ category in
                                                Text(category).tag(category)
                                            }
                                        }
                                    }
                                    .accentColor(themeManager.selectedTheme.bodyTextColor)
                                }
                                Divider()
                                VStack(spacing: 10){
                                    HStack{
                                        Text("Sub Categories")
                                        Spacer()
                                        Picker("", selection: $bookSubCategory){
                                            Text("Choose").tag("Choose")
                                            if(!ConfiViewModel.currentConfig.isEmpty){
                                                ForEach(ConfiViewModel.currentConfig[0].categories, id: \.self){ category in
                                                    Text(category).tag(category)
                                                }
                                            }
                                        }
                                        .accentColor(themeManager.selectedTheme.bodyTextColor)
                                        .onChange(of: bookSubCategory, initial: true){ (oldValue,newValue)  in
                                            if(newValue != oldValue && newValue != "Choose" && !bookSubCategories.contains(newValue)){
                                                bookSubCategories.append(bookSubCategory)
                                            }
                                        }
                                    }
                                    if(!bookSubCategories.isEmpty){
                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))], content: {
                                            ForEach(0..<bookSubCategories.count, id: \.self){ index in
                                                HStack{
                                                    Text(bookSubCategories[index])
                                                    Spacer()
                                                    Button(action:{
                                                        bookSubCategories.remove(at: bookSubCategories.firstIndex(of: bookSubCategories[index])!)
                                                    }){
                                                        Image(systemName: "xmark")
                                                    }
                                                }
                                                .padding(10)
                                                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                                .cornerRadius(8)
                                            }
                                        })
                                    }
                                    else{
                                        Text("No categories added")
                                            .font(.system(size: 14, weight: .light))
                                    }
                                }
                            }
                            .padding(10)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                            
                            VStack{
                                Text("All fields are mandatory")
                                    .font(.system(size: 15, weight: .thin))
                                NavigationLink(destination: BooksPage(LibViewModel: LibViewModel, ConfiViewMmodel: ConfiViewModel), tag: .ready, selection: $docState){
                                    Button(action:{
                                        Task{
                                            if(formValidation()){
                                                isPageLoading = true
                                                LibViewModel.addBook(bookISBN: bookISBN, bookName: bookName, bookAuthor: bookAuthor, bookDescription: bookDescription, bookCategory: bookCategory, bookSubCategories: bookSubCategories, bookPublishingDate: bookPublishingDate.formatted(), bookStatus: bookStatus, bookCount: Int(bookCount)!, bookAvailableCount: Int(bookCount)!, bookPreBookedCount: 0, bookTakenCount: 0, bookImage: bookImage)
                                                try? await Task.sleep(nanoseconds: 3_000_000_000)
                                                if(LibViewModel.responseStatus == 200){
                                                    docState = .ready
                                                }
                                                else{
                                                    isPageLoading = false
                                                    popupMessage = LibViewModel.responseMessage
                                                    isPopupShown.toggle()
                                                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                                                        withAnimation{
                                                            isPopupShown.toggle()
                                                        }
                                                }
                                            }
                                            else{
                                                isPopupShown.toggle()
                                                try? await Task.sleep(nanoseconds: 2_000_000_000)
                                                    withAnimation{
                                                        isPopupShown.toggle()
                                                    }
                                            }
                                        }
                                    }){
                                        if(isPageLoading){
                                            Text("Adding....")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                                .padding(10)
                                                .frame(maxWidth: .infinity)
                                                .background(themeManager.selectedTheme.secondaryThemeColor)
                                                .cornerRadius(8)
                                                .disabled(isPageLoading)
                                        }
                                        else{
                                            Text("Add Book")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                                                .padding(10)
                                                .frame(maxWidth: .infinity)
                                                .background(themeManager.selectedTheme.secondaryThemeColor)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                        .font(.system(size: 18, weight: .regular))
                    }
                    .padding(.horizontal, 10)
                }.fullScreenCover(isPresented: $openPhotoPicker) {
                    ImagePicker(selectedImage: $bookImage, isImageSelected: $isImageSelected, sourceType: .photoLibrary).frame(maxHeight: .infinity).ignoresSafeArea(.all)
                }
                if(isPopupShown){
                    VStack{
                        Text("\(popupMessage)")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(themeManager.selectedTheme.bodyTextColor)
                            .padding(10)
                            .cornerRadius(100)
                    }
                    .offset(y:-320)
                }
            }
            .background(.black.opacity(0.05))
            .task {
                getData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ABPreview: View {
    
    @StateObject var LibViewModel = LibrarianViewModel()
    @StateObject var ConfiViewModel = ConfigViewModel()
    let themeManager = ThemeManager()
    var body: some View {
        AddBookPage(LibViewModel: LibViewModel, ConfiViewModel: ConfiViewModel)
    }
}


struct ABPreview_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return ABPreview()
            .environmentObject(themeManager)
    }
}

