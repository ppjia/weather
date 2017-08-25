//  Copyright © 2017 rui. All rights reserved.

import Foundation

protocol ForecastDetailsViewModelType {
    var detailsToPresent: [(String, String)] { get }
}

class DailyForecastDetailsViewModel: ForecastDetailsViewModelType {
    fileprivate let forecastDetail: DetailsData
    
    var detailsToPresent: [(String, String)] {
        return Mirror(reflecting: forecastDetail).children.flatMap { label, value in
            guard let label = label else { return nil }
            return (label, "\(value)")
        }
    }
    
    init(forecastDetail: DetailsData) {
        self.forecastDetail = forecastDetail
    }
}
