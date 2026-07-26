import SwiftUI

struct SettingsView: View {
    @AppStorage("accentColorName") private var accentColorName: String = "black"
    @AppStorage("apiKey") private var apiKey: String = ""
    @AppStorage("weekStartDay") private var weekStartDay: Int = 2 // 1 = Sunday, 2 = Monday

    let colorOptions: [(name: String, color: Color)] = [
        ("black", .black),
        ("blue", .blue),
        ("green", .green),
        ("purple", .purple),
        ("orange", .orange)
    ]

    let weekdayOptions: [(name: String, value: Int)] = [
        ("Sunday", 1),
        ("Monday", 2),
        ("Tuesday", 3),
        ("Wednesday", 4),
        ("Thursday", 5),
        ("Friday", 6),
        ("Saturday", 7)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 12)

                settingsSection(title: "Appearance") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Accent Color")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            ForEach(colorOptions, id: \.name) { option in
                                Circle()
                                    .fill(option.color)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: accentColorName == option.name ? 2 : 0)
                                            .padding(-3)
                                    )
                                    .onTapGesture {
                                        accentColorName = option.name
                                    }
                            }
                        }

                        Text("More theme options coming soon")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding()
                }

                // New: Preferences section for week start day
                settingsSection(title: "Preferences") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Week Starts On")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Picker("Week Start", selection: $weekStartDay) {
                            ForEach(weekdayOptions, id: \.value) { option in
                                Text(option.name).tag(option.value)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                }

                settingsSection(title: "Transactions") {
                    NavigationLink {
                        ManageCategoriesView()
                    } label: {
                        settingsRow(icon: "tag.fill", title: "Manage Categories", subtitle: "Customize your expense and income categories")
                    }

                    NavigationLink {
                        ChartPreferencesView()
                    } label: {
                        settingsRow(icon: "chart.bar.fill", title: "Chart Preferences", subtitle: "Choose how your data is visualized")
                    }
                }

                settingsSection(title: "AI Analysis") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundStyle(.secondary)
                                .frame(width: 24)
                            Text("Your API Key")
                                .font(.subheadline)
                            Spacer()
                        }

                        SecureField("Paste your API key here", text: $apiKey)
                            .textFieldStyle(.roundedBorder)

                        Text("Bring your own key to unlock AI-powered spending insights. Stored locally on your device.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding()
                }

                settingsSection(title: "Account") {
                    settingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Log Out", subtitle: nil)
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            VStack(spacing: 1) {
                content()
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(14)
        }
    }

    @ViewBuilder
    func settingsRow(icon: String, title: String, subtitle: String?) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

struct ManageCategoriesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tag.fill")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)
            Text("Manage Categories")
                .font(.title2)
                .fontWeight(.bold)
            Text("Custom category creation coming soon")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Categories")
    }
}

struct ChartPreferencesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)
            Text("Chart Preferences")
                .font(.title2)
                .fontWeight(.bold)
            Text("Chart customization coming soon")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Charts")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
