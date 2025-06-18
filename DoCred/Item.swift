//
//  Item.swift
//  DoCred
//
//  Created by Aditysai B on 18/06/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
