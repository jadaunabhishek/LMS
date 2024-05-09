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

struct monthlyRevenue: Codable {
    var month: String
    var revenue: Int
    
    func getDictionary() -> [String: Any] {
        return [
            "month": month,
            "revenue": revenue
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
    var monthlyRevenueTotal: [monthlyRevenue]
    
    func getDictionaryOfStruct() -> [String: Any] {
        var fineDetailsArray: [[String: Any]] = []
        for fine in fineDetails {
            fineDetailsArray.append(fine.getDictionary())
        }
        
        var monthlyMembersCountArray: [[String: Any]] = []
        for member in monthlyMembersCount {
            monthlyMembersCountArray.append(member.getDictionary())
        }
        
        var monthlyRevenueTotalArray: [[String: Any]] = []
        for member in monthlyRevenueTotal {
            monthlyRevenueTotalArray.append(member.getDictionary())
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
            "montlyRevenueTotal": monthlyRevenueTotalArray
            
        ]
    }
}
