//
//  String+Ext.swift
//  MyCoreDataProject
//
//  Created by Maksim Malofeev on 28/08/2022.
//

import Foundation

extension String {
    public func convertToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.date(from: self)
    }
}

