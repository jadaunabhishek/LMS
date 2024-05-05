import SwiftUI
import EventKit

// Function to request access to the calendar
func requestAccessToCalendar(completion: @escaping (Bool) -> Void) {
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) { granted, error in
        DispatchQueue.main.async {
            if granted && error == nil {
                print("Access to calendar events granted.")
                completion(true)
            } else {
                if let error = error {
                    print("Error requesting access: \(error.localizedDescription)")
                } else {
                    print("Access to calendar events was denied.")
                }
                completion(false)
            }
        }
    }
}

// SwiftUI view for MemberHome
struct MemberHome: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var hasCalendarAccess = false

    var body: some View {
        NavigationView {
            Text("Home")
//            ScrollView {
//                VStack {
//                    ZStack {
//                        Rectangle()
//                            .foregroundColor(themeManager.selectedTheme.secondaryThemeColor)
//                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
//                            .frame(height: 230)
//                            .navigationBarBackButtonHidden(true)
//                            .navigationTitle("Home")
//                            .navigationBarHidden(true)
//                        HStack {
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text("DATE")
//                                    .font(.title3)
//                                    .fontWeight(.bold).padding(.bottom, 15)
//                                Text("Author:")
//                                    .font(.title2)
//                                    .fontWeight(.semibold)
//                                Text("Title")
//                                    .font(.title)
//                                    .fontWeight(.bold)
//                                Text("ISBN 1234")
//                                    .multilineTextAlignment(.leading)
//                                    .font(.headline)
//                                    .fontWeight(.semibold).padding(.top, 30)
//                            }.padding().foregroundColor(.white)
//                            Spacer()
//                            VStack {
//                                ZStack {
//                                    Circle()
//                                        .stroke(lineWidth: 18)
//                                        .opacity(0.3)
//                                        .foregroundColor(.gray)
//                                        .frame(width: 150, height: 150)
//                                    
//                                    Circle()
//                                        .trim(from: 0.0, to: 1)
//                                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
//                                        .frame(width: 150, height: 150)
//                                        .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
//                                        .rotationEffect(.degrees(-90))
//                                    VStack {
//                                        Text("10")
//                                            .font(.title)
//                                            .fontWeight(.bold)
//                                            .foregroundColor(.blue)
//                                        Text("Days left")
//                                            .font(.title3)
//                                            .fontWeight(.semibold)
//                                    }
//                                }.padding()
//                            }.padding(.bottom, 35)
//                                .padding(.trailing, 15)
//                        }
//                    }.padding()
//                    
//                    ScrollView(.horizontal) {
//                        HStack {
//                            ZStack(alignment: .bottomLeading) {
//                                Rectangle()
//                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
//                                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
//                                    .frame(width: 230, height: 130)
//                                HStack {
//                                    Text("My Books").font(.title)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.white)
//                                    Image(systemName: "book")
//                                        .resizable()
//                                        .foregroundColor(.white)
//                                        .frame(width: 20, height: 20)
//                                }.padding()
//                            }
//                            ZStack(alignment: .bottomLeading) {
//                                Rectangle()
//                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
//                                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
//                                    .frame(width: 210, height: 130)
//                                HStack {
//                                    Text("History").font(.title)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.white)
//                                    Image(systemName: "square.stack.3d.up.fill")
//                                        .resizable()
//                                        .foregroundColor(.white)
//                                        .frame(width: 20, height: 20)
//                                }.padding()
//                            }
//                        }.padding()
//                    }
//                    
//                    Text("New Release")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    ScrollView(.horizontal) {
//                        LazyHStack(spacing: 20) {
//                            ForEach(0..<10) { _ in
//                                RoundedRectangle(cornerRadius: 10)
//                                    .frame(width: 100, height: 150)
//                                    .foregroundColor(themeManager.selectedTheme.primaryThemeColor)
//                            }
//                        }
//                    }
//                }
//                .onAppear {
//                    requestAccessToCalendar { granted in
//                        self.hasCalendarAccess = granted
//                    }
//                }
//            }
        }
    }
}

// SwiftUI Preview Provider
struct MemberHome_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return MemberHome().environmentObject(themeManager)
    }
}
