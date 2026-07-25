import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName: String = "Your Name"
    @AppStorage("userID") private var userID: String = UUID().uuidString.prefix(8).description

    @State private var isEditingName = false
    @State private var editedName = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Avatar + name section
                VStack(spacing: 12) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 88, height: 88)
                        .overlay(
                            Text(initials)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )

                    if isEditingName {
                        TextField("Your name", text: $editedName)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 220)
                            .onSubmit {
                                saveName()
                            }
                    } else {
                        Text(userName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                editedName = userName
                                isEditingName = true
                            }
                    }

                    Text("ID: \(userID)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                if isEditingName {
                    Button("Save Name") {
                        saveName()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }

                Divider()
                    .padding(.horizontal, 40)

                // Placeholder for future account info
                VStack(spacing: 12) {
                    infoRow(icon: "envelope.fill", title: "Email", value: "Not set")
                    infoRow(icon: "calendar", title: "Member Since", value: "July 2026")
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 100)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    var initials: String {
        let parts = userName.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }

    func saveName() {
        if !editedName.trimmingCharacters(in: .whitespaces).isEmpty {
            userName = editedName
        }
        isEditingName = false
    }

    @ViewBuilder
    func infoRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}

#Preview {
    ProfileView()
}
