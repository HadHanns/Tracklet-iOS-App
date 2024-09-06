//
//  TransactionListViewModel.swift
//  Tracklet
//
//  Created by Haddad Hannan SRG on 30/08/24.
//

import Foundation
import Combine
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getTransactions()
        loadTransactionsFromFile() // Load from file if it exists
    }
    
//    func getTransactions() {
//        let fileManager = FileManager.default
//        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("Failed to get documents directory")
//            return
//        }
//        
//        let fileURL = documentsURL.appendingPathComponent("transactions.json")
//        
//        do {
//            let data = try Data(contentsOf: fileURL)
//            let decoder = JSONDecoder()
//            let transactions = try decoder.decode([Transaction].self, from: data)
//            self.transactions = transactions
//            print("Transactions loaded from file:", fileURL)
//        } catch {
//            print("Error loading transactions from file:", error)
//        }
//    }
    
    func getTransactions() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get documents directory")
            return
        }
        
        let fileURL = documentsURL.appendingPathComponent("transactions.json")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let transactions = try decoder.decode([Transaction].self, from: data)
            self.transactions = transactions
            print("Transactions loaded from file:", fileURL)
            print("Loaded Transactions:", transactions) // Log loaded transactions
        } catch {
            print("Error loading transactions from file:", error)
        }
    }


    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
        
        return groupedTransactions
    }
        
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        transactions.sort { $0.date > $1.date } // Sort transactions by date
        saveTransactions() // Save to UserDefaults
        saveTransactionsToFile() // Save to JSON file
    }
    
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "SavedTransactions")
        }
    }
    
    private func loadSavedTransactions() {
        if let savedTransactions = UserDefaults.standard.data(forKey: "SavedTransactions"),
           let decodedTransactions = try? JSONDecoder().decode([Transaction].self, from: savedTransactions) {
            self.transactions = decodedTransactions
        }
    }
    
    func saveTransactionsToFile() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get documents directory")
            return
        }
        
        let fileURL = documentsURL.appendingPathComponent("transactions.json")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Format file JSON supaya lebih mudah dibaca
            let data = try encoder.encode(transactions)
            try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
            print("Transactions saved to file:", fileURL)
        } catch {
            print("Error saving transactions to file:", error)
        }
    }

    func loadTransactionsFromFile() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get documents directory")
            return
        }
        
        let fileURL = documentsURL.appendingPathComponent("transactions.json")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let loadedTransactions = try decoder.decode([Transaction].self, from: data)
            self.transactions = loadedTransactions
            print("Transactions loaded from file")
        } catch {
            print("Error loading transactions from file:", error)
        }
    }
    
//    func accumulateTransactions() -> TransactionPrefixSum {
//        print("Accumulate Transactions ")
//        guard !transactions.isEmpty else { return [] }
//        
//        let today = Date() // Menggunakan tanggal saat ini
//        let calendar = Calendar.current
//        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
//        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)?.addingTimeInterval(-1) ?? today
//        
//        print("Start of Month:", startOfMonth)
//        print("End of Month:", endOfMonth)
//        
//        var sum: Double = .zero
//        var cumulativeSum = TransactionPrefixSum()
//        
//        var date = startOfMonth
//        while date <= endOfMonth {
//            let dailyExpenses = transactions.filter { $0.dateParsed == date && $0.isExpense }
//            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
//            
//            sum += dailyTotal
//            sum = sum.roundedTo2Digits()
//            cumulativeSum.append((date.formatted(), sum))
//            print(date.formatted(), "dailyTotal:", dailyTotal, "sum:", sum)
//            
//            date = calendar.date(byAdding: .day, value: 1, to: date)!
//        }
//        return cumulativeSum
//    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        print("Accumulate Transactions ")
        guard !transactions.isEmpty else { return [] }
        
        let today = Date() // Menggunakan tanggal saat ini
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)?.addingTimeInterval(-1) ?? today
        
        print("Start of Month:", startOfMonth)
        print("End of Month:", endOfMonth)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        var date = startOfMonth
        while date <= endOfMonth {
            let dailyExpenses = transactions.filter { calendar.isDate($0.dateParsed, inSameDayAs: date) && $0.isExpense }
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
            
            print("Date:", date.formatted(), "Daily Expenses:", dailyExpenses, "Daily Total:", dailyTotal, "Cumulative Sum:", sum)
            
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return cumulativeSum
    }


}
