//
//  DateFormatter.swift
//  MednManagerCoreDataPart1
//
//  Created by Mitya Kim on 5/16/22.
//

import Foundation

extension DateFormatter {
    static let medicationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}


