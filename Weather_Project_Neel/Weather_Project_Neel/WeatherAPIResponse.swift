import Foundation

struct WeatherAPIResponse: Codable {
    let location: Location
    let current: Current
    
    struct Location: Codable {
        let name: String
    }
    
    struct Current: Codable {
        let temp_c: Double
        let condition: Condition
        let wind_kph: Double
        let humidity: Int
        
        struct Condition: Codable {
            let text: String
            let icon: String
        }
    }
    
    func toWeatherData() -> WeatherData {
        return WeatherData(
            locationName: location.name,
            temperatureCelsius: current.temp_c,
            weatherCondition: current.condition.text,
            weatherIcon: current.condition.icon,
            windKph: current.wind_kph,
            humidity: current.humidity
        )
    }
}
