import SwiftUI
import Charts

struct StatsView: View {
    let transactions: [Transaction]

    let categoryColors: [String: Color] = [
        "Food": .orange,
        "Transport": .blue,
        "Shopping": .pink,
        "Bills": .yellow,
        "Entertainment": .purple,
        "Other": .gray
    ]

    var categoryBreakdown: [(category: String, total: Double)] {
        var totals: [String: Double] = [:]
        for transaction in transactions where transaction.type == .expense {
            totals[transaction.category, default: 0] += transaction.amount
        }
        return totals
            .map { (category: $0.key, total: $0.value) }
            .sorted { $0.total > $1.total }
    }

    var totalSpending: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    var totalIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Spending Breakdown")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 12)

                // Income vs Expense summary
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Income")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("$\(totalIncome, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Expense")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("$\(totalSpending, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                }

                if categoryBreakdown.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.pie")
                            .font(.system(size: 40))
                            .foregroundStyle(.tertiary)
                        Text("No expense data yet")
                            .foregroundStyle(.secondary)
                        Text("Add some expenses to see your breakdown")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                } else {
                    Text("By Category")
                        .font(.headline)

                    Chart(categoryBreakdown, id: \.category) { item in
                        SectorMark(
                            angle: .value("Amount", item.total),
                            innerRadius: .ratio(0.6),
                            angularInset: 2
                        )
                        .foregroundStyle(categoryColors[item.category] ?? .gray)
                        .cornerRadius(4)
                    }
                    .frame(height: 220)
                    .overlay(
                        VStack(spacing: 2) {
                            Text("Total")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("$\(totalSpending, specifier: "%.2f")")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    )
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)

                    VStack(spacing: 12) {
                        ForEach(categoryBreakdown, id: \.category) { item in
                            let percentage = totalSpending > 0 ? (item.total / totalSpending) * 100 : 0

                            HStack {
                                Circle()
                                    .fill(categoryColors[item.category] ?? .gray)
                                    .frame(width: 10, height: 10)

                                Text(item.category)
                                    .font(.subheadline)
                                    .fontWeight(.medium)

                                Spacer()

                                Text("\(percentage, specifier: "%.0f")%")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Text("$\(item.total, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 70, alignment: .trailing)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(14)
                        }
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
    StatsView(transactions: [])
}
