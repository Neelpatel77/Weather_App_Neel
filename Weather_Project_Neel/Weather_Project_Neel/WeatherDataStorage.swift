import Foundation

class WeatherDataStorage {
    static let shared = WeatherDataStorage()
    private var weatherDataArray: [WeatherData] = []
    
    func addWeatherData(_ weatherData: WeatherData) {
        weatherDataArray.append(weatherData)
    }
    
    func getAllWeatherData() -> [WeatherData] {
        return weatherDataArray
    }
}
