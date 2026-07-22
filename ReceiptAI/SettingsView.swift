import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("⚙️ Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("App settings coming soon")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    SettingsView()
}
