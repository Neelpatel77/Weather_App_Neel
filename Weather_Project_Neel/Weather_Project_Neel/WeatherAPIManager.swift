import Foundation
import CoreLocation

class WeatherAPIManager {
    static let shared = WeatherAPIManager()

    func fetchWeatherData(for city: String, completion: @escaping (WeatherData?, Error?) -> Void) {
        guard let apiKey = getAPIKey() else {
            completion(nil, NSError(domain: "WeatherAPIErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key not found in Info.plist"]))
            return
        }

        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(city)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "WeatherAPIErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherAPIResponse.self, from: data)
                    let weatherData = weatherResponse.toWeatherData()
                    completion(weatherData, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

    private func getAPIKey() -> String? {
        if let apiKey = Bundle.main.infoDictionary?["WeatherAPIKey"] as? String {
            return apiKey
        }
        return nil
    }
}
