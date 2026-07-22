import SwiftUI

struct StatsView: View {
    var body: some View {
        VStack {
            Text("📊 Stats")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Detailed spending breakdown coming soon")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    StatsView()
}
