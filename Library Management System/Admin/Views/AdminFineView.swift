import SwiftUI

struct AdminFineView: View {
    @ObservedObject var configViewModel: ConfigViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var fineDetailsList: [fineDetails] = []
    @State private var newFineDays: Int = 0
    @State private var newFineAmount: Int = 0
    @State private var loanPeriod: Int = 0
    @State private var maxFine: Double = 0
    @State private var maxPenalties: Int = 0
    @State private var isEditMode: Bool = false
    @State private var newSlab: Bool = false
    @State var isPageLoading: Bool = true
    
    var body: some View {
        NavigationStack {
            if !isPageLoading {
                Form{
                    ForEach(fineDetailsList.indices, id: \.self) { index in
                        Section(header: Text("Fine Slab \(index+1)")){
                            HStack{
                                Text("After")
                                Spacer()
                                if isEditMode{
                                    Stepper(value: $fineDetailsList[index].period, in: 0...Int(maxFine)) {
                                        HStack {
                                            Spacer()
                                            Text("\(fineDetailsList[index].period) Days")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                else{
                                    Text("\(fineDetailsList[index].period) Days")
                                        .foregroundColor(.secondary)
                                }
                            }
                            HStack{
                                Text("Fine Amount")
                                Spacer()
                                if isEditMode{
                                    Stepper(value: $fineDetailsList[index].fine, in: 0...Int(maxFine)) {
                                        HStack {
                                            Spacer()
                                            Text("₹ \(fineDetailsList[index].fine)")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                else{
                                    Text("\(fineDetailsList[index].fine)")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    if isEditMode{
                        if newSlab{
                            Section(header: Text("New Fine Slab")){
                                VStack{
                                    HStack{
                                        Text("After")
                                        Spacer()
                                        Stepper(value: $newFineDays, in: 0...Int(maxFine)) {
                                            HStack {
                                                Spacer()
                                                Text("\(newFineDays) Days")
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                    HStack{
                                        Text("Fine Amount")
                                        Spacer()
                                        Stepper(value: $newFineAmount, in: 0...Int(maxFine)) {
                                            HStack {
                                                Spacer()
                                                Text("₹ \(newFineAmount)")
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                    
                                    Button(action:{
                                        fineDetailsList.append(fineDetails(fine: newFineAmount, period: newFineDays))
                                        newFineDays = 0
                                        newFineAmount = 0
                                    }){
                                        Text("Add")
                                            .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                    }
                                }
                            }
                        }
                        else{
                            HStack{
                                Text("Add new slab")
                                Spacer()
                                Button(action:{newSlab.toggle()}){
                                    Image(systemName: "plus")
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                                }
                            }
                        }
                    }
                    if isEditMode {
//                            HStack {
//                                Text("Loan Period")
//                                Stepper(value: $loanPeriod, in: 1...31) {
//                                    HStack {
//                                        Spacer()
//                                        Text("\(loanPeriod) days")
//                                            .foregroundColor(.secondary)
//                                    }
//                                }
//                            }
                        Section(header: Text("Fine Limit")){
                            HStack {
                                Text("Maximum Fine")
                                Stepper(value: $maxFine, in: 1...10000) {
                                    HStack {
                                        Spacer()
                                        Text("₹ \(maxFine, specifier: "%.0f")")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    } else {
//                            HStack {
//                                Text("Loan Period")
//                                Spacer()
//                                Text("\(loanPeriod) days")
//                                    .foregroundColor(.secondary)
//                            }
                        ZStack {
                            Section(header: Text("Fine Limit")){
                                HStack {
                                    Text("Maximum Fine")
                                    Spacer()
                                    Text("₹ \(maxFine, specifier: "%.0f")")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
//                List {
//                    Section {
//                        ForEach(fineDetailsList.indices, id: \.self) { index in
//                            HStack {
//                                if isEditMode {
//                                    Text("After \(fineDetailsList[index].period) days")
//                                    Stepper(value: $fineDetailsList[index].fine, in: 0...Int(maxFine)) {
//                                        HStack {
//                                            Spacer()
//                                            Text("₹ \(fineDetailsList[index].fine)")
//                                                .foregroundColor(.secondary)
//                                        }
//                                    }
//                                } else {
//                                    Text("After \(fineDetailsList[index].period) days")
//                                    Spacer()
//                                    Text("₹ \(fineDetailsList[index].fine) / day")
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                        }
//                        
//                        if isEditMode {
////                            HStack {
////                                Text("Loan Period")
////                                Stepper(value: $loanPeriod, in: 1...31) {
////                                    HStack {
////                                        Spacer()
////                                        Text("\(loanPeriod) days")
////                                            .foregroundColor(.secondary)
////                                    }
////                                }
////                            }
//                            
//                            HStack {
//                                Text("Maximum Fine")
//                                Stepper(value: $maxFine, in: 1...10000) {
//                                    HStack {
//                                        Spacer()
//                                        Text("₹ \(maxFine, specifier: "%.0f")")
//                                            .foregroundColor(.secondary)
//                                    }
//                                }
//                            }
//                        } else {
////                            HStack {
////                                Text("Loan Period")
////                                Spacer()
////                                Text("\(loanPeriod) days")
////                                    .foregroundColor(.secondary)
////                            }
//                            
//                            HStack {
//                                Text("Maximum Fine")
//                                Spacer()
//                                Text("₹ \(maxFine, specifier: "%.0f")")
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                    }
//                }
                .navigationTitle("Fine Rates")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if isEditMode {
                                saveChanges()
                                newSlab = false
                            }
                            isEditMode.toggle()
                        }) {
                            if isEditMode {
                                Text("Done")
                                    .font(.title3)
                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                            } else {
                                Image(systemName: "square.and.pencil")
                                    .font(.title3)
                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            configViewModel.fetchConfig()
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            fineDetailsList = configViewModel.currentConfig[0].fineDetails
            loanPeriod = configViewModel.currentConfig[0].loanPeriod
            maxFine = configViewModel.currentConfig[0].maxFine
            maxPenalties = configViewModel.currentConfig[0].maxPenalties
            isPageLoading = false
        }
    }
    
    private func saveChanges() {
        configViewModel.updateFineAndLoan(configId: configViewModel.currentConfig[0].configID, fineDetails: fineDetailsList, loanPeriod: loanPeriod, maxFine: maxFine, maxPenalty: maxPenalties)
    }
}

struct FALPre: View {
    @StateObject var ConfiModel = ConfigViewModel()
    
    var body: some View {
        AdminFineView(configViewModel: ConfiModel)
    }
}

struct AdminFineView_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return FALPre()
            .environmentObject(themeManager)
    }
}
