import SwiftUI

struct AdminFineView: View {
    @ObservedObject var configViewModel: ConfigViewModel
    @State private var fineDetailsList: [fineDetails] = []
    @State private var loanPeriod: Int = 0
    @State private var maxFine: Double = 0
    @State private var maxPenalties: Int = 0
    @State private var isEditMode: Bool = false // Track edit mode
    
    var body: some View {
        NavigationView {
            List {
                Section{
                    ForEach(fineDetailsList.indices, id: \.self) { index in
                        HStack{
                            if isEditMode {
                                Text("\(fineDetailsList[index].period) days")
                                Stepper(value: $fineDetailsList[index].fine, in: 0...Int(maxFine)) {
                                    HStack{
                                        Spacer()
                                        Text("₹ \(fineDetailsList[index].fine)")
                                            .foregroundColor(.secondary)
                                    }
                                    
                                }
                                
                            }
                            else{
                                Text("\(fineDetailsList[index].period) days")
                                Spacer()
                                Text("₹ \(fineDetailsList[index].fine) / day")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    if isEditMode{
                        HStack{
                            
                            Text("Loan Period")
                            Stepper(value: $loanPeriod, in: 1...31) {
                                HStack{
                                    Spacer()
                                    Text("\(loanPeriod) days")
                                        .foregroundColor(.secondary)
                                }
                                
                            }
                            
                        }
                        HStack{
                            
                            Text("Max Fine")
                            Stepper(value: $maxFine, in: 1...10000) {
                                HStack{
                                    Spacer()
                                    Text("₹ \(maxFine, specifier: "%.0f")")
                                        .foregroundColor(.secondary)
                                }
                                
                            }
                            
                        }
                    }
                    
                    else{
                        HStack{
                            Text("Loan Period")
                            Spacer()
                            Text("\(loanPeriod) days")
                                .foregroundColor(.secondary)
                        }
                        HStack{
                            Text("Max Fine")
                            Spacer()
                            Text("₹ \(maxFine, specifier: "%.0f")")
                                .foregroundColor(.secondary)
                            
                        }
                    }
                    
                    
                }
                
                
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Manage Fine")
            .toolbar {
                // Edit Button in Toolbar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if isEditMode {
                            saveChanges() // Call saveChanges() when in edit mode
                        }
                        isEditMode.toggle() // Toggle edit mode
                    }) {
                        if isEditMode {
                            Text("Done")
                        } else {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
        }
        .task {
            // Fetch configuration data asynchronously
            configViewModel.fetchConfig()
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            fineDetailsList = configViewModel.currentConfig[0].fineDetails
            loanPeriod = configViewModel.currentConfig[0].loanPeriod
            maxFine = configViewModel.currentConfig[0].maxFine
            maxPenalties = configViewModel.currentConfig[0].maxPenalties
        }
    }
    
    // Function to save edited details to the database
    private func saveChanges() {
        // Update the fine details in the database using configViewModel
        configViewModel.updateFineAndLoan(configId: configViewModel.currentConfig[0].configID, fineDetails: fineDetailsList, loanPeriod: loanPeriod, maxFine: maxFine, maxPenalty: maxPenalties)
        // Exit edit mode
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
        FALPre()
    }
}
