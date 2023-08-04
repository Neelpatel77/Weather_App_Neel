import Foundation

struct WeatherData {
    let locationName: String
    let temperatureCelsius: Double
    let weatherCondition: String
    let weatherIcon: String
    let windKph: Double
    let humidity: Int
    
    var temperatureFahrenheit: Double {
            return (temperatureCelsius * 9/5) + 32
        }
}
