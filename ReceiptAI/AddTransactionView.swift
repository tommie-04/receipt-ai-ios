import SwiftUI

enum TransactionType: String {
    case expense = "Expense"
    case income = "Income"
}

struct Transaction: Identifiable {
    let id = UUID()
    let merchant: String
    let amount: Double
    let category: String
    let date: Date
    let type: TransactionType
}

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss

    @State private var transactionType: TransactionType = .expense
    @State private var amount: String = ""
    @State private var merchant: String = ""
    @State private var selectedCategory: String = "Food"
    @State private var date: Date = Date()

    var onSave: (Transaction) -> Void

    let expenseCategories: [(name: String, icon: String, color: Color)] = [
        ("Food", "fork.knife", .orange),
        ("Transport", "car.fill", .blue),
        ("Shopping", "bag.fill", .pink),
        ("Bills", "bolt.fill", .yellow),
        ("Entertainment", "film.fill", .purple),
        ("Other", "ellipsis.circle.fill", .gray)
    ]

    let incomeCategories: [(name: String, icon: String, color: Color)] = [
        ("Salary", "banknote.fill", .green),
        ("Gift", "gift.fill", .pink),
        ("Refund", "arrow.uturn.left.circle.fill", .blue),
        ("Other", "ellipsis.circle.fill", .gray)
    ]

    var currentCategories: [(name: String, icon: String, color: Color)] {
        transactionType == .expense ? expenseCategories : incomeCategories
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") { dismiss() }
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Add Transaction")
                    .font(.headline)
                Spacer()
                Button("Save") { saveTransaction() }
                    .fontWeight(.semibold)
                    .disabled(amount.isEmpty)
                    .opacity(amount.isEmpty ? 0.3 : 1)
            }
            .padding()

            ScrollView {
                VStack(spacing: 28) {

                    Picker("Type", selection: $transactionType) {
                        Text("Expense").tag(TransactionType.expense)
                        Text("Income").tag(TransactionType.income)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 12)
                    .onChange(of: transactionType) {
                        selectedCategory = currentCategories.first?.name ?? "Other"
                    }

                    HStack(spacing: 4) {
                        Text(transactionType == .expense ? "-$" : "+$")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(transactionType == .expense ? Color.red : Color.green)
                        TextField("0", text: $amount)
                            .font(.system(size: 56, weight: .bold))
                            .keyboardType(.decimalPad)
                            .fixedSize()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTE")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        TextField(
                            transactionType == .expense ? "What was this for? (optional)" : "Where is this from? (optional)",
                            text: $merchant
                        )
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("CATEGORY")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(currentCategories, id: \.name) { category in
                                    categoryPill(category)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("DATE")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            selectedCategory = currentCategories.first?.name ?? "Other"
        }
    }

    @ViewBuilder
    func categoryPill(_ category: (name: String, icon: String, color: Color)) -> some View {
        let isSelected = selectedCategory == category.name

        Button {
            selectedCategory = category.name
        } label: {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                Text(category.name)
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? Color.black : Color(.secondarySystemBackground))
            .foregroundStyle(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }

    func saveTransaction() {
        guard let amountValue = Double(amount) else { return }

        let finalNote = merchant.isEmpty ? selectedCategory : merchant

        let newTransaction = Transaction(
            merchant: finalNote,
            amount: amountValue,
            category: selectedCategory,
            date: date,
            type: transactionType
        )

        onSave(newTransaction)
        dismiss()
    }
}

#Preview {
    AddTransactionView(onSave: { _ in })
}
