import SwiftUI
import Charts

struct DailyAmount: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
    let type: String  // "Income" or "Expense"
}

struct HomeView: View {
    let transactions: [Transaction]

    var totalExpense: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    var totalIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var netBalance: Double {
        totalIncome - totalExpense
    }

    var weeklyChartData: [DailyAmount] {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let order = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

        var expenseTotals: [String: Double] = [:]
        var incomeTotals: [String: Double] = [:]

        for transaction in transactions {
            let day = formatter.string(from: transaction.date)
            if transaction.type == .expense {
                expenseTotals[day, default: 0] += transaction.amount
            } else {
                incomeTotals[day, default: 0] += transaction.amount
            }
        }

        var result: [DailyAmount] = []
        for day in order {
            result.append(DailyAmount(day: day, amount: expenseTotals[day] ?? 0, type: "Expense"))
            result.append(DailyAmount(day: day, amount: incomeTotals[day] ?? 0, type: "Income"))
        }
        return result
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 4) {
                    Text("Net Balance")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("$\(netBalance, specifier: "%.2f")")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(netBalance >= 0 ? Color.primary : Color.red)
                }
                .padding(.top, 12)

                HStack(spacing: 12) {
                    summaryCard(title: "Income", amount: totalIncome, color: .green, icon: "arrow.up.circle.fill")
                    summaryCard(title: "Expense", amount: totalExpense, color: .red, icon: "arrow.down.circle.fill")
                }

                Chart(weeklyChartData) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Amount", item.amount)
                    )
                    .foregroundStyle(by: .value("Type", item.type))
                    .position(by: .value("Type", item.type))
                    .cornerRadius(4)
                }
                .chartForegroundStyleScale([
                    "Expense": Color.black,
                    "Income": Color.green
                ])
                .chartLegend(position: .top, alignment: .leading)
                .frame(height: 180)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Transactions")
                        .font(.headline)

                    if transactions.isEmpty {
                        emptyState
                    } else {
                        ForEach(transactions.reversed()) { transaction in
                            transactionRow(transaction)
                        }
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    func summaryCard(title: String, amount: Double, color: Color, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text("$\(amount, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    @ViewBuilder
    var emptyState: some View {
        HStack {
            Circle()
                .fill(Color.orange.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: "fork.knife").foregroundStyle(.orange))

            VStack(alignment: .leading, spacing: 2) {
                Text("No transactions yet")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Tap + to add your first entry")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    @ViewBuilder
    func transactionRow(_ transaction: Transaction) -> some View {
        HStack {
            Circle()
                .fill((transaction.type == .income ? Color.green : Color.blue).opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: transaction.type == .income ? "arrow.up" : "arrow.down")
                        .foregroundStyle(transaction.type == .income ? Color.green : Color.blue)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.merchant)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(transaction.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(transaction.type == .income ? "+" : "-")$\(transaction.amount, specifier: "%.2f")")
                .fontWeight(.semibold)
                .foregroundStyle(transaction.type == .income ? Color.green : Color.primary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    HomeView(transactions: [])
}
