import SwiftUI
import Charts

struct DailyAmount: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
    let type: String
}

enum ChartRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
}

struct HomeView: View {
    let transactions: [Transaction]
    @Binding var chartRange: ChartRange
    @Binding var referenceDate: Date

    @AppStorage("weekStartDay") private var weekStartDay: Int = 2

    func customWeekInterval(for date: Date) -> DateInterval {
        var calendar = Calendar.current
        calendar.firstWeekday = weekStartDay

        guard let interval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return DateInterval(start: date, duration: 7 * 86400)
        }
        return interval
    }

    // Transactions that fall within the currently selected time range
    var filteredTransactions: [Transaction] {
        switch chartRange {
        case .week:
            let weekInterval = customWeekInterval(for: referenceDate)
            return transactions.filter { weekInterval.contains($0.date) }
        case .month:
            let calendar = Calendar.current
            guard let monthInterval = calendar.dateInterval(of: .month, for: referenceDate) else { return [] }
            return transactions.filter { monthInterval.contains($0.date) }
        }
    }

    var totalExpense: Double {
        filteredTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    var totalIncome: Double {
        filteredTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var netBalance: Double {
        totalIncome - totalExpense
    }

    var weekdayOrder: [String] {
        let allDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let startIndex = weekStartDay - 1
        return Array(allDays[startIndex...] + allDays[..<startIndex])
    }

    var weeklyChartData: [DailyAmount] {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let order = weekdayOrder

        var expenseTotals: [String: Double] = [:]
        var incomeTotals: [String: Double] = [:]

        let weekInterval = customWeekInterval(for: referenceDate)

        for transaction in transactions where weekInterval.contains(transaction.date) {
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

    var monthlyChartData: [DailyAmount] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: referenceDate),
              let dayRange = calendar.range(of: .day, in: .month, for: referenceDate) else { return [] }

        var expenseTotals: [Int: Double] = [:]
        var incomeTotals: [Int: Double] = [:]

        for transaction in transactions where monthInterval.contains(transaction.date) {
            let day = calendar.component(.day, from: transaction.date)
            if transaction.type == .expense {
                expenseTotals[day, default: 0] += transaction.amount
            } else {
                incomeTotals[day, default: 0] += transaction.amount
            }
        }

        var result: [DailyAmount] = []
        for day in dayRange {
            result.append(DailyAmount(day: "\(day)", amount: expenseTotals[day] ?? 0, type: "Expense"))
            result.append(DailyAmount(day: "\(day)", amount: incomeTotals[day] ?? 0, type: "Income"))
        }
        return result
    }

    var currentChartData: [DailyAmount] {
        chartRange == .week ? weeklyChartData : monthlyChartData
    }

    var currentRangeLabel: String {
        let formatter = DateFormatter()

        switch chartRange {
        case .week:
            let weekInterval = customWeekInterval(for: referenceDate)
            formatter.dateFormat = "MMM d"
            let start = formatter.string(from: weekInterval.start)
            let end = formatter.string(from: weekInterval.end.addingTimeInterval(-86400))
            return "\(start) - \(end)"
        case .month:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: referenceDate)
        }
    }

    func moveRange(by value: Int) {
        let calendar = Calendar.current
        switch chartRange {
        case .week:
            if let newDate = calendar.date(byAdding: .weekOfYear, value: value, to: referenceDate) {
                referenceDate = newDate
            }
        case .month:
            if let newDate = calendar.date(byAdding: .month, value: value, to: referenceDate) {
                referenceDate = newDate
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                VStack(spacing: 8) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.black)
                        .clipShape(Circle())

                    Text("Receipt AI")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Net Balance · \(chartRange.rawValue)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("$\(netBalance, specifier: "%.2f")")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(netBalance >= 0 ? Color.primary : Color.red)
                }

                HStack(spacing: 12) {
                    summaryCard(title: "Income", amount: totalIncome, color: .green, icon: "arrow.up.circle.fill")
                    summaryCard(title: "Expense", amount: totalExpense, color: .red, icon: "arrow.down.circle.fill")
                }

                Picker("Range", selection: $chartRange) {
                    ForEach(ChartRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: chartRange) {
                    referenceDate = Date()
                }

                HStack {
                    Button {
                        moveRange(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(currentRangeLabel)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Spacer()

                    Button {
                        moveRange(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 8)

                Group {
                    if chartRange == .week {
                        Chart(currentChartData) { item in
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
                    } else {
                        Chart(currentChartData) { item in
                            LineMark(
                                x: .value("Day", item.day),
                                y: .value("Amount", item.amount)
                            )
                            .foregroundStyle(by: .value("Type", item.type))
                            .interpolationMethod(.catmullRom)
                            .symbol(by: .value("Type", item.type))

                            AreaMark(
                                x: .value("Day", item.day),
                                y: .value("Amount", item.amount)
                            )
                            .foregroundStyle(by: .value("Type", item.type))
                            .opacity(0.1)
                        }
                        .chartForegroundStyleScale([
                            "Expense": Color.black,
                            "Income": Color.green
                        ])
                        .chartXAxis {
                            AxisMarks(values: .stride(by: 5))
                        }
                    }
                }
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
    HomeView(transactions: [], chartRange: .constant(.week), referenceDate: .constant(Date()))
}
