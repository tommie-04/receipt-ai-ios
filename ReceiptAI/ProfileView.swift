import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("👤 Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("User account coming soon")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ProfileView()
}
