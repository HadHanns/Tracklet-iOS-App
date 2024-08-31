//
//  TransactionList.swift
//  Tracklet
//
//  Created by Haddad Hannan SRG on 30/08/24.
//

import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    var body: some View {
        VStack {
            List {
                //MARK: Transaction Groups
                ForEach(Array(transactionListVM.groupTransactionsByMonth()), id: \.key ){
                    month, transactions in
                    Section {
                        //MARK: Transaction List
                        ForEach(transactions) {transactions in
                            TransactionRow(transaction: transactions)
                        }
                    } header: {
                        //MARK: Transaction Month
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct TransactionList_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionsListVM = TransactionListViewModel()
        transactionsListVM.transactions = transactionListPreviewData
        return transactionsListVM
    }()
    
    static var previews: some View {
        NavigationView {
            TransactionList()
        }
            .environmentObject(transactionListVM)
    }
        
}
