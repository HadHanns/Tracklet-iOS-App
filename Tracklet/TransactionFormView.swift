//
//  TransactionFormView.swift
//  Tracklet
//
//  Created by Haddad Hannan SRG on 06/09/24.
//

import SwiftUI

struct TransactionFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @State private var merchant = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var categoryId = 1
    @State private var type = TransactionType.debit.rawValue
    
    // New state for error handling
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Merchant", text: $merchant)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Picker("Category", selection: $categoryId) {
                    ForEach(Category.all, id: \.id) { category in
                        Text(category.name).tag(category.id)
                    }
                }
                Picker("Type", selection: $type) {
                    Text("Debit").tag(TransactionType.debit.rawValue)
                    Text("Credit").tag(TransactionType.credit.rawValue)
                }
            }
            .navigationBarTitle("Add Transaction", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    if validateForm() {
                        saveTransaction()
                    }
                }
            )
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func validateForm() -> Bool {
        guard !merchant.isEmpty else {
            showError(message: "Please enter a merchant name")
            return false
        }
        
        guard let _ = Double(amount) else {
            showError(message: "Please enter a valid amount")
            return false
        }
        
        return true
    }

    private func showError(message: String) {
        errorMessage = message
        showError = true
    }

    private func saveTransaction() {
        guard let amountDouble = Double(amount) else { return }
        let newTransaction = Transaction(
            id: UUID().hashValue,
            date: date.formatted(.dateTime.year().month().day()),
            institution: "",
            account: "",
            merchant: merchant,
            amount: amountDouble,
            type: type,
            categoryId: categoryId,
            category: Category.all.first(where: { $0.id == categoryId })?.name ?? "",
            isPending: false,
            isTransfer: false,
            isExpense: type == TransactionType.debit.rawValue,
            isEdited: false
        )
        
        transactionListVM.addTransaction(newTransaction)
        presentationMode.wrappedValue.dismiss()
    }
}

struct TransactionFormView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionFormView()
            .environmentObject(TransactionListViewModel())
    }
}
