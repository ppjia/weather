//  Copyright © 2017 rui. All rights reserved.

import Foundation

class WeatherViewModel {
    fileprivate let apiClient = WHClient()
    fileprivate var weatherData: WeatherData?

    var numberOfSections: Int {
        return 2
    }

    func numberOfItems(inSection section: Int) -> Int {
        return section == 0 ? 1 : weatherData?.dailyWeather.details.count ?? 0
    }

    func cellViewModel(at indexPath: IndexPath) -> WeatherCellViewModel? {
        if indexPath.section == 0 {
            guard let forecastDetail = weatherData?.currentlyWeather.details.first else { return nil }
            return WeatherCellViewModel(forecastType: .currently, forecastDetail: forecastDetail)
        }
        guard let dailyForecastDetail = weatherData?.dailyWeather.details[indexPath.row] else { return nil }
        return WeatherCellViewModel(forecastType: .daily, forecastDetail: dailyForecastDetail)
    }

    func forecastData(at section: Int) -> ForecastData? {
        return section == 0 ? weatherData?.currentlyWeather : weatherData?.dailyWeather
    }

    func forecastDetailsViewModel(at indexPath: IndexPath) -> ForecastDetailsViewModelType? {
        guard indexPath.section == 1, let forecastDetail = weatherData?.dailyWeather.details[indexPath.row] else { return nil }
        return DailyForecastDetailsViewModel(forecastDetail: forecastDetail)
    }
}

/// API
extension WeatherViewModel {
    func fetchWeatherDataWith(latitude: Double,
                              longitude: Double,
                              completionHandler: @escaping (String?) -> Void){
        apiClient.fetchWeatherDataWith(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case let .success(weatherData):
                self?.weatherData = weatherData
                completionHandler(nil)
            case .failure(_):
                completionHandler("Error when loading weather!")
            }
        }
    }
}
