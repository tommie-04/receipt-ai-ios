import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    @State private var showingActionSheet = false
    @State private var showingCamera = false
    @State private var showingPhotoPicker = false

    // Tracks which tab is currently selected
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, stats, profile, settings
    }

    var body: some View {
        ZStack(alignment: .bottom) {

            // Show a different page depending on which tab is selected
            Group {
                switch selectedTab {
                case .home:
                    HomeView(selectedImageData: $selectedImageData)
                case .stats:
                    StatsView()
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                }
            }

            // Custom bottom tab bar
            HStack {
                tabBarIcon(systemName: "house.fill", label: "Home", tab: .home)
                Spacer()
                tabBarIcon(systemName: "chart.pie.fill", label: "Stats", tab: .stats)
                Spacer()

                Button {
                    showingActionSheet = true
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 22))
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
        .confirmationDialog("Add a receipt", isPresented: $showingActionSheet, titleVisibility: .visible) {
            Button("Take Photo") {
                showingCamera = true
            }
            Button("Choose from Library") {
                showingPhotoPicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showingCamera) {
            CameraPicker(imageData: $selectedImageData)
        }
        .photosPicker(isPresented: $showingPhotoPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }

    // Now takes a `tab` parameter so tapping it can switch pages
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
