//
//  PreviewData.swift
//  Tracklet
//
//  Created by Haddad Hannan SRG on 30/08/24.
//

import Foundation
import SwiftUI

var transactionPreviewData = Transaction(id: 1,
                                         date: "08/30/2024",
                                         institution: "Museum Louvre",
                                         account: "Credit Card",
                                         merchant: "Ticket Purchase",
                                         amount: 150.00,
                                         type: "debit",
                                         categoryId: 101,
                                         category: "Entertainment",
                                         isPending: false,
                                         isTransfer: false,
                                         isExpense: true,
                                         isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
