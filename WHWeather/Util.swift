//  Copyright © 2017 rui. All rights reserved.

import Foundation

struct Util {
    private static var localZoneDateTimeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter
    }

    static func dateString(with date: Date) -> String {
        return Util.localZoneDateTimeFormatter.string(from: date)
    }
}
