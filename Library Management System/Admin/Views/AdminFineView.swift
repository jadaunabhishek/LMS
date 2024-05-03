import SwiftUI

struct AdminFineView: View {
    @ObservedObject var configViewModel: ConfigViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var fineDetailsList: [fineDetails] = []
    @State private var loanPeriod: Int = 0
    @State private var maxFine: Double = 0
    @State private var maxPenalties: Int = 0
    @State private var isEditMode: Bool = false
    @State var isPageLoading: Bool = true
    
    var body: some View {
        NavigationStack {
            if !isPageLoading {
                List {
                    Section {
                        ForEach(fineDetailsList.indices, id: \.self) { index in
                            HStack {
                                if isEditMode {
                                    Text("After \(fineDetailsList[index].period) days")
                                    Stepper(value: $fineDetailsList[index].fine, in: 0...Int(maxFine)) {
                                        HStack {
                                            Spacer()
                                            Text("₹ \(fineDetailsList[index].fine)")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                } else {
                                    Text("After \(fineDetailsList[index].period) days")
                                    Spacer()
                                    Text("₹ \(fineDetailsList[index].fine) / day")
                                        .foregroundColor(.secondary)
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
                        } else {
//                            HStack {
//                                Text("Loan Period")
//                                Spacer()
//                                Text("\(loanPeriod) days")
//                                    .foregroundColor(.secondary)
//                            }
                            
                            HStack {
                                Text("Maximum Fine")
                                Spacer()
                                Text("₹ \(maxFine, specifier: "%.0f")")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .navigationTitle("Fine Rates")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if isEditMode {
                                saveChanges()
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
