//
//  ConfigSchema.swift
//  Library Management System
//
//  Created by user2 on 24/04/24.
//

import Foundation
import SwiftUI

struct fineDetails : Codable{
    var fine: Int
    var period: Int
    
    func getDictionary() -> [String: Any] {
            return [
                "fine": fine,
                "period": period
            ]
        }
}

struct membersCount: Codable {
    var month: String
    var count: Int
    
    func getDictionary() -> [String: Any] {
        return [
            "month": month,
            "count": count
        ]
    }
}


struct monthlyIncome{
    var month: String
    var income: Int
    
    func getDictionary() -> [String: Any] {
        return [
            "month": month,
            "income": income
        ]
    }
}

struct Config {
    
    var configID: String
    var adminID: String
    var logo: String
    var accentColor: String
    var loanPeriod: Int
    var fineDetails: [fineDetails]
    var maxFine: Double
    var maxPenalties: Int
    var categories: [String]
    var monthlyMembersCount: [membersCount]
    var monthlyIncome: [monthlyIncome]
    
    func getDictionaryOfStruct() -> [String: Any] {
        var fineDetailsArray: [[String: Any]] = []
        for fine in fineDetails {
            fineDetailsArray.append(fine.getDictionary())
        }
        
        var monthlyMembersCountArray: [[String: Any]] = []
        for member in monthlyMembersCount {
            monthlyMembersCountArray.append(member.getDictionary())
        }
        
        var monthlyIncomeArray: [[String: Any]] = []
        for member in monthlyIncome {
            monthlyIncomeArray.append(member.getDictionary())
        }
        
        return [
            "configID": configID,
            "adminID": adminID,
            "logo": logo,
            "accentColor": accentColor,
            "loanPeriod": loanPeriod,
            "fineDetails": fineDetailsArray,
            "maxFine": maxFine,
            "maxPenalties": maxPenalties,
            "categories": categories,
            "monthlyMembersCount": monthlyMembersCountArray,
            "monthlyIncome": monthlyIncomeArray
        ]
    }
}
