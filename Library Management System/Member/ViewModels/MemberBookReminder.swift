import Foundation
import FirebaseFirestore
import EventKit

var dbInstance = Firestore.firestore()

func getUserHistory(userId: String) async throws -> [Loan] {
    var tempUserHistory: [Loan] = []
    let snapshot = try await dbInstance.collection("Loans").getDocuments()

    for document in snapshot.documents {
        let documentData = document.data()
        let tempLoan = Loan(
            loanId: documentData["loanId"] as? String ?? "",
            bookId: documentData["bookId"] as? String ?? "",
            bookName: documentData["bookName"] as? String ?? "",
            bookImageURL: documentData["bookImageURL"] as? String ?? "",
            bookIssuedTo: documentData["bookIssuedTo"] as? String ?? "",
            bookIssuedToName: documentData["bookIssuedToName"] as? String ?? "",
            bookIssuedOn: documentData["bookIssuedOn"] as? String ?? "",
            bookExpectedReturnOn: documentData["bookExpectedReturnOn"] as? String ?? "",
            bookReturnedOn: documentData["bookReturnedOn"] as? String ?? "",
            loanStatus: documentData["loanStatus"] as? String ?? "",
            loanReminderStatus: documentData["loanReminderStatus"] as? String ?? "",
            fineCalculatedDays: documentData["fineCalculatedDays"] as? Int ?? 0,
            loanFine: documentData["loanFine"] as? Int ?? 0,
            createdOn: documentData["createdOn"] as? String ?? "",
            updatedOn: documentData["updatedOn"] as? String ?? "",
            timeStamp: documentData["timeStamp"] as? Int ?? 0
        )
        
        if tempLoan.bookIssuedTo == userId {
            tempUserHistory.append(tempLoan)
        }
    }
    return tempUserHistory
}

func createCalendarEvents(LibViewModel: LibrarianViewModel, userId: String) async {
    await LibViewModel.getUserHistory(userId: userId)
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    let loans: [Loan] = await LibViewModel.currentUserHistory
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yy"
    
    requestAccessToCalendar { granted in
        if granted {
            for loan in loans {
                if(loan.loanStatus == "Issued"){
                    let expectedDate = dateFormatter.date(from:String(loan.bookExpectedReturnOn.split(separator: ",")[0]))!
                    addSingleDayReturnReminder(for: loan.bookName, dueDate: expectedDate, duration: calculateLoanDuration(issuedOn: loan.bookIssuedOn, expectedReturn: loan.bookExpectedReturnOn, dateFormatter: dateFormatter))
                }
            }
        } else {
            print("Access not granted to create calendar events.")
        }
    }
}

func calculateLoanDuration(issuedOn: String, expectedReturn: String, dateFormatter: DateFormatter) -> Int {
    guard let startDate = dateFormatter.date(from: issuedOn),
          let endDate = dateFormatter.date(from: expectedReturn) else {
        return 0
    }
    return Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
}


func eventAlreadyExists(title: String, dueDate: Date, eventStore: EKEventStore) -> Bool {
    let predicate = eventStore.predicateForEvents(withStart: dueDate, end: dueDate.addingTimeInterval(86400), calendars: nil)
    let existingEvents = eventStore.events(matching: predicate)
    return existingEvents.contains { $0.title == title && $0.startDate == dueDate }
}

func addSingleDayReturnReminder(for book: String, dueDate: Date, duration: Int) {
    let eventStore = EKEventStore()
    let title = "Return \(book)"
    
    
    guard !eventAlreadyExists(title: title, dueDate: dueDate, eventStore: eventStore) else {
        print("Event already exists for the book \(book) on its return date: \(dueDate)")
        return
    }

    let event = EKEvent(eventStore: eventStore)
    event.title = title
    event.startDate = dueDate
    event.endDate = dueDate.addingTimeInterval(60 * 60 * 24 - 1)  // 1 hour event
    event.calendar = eventStore.defaultCalendarForNewEvents

    // Set alarms based on the loan duration
    switch duration {
        case 1:
            event.alarms = [EKAlarm(relativeOffset: 0)]
        case 2:
            event.alarms = [EKAlarm(relativeOffset: 0)]
        case 3:
            event.alarms = [EKAlarm(relativeOffset: -86400),
                            EKAlarm(relativeOffset: 0)]
        default:
            event.alarms = [EKAlarm(relativeOffset: -259200),
                            EKAlarm(relativeOffset: -86400),
                            EKAlarm(relativeOffset: 0)]
    }

    do {
        try eventStore.save(event, span: .thisEvent)
        print("Event created for the book \(book) on its return date: \(dueDate)")
    } catch let error as NSError {
        print("Failed to save the event with error: \(error)")
    }
}
