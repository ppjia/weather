//  Copyright © 2017 rui. All rights reserved.

import Foundation

class WeatherCellViewModel {
    fileprivate let forecastType: ForecastType
    fileprivate let forecastDetail: DetailsData

    var textToPresent: String {
        switch forecastType {
        case .currently:
            return forecastDetail.summary
                + ((forecastDetail.nearestStormDistance).flatMap { ", nearest storm at \($0) :(" } ?? "there is no storm nearby :)")
        case .daily:
            return  Util.dateString(with: forecastDetail.time) + ": " + forecastDetail.summary + " \n(click for details)"
        case .hourly:
            return forecastDetail.summary
        }
    }

    init(forecastType: ForecastType, forecastDetail: DetailsData) {
        self.forecastType = forecastType
        self.forecastDetail = forecastDetail
    }
}
