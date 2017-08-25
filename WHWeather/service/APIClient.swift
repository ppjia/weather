//  Copyright © 2017 rui. All rights reserved.

import Foundation

enum WHError: Error {
    case network(Error)
    case malformedEndpoint
    case deserializing
    case unknown
}

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

struct WHClient {
    private let endpoint = "https://api.darksky.net/forecast/"
    private let key = "d977f79713fcca91fe1be7513095665c"
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchWeatherDataWith(latitude: Double,
                              longitude: Double,
                              completionHandler: @escaping (Result<WeatherData, WHError>) -> Void) {
        guard let request = urlRequestWith(latitude: latitude, longitude: longitude) else {
            completionHandler(.failure(.malformedEndpoint))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error { return completionHandler(.failure(.network(error))) }
            guard let data = data,
                let jsonData = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let weatherData = WeatherData(dictionary: jsonData) else {
                    return completionHandler(.failure(.deserializing))
            }
            completionHandler(.success(weatherData))
        }.resume()
    }
    
    private func urlRequestWith(latitude: Double, longitude: Double) -> URLRequest? {
        let urlString = endpoint + key + "/\(latitude),\(longitude)"
        guard let urlComponents = URLComponents(string: urlString),
            let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
}
