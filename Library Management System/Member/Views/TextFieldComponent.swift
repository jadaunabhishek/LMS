import SwiftUI

struct TextFieldComponent: View {
    var placeholder: String
    @Binding var text: String
    @Binding var isEditing: Bool
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        TextField(placeholder, text: $text)
            .disabled(!isEditing)
            .font(.title3)
            .padding(12)
            .foregroundColor(Color("TextColor"))
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isEditing ? themeManager.selectedTheme.primaryThemeColor : themeManager.selectedTheme.secondaryThemeColor,
                        lineWidth: 1
                    )
            )
    }
}
