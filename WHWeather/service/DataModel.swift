//  Copyright © 2017 rui. All rights reserved.

import Foundation

enum ForecastType {
    case currently, hourly, daily
}

struct WeatherData {
    let currentlyWeather: ForecastData
    let hourlyWeather: ForecastData
    let dailyWeather: ForecastData
    let latitude: Double
    let longitude: Double
    let offset: Double
    let timezone: String
    
    init?(dictionary: [String: Any]) {
        guard let currentlyWeatherData = dictionary["currently"] as? [String: Any],
            let currentlyWeather = ForecastData(forecastType: .currently, dictionary: currentlyWeatherData),
            let hourlyWeatherData = dictionary["hourly"] as? [String: Any],
            let hourlyWeather = ForecastData(forecastType: .hourly, dictionary: hourlyWeatherData),
            let dailyWeatherData = dictionary["daily"] as? [String: Any],
            let dailyWeather = ForecastData(forecastType: .daily, dictionary: dailyWeatherData),
            let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let offset = dictionary["offset"] as? Double,
            let timezone = dictionary["timezone"] as? String else { return nil }
        self.currentlyWeather = currentlyWeather
        self.hourlyWeather = hourlyWeather
        self.dailyWeather = dailyWeather
        self.latitude = latitude
        self.longitude = longitude
        self.offset = offset
        self.timezone = timezone
    }
}

struct ForecastData {
    let forecastType: ForecastType
    let icon: String
    let summary: String
    let details: [DetailsData]
    
    init?(forecastType: ForecastType, dictionary: [String: Any]) {
        self.forecastType = forecastType
        guard let icon = dictionary["icon"] as? String,
            let summary = dictionary["summary"] as? String else { return nil }
        self.icon = icon
        self.summary = summary

        switch forecastType {
        case .currently:
            guard let detail = DetailsData(dictionary: dictionary) else { return nil }
            details = [detail]
        case .hourly, .daily:
            guard let detailsData = dictionary["data"] as? [[String: Any]] else { return nil }
            details = detailsData.flatMap { DetailsData(dictionary: $0) }
        }
    }
}

struct DetailsData {
    let precipIntensity: Double
    let precipProbability: Double
    let time: Date
    let summary: String
    let apparentTemperature: Double?
    let cloudCover: Double
    let dewPoint: Double
    let humidity: Double
    let ozone: Double
    let pressure: Double
    let temperature: Double?
    let uvIndex: Int
    let visibility: Double?
    let windBearing: Double
    let windGust: Double
    let windSpeed: Double
    
    // currently
    let nearestStormBearing: Int?
    let nearestStormDistance: Int?
    
    // daily
    let apparentTemperatureMax: Double?
    let apparentTemperatureMaxTime: Date?
    let apparentTemperatureMin: Double?
    let apparentTemperatureMinTime: Date?
    
    let temperatureMax: Double?
    let temperatureMaxTime: Date?
    let temperatureMin: Double?
    let temperatureMinTime: Date?
    
    let precipIntensityMax: Double?
    let precipIntensityMaxTime: Date?
    let precipType: String?
    let sunriseTime: Date?
    let sunsetTime: Date?
    
    init?(dictionary: [String: Any]) {
        guard let precipIntensity = dictionary["precipIntensity"] as? Double,
            let precipProbability = dictionary["precipProbability"] as? Double,
            let summary = dictionary["summary"] as? String,
            let timeInterval = dictionary["time"] as? Int,
            let cloudCover = dictionary["cloudCover"] as? Double,
            let dewPoint = dictionary["dewPoint"] as? Double,
            let humidity = dictionary["humidity"] as? Double,
            let ozone = dictionary["ozone"] as? Double,
            let pressure = dictionary["pressure"] as? Double,
            let uvIndex = dictionary["uvIndex"] as? Int,
            let windBearing = dictionary["windBearing"] as? Double,
            let windGust = dictionary["windGust"] as? Double,
            let windSpeed = dictionary["windSpeed"] as? Double else { return nil }
        self.precipIntensity = precipIntensity
        self.precipProbability = precipProbability
        self.summary = summary
        time = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        self.cloudCover = cloudCover
        self.dewPoint = dewPoint
        self.humidity = humidity
        self.ozone = ozone
        self.pressure = pressure
        self.uvIndex = uvIndex
        self.windBearing = windBearing
        self.windGust = windGust
        self.windSpeed = windSpeed

        temperature = dictionary["temperature"] as? Double
        apparentTemperature = dictionary["apparentTemperature"] as? Double
        visibility = dictionary["visibility"] as? Double
        nearestStormBearing = dictionary["nearestStormBearing"] as? Int
        nearestStormDistance = dictionary["nearestStormDistance"] as? Int
        
        apparentTemperatureMax = dictionary["apparentTemperatureMax"] as? Double
        apparentTemperatureMin = dictionary["apparentTemperatureMin"] as? Double
        apparentTemperatureMaxTime = (dictionary["apparentTemperatureMaxTime"] as? Int)
            .flatMap { Date(timeIntervalSince1970: TimeInterval($0)) } ?? nil
        apparentTemperatureMinTime = (dictionary["apparentTemperatureMinTime"] as? Int )
            .flatMap { Date(timeIntervalSince1970: TimeInterval($0)) } ?? nil
        
        temperatureMax = dictionary["temperatureMax"] as? Double
        temperatureMin = dictionary["temperatureMin"] as? Double
        temperatureMaxTime = (dictionary["temperatureMaxTime"] as? Int)
            .flatMap { Date(timeIntervalSince1970: TimeInterval($0)) } ?? nil
        temperatureMinTime = (dictionary["temperatureMinTime"] as? Int)
            .flatMap { Date(timeIntervalSince1970: TimeInterval($0)) } ?? nil
        
        precipIntensityMax = dictionary["precipIntensityMax"] as? Double
        precipIntensityMaxTime = (dictionary["precipIntensityMaxTime"] as? Int)
            .flatMap { Date(timeIntervalSince1970: TimeInterval($0)) } ?? nil
        precipType = dictionary["precipType"] as? String
        sunriseTime = (dictionary["sunriseTime"] as? Int)
            .flatMap { Date(timeIntervalSince1970: TimeInterval($0)) } ?? nil
        sunsetTime = (dictionary["sunsetTime"] as? Int)
            .flatMap { Date(timeIntervalSince1970: TimeInterval($0)) } ?? nil
    }
}
