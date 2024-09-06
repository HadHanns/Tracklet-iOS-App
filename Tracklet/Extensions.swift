//
//  Extentions.swift
//  Tracklet
//
//  Created by Haddad Hannan SRG on 29/08/24.
//

import Foundation
import SwiftUI

extension Color {
    static let Background = Color("Background")
    static let Icon = Color("Icon")
    static let Text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

//extension DateFormatter {
//    static let allNumericUSA: DateFormatter = {
//        print("Initializing DateFormatter")
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd/yyyy"
//        
//        return formatter
//    }()
//}

extension DateFormatter {
    static let dateFormat1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
    
    static let dateFormat2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, HH.mm"
        return formatter
    }()
    
    static func dateFromString(_ string: String) -> Date? {
        return dateFormat1.date(from: string) ?? dateFormat2.date(from: string)
    }
}


//extension String {
//    func dateParsed() -> Date {
//        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else {return Date()}
//        
//        return parsedDate
//    }
//}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.dateFromString(self) else {
            print("Failed to parse date for string: \(self)")
            return Date()
        }
        return parsedDate
    }
}

    
//extension Date: Strideable {
//    func formatted() -> String {
//        return self.formatted(.dateTime.year().month().day())
//    }
//}

extension Date {
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
}


extension Double {
    func roundedTo2Digits() -> Double {
        return (self * 100).rounded() / 100
    }
}
