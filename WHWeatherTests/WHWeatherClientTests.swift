//  Copyright © 2017 rui. All rights reserved.

import XCTest
@testable import WHWeather

class WHWeatherClientTests: XCTestCase {
    
    func testWeatherFetching() {
        let session = MockSession()
        session.dataTaskWithRequestCalled = { request in
            (self.loadSampleFileData(fileName: "testjson"), URLResponse(), nil)
        }
        let client = WHClient(session: session)
        client.fetchWeatherDataWith(latitude: 33.8650, longitude: 151.2094) { result in
            switch result {
            case let .success(weatherData):
                XCTAssert(weatherData.currentlyWeather.details.first?.apparentTemperature != nil)
            default:
                XCTFail()
            }
        }
    }
    
    func loadSampleFileData(fileName: String) -> Data? {
        guard let sampleFilePath = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: sampleFilePath)
    }
    
}
