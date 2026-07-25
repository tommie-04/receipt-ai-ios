import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var showingAddTransaction = false
    @State private var transactions: [Transaction] = []

    enum Tab {
        case home, stats, profile, settings
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(transactions: transactions)
                case .stats:
                    StatsView(transactions: transactions)
                case .profile:
                    ProfileView()
                case .settings:
                    NavigationStack {
                        SettingsView()
                    }
                }
            }

            HStack {
                tabBarIcon(systemName: "house.fill", label: "Home", tab: .home)
                Spacer()
                tabBarIcon(systemName: "chart.pie.fill", label: "Stats", tab: .stats)
                Spacer()

                // Now opens the quick-add form instead of the camera
                Button {
                    showingAddTransaction = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                }
                .offset(y: -20)

                Spacer()
                tabBarIcon(systemName: "person.fill", label: "Profile", tab: .profile)
                Spacer()
                tabBarIcon(systemName: "gearshape.fill", label: "Settings", tab: .settings)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 28)
            .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView { newTransaction in
                transactions.append(newTransaction)
            }
        }
    }

    @ViewBuilder
    func tabBarIcon(systemName: String, label: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.system(size: 20))
                Text(label)
                    .font(.caption2)
            }
            .foregroundStyle(selectedTab == tab ? .primary : .secondary)
        }
    }
}

#Preview {
    ContentView()
}
