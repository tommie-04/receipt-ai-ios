import SwiftUI
import Charts
import PhotosUI

struct DailySpending: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
}

struct HomeView: View {
    @Binding var selectedImageData: Data?

    let weeklySpending: [DailySpending] = [
        DailySpending(day: "Mon", amount: 12),
        DailySpending(day: "Tue", amount: 34),
        DailySpending(day: "Wed", amount: 8),
        DailySpending(day: "Thu", amount: 51),
        DailySpending(day: "Fri", amount: 27),
        DailySpending(day: "Sat", amount: 63),
        DailySpending(day: "Sun", amount: 19)
    ]

    var totalSpending: Double {
        weeklySpending.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This Week")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("$\(totalSpending, specifier: "%.2f")")
                        .font(.system(size: 40, weight: .bold))
                }
                .padding(.top, 12)

                Chart(weeklySpending) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Amount", item.amount)
                    )
                    .foregroundStyle(Color.black)
                    .cornerRadius(6)
                }
                .frame(height: 180)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Recent Transactions")
                            .font(.headline)
                        Spacer()
                        Text("See all")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }

                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        HStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text("New receipt")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Just now")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                    } else {
                        HStack {
                            Circle()
                                .fill(Color.orange.opacity(0.15))
                                .frame(width: 44, height: 44)
                                .overlay(Image(systemName: "fork.knife").foregroundStyle(.orange))

                            VStack(alignment: .leading, spacing: 2) {
                                Text("No transactions yet")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Scan a receipt to get started")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    HomeView(selectedImageData: .constant(nil))
}
