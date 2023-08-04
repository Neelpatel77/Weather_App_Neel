import UIKit
import CoreLocation

class ViewController: UIViewController {
    private var searchedCitiesWeatherData: [WeatherData] = []

    private lazy var weatherConditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var weatherIconImageViewHeightConstraint: NSLayoutConstraint = {
        let constraint = weatherIconImageView.heightAnchor.constraint(equalToConstant: 0)
        constraint.isActive = true
        return constraint
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter city name"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var celsiusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("C", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(celsiusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var fahrenheitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("F", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(fahrenheitButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, conditionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return manager
    }()

    private lazy var currentWeatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var isCelsiusSelected = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = UIColor(red: 171/255, green: 242/255, blue: 255/255, alpha: 1.0)

        if let staticWeatherIcon = UIImage(named: "WeatherIcon") {
            weatherIconImageView.image = staticWeatherIcon
            weatherIconImageView.contentMode = .scaleAspectFit
        }
        let searchIconSize = CGSize(width: 24, height: 24)
        let searchIcon = UIImage.searchIcon(size: searchIconSize, color: .systemBlue)
        searchButton.setImage(searchIcon, for: .normal)

        updateWeatherIconHeightConstraint()
    }



    @objc private func celsiusButtonTapped() {
        if !isCelsiusSelected {
            isCelsiusSelected = true
            updateTemperatureLabel()
        }
    }

    @objc private func fahrenheitButtonTapped() {
        if isCelsiusSelected {
            isCelsiusSelected = false
            updateTemperatureLabel()
        }
    }

    private func updateTemperatureLabel() {
           guard let weatherData = searchedCitiesWeatherData.last else { return }
           let temperature = isCelsiusSelected ? "\(weatherData.temperatureCelsius)°C" : "\(weatherData.temperatureFahrenheit)°F"
           temperatureLabel.text = temperature
           
           // Update background colors of buttons
           celsiusButton.backgroundColor = isCelsiusSelected ? .systemBlue : .systemCyan
           fahrenheitButton.backgroundColor = isCelsiusSelected ? .systemCyan : .systemBlue
       }
    
    private func displayWeatherData(_ weatherData: WeatherData) {
        let temperature = isCelsiusSelected ? "\(weatherData.temperatureCelsius)°C" : "\(weatherData.temperatureFahrenheit)°F"
        temperatureLabel.text = temperature
        conditionLabel.text = weatherData.weatherCondition

        let weatherIconImage: UIImage?
        switch weatherData.weatherCondition.lowercased() {
            case "sunny", "clear":
                weatherIconImage = UIImage(systemName: "sun.max.fill")
            case "partly cloudy":
                weatherIconImage = UIImage(systemName: "cloud.sun.fill")
            case "cloudy", "overcast":
                weatherIconImage = UIImage(systemName: "cloud.fill")
            case "rainy", "rain":
                weatherIconImage = UIImage(systemName: "cloud.rain.fill")
            case "snowy", "snow":
                weatherIconImage = UIImage(systemName: "snow")
            case "thunderstorms", "thunderstorm":
                weatherIconImage = UIImage(systemName: "cloud.bolt.fill")
            case "foggy", "fog":
                weatherIconImage = UIImage(systemName: "cloud.fog.fill")
            case "windy", "wind":
                weatherIconImage = UIImage(systemName: "wind")
            case "hail":
                weatherIconImage = UIImage(systemName: "cloud.hail.fill")
            case "tornado":
                weatherIconImage = UIImage(systemName: "tornado")
            default:
                weatherIconImage = UIImage(systemName: "questionmark.diamond.fill")
        }
        
        currentWeatherIconImageView.image = weatherIconImage
        weatherConditionLabel.text = weatherData.weatherCondition
        weatherConditionLabel.textColor = .systemBlue
    }

    

    @objc private func showCitiesViewController() {
        let citiesViewController = CitiesViewController(weatherDataArray: searchedCitiesWeatherData)
        let navigationController = UINavigationController(rootViewController: citiesViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func setupUI() {
        title = "Weather App"
        view.backgroundColor = .white

        view.addSubview(locationButton)
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(stackView)
        view.addSubview(currentWeatherIconImageView)
        view.addSubview(weatherIconImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(celsiusButton)
        view.addSubview(fahrenheitButton)
        view.addSubview(weatherConditionLabel)

        temperatureLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        temperatureLabel.font = UIFont.systemFont(ofSize: 40)

        let citiesButton = UIButton(type: .system)
        citiesButton.setTitle("Cities", for: .normal)
        citiesButton.addTarget(self, action: #selector(showCitiesViewController), for: .touchUpInside)
        citiesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(citiesButton)

        let searchBarWidth: CGFloat = 270

        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 20).isActive = true
        stackView.isHidden = true

        NSLayoutConstraint.activate([
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            searchTextField.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: 10),
            searchTextField.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: searchBarWidth),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),

            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),

            citiesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            citiesButton.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 20),

            weatherIconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherIconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherIconImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            weatherIconImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.671), 



            currentWeatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeatherIconImageView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            currentWeatherIconImageView.widthAnchor.constraint(equalToConstant: 100),
            currentWeatherIconImageView.heightAnchor.constraint(equalToConstant: 100),

            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: currentWeatherIconImageView.bottomAnchor, constant: 20),

            celsiusButton.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 5),
            celsiusButton.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),

            fahrenheitButton.leadingAnchor.constraint(equalTo: celsiusButton.trailingAnchor, constant: 5),
            fahrenheitButton.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            
            weatherConditionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    weatherConditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20)

        ])
    }

    @objc private func searchButtonTapped() {
        guard let city = searchTextField.text, !city.isEmpty else { return }
        
        WeatherAPIManager.shared.fetchWeatherData(for: city) { [weak self] (weatherData, error) in
            DispatchQueue.main.async {
                if let weatherData = weatherData {
                    self?.searchedCitiesWeatherData.append(weatherData)
                    self?.displayWeatherData(weatherData)
                    self?.showCityLabel(city)
                } else if let error = error {
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showCityLabel(_ cityName: String) {
        let cityLabel = UILabel()
        cityLabel.text = cityName
        cityLabel.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func locationButtonTapped() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func updateWeatherIconHeightConstraint() {
         let heightMultiplier: CGFloat = 0.1
         let constant = view.frame.width * heightMultiplier
         weatherIconImageViewHeightConstraint.constant = constant
     }
    
    private func fetchWeatherDataForLocation(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                self?.showErrorAlert(message: error.localizedDescription)
            } else if let city = placemarks?.first?.locality {
                WeatherAPIManager.shared.fetchWeatherData(for: city) { [weak self] (weatherData, error) in
                    DispatchQueue.main.async {
                        if let weatherData = weatherData {
                            self?.displayWeatherData(weatherData)
                        } else if let error = error {
                            self?.showErrorAlert(message: error.localizedDescription)
                        }
                    }
                }
            } else {
                self?.showErrorAlert(message: "Failed to get city name from location.")
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
 
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchWeatherDataForLocation(location)
        }
    }
}

extension UIImage {
    static func searchIcon(size: CGSize, color: UIColor) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: size.width, weight: .regular)
        let searchIconImage = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        return searchIconImage?.withTintColor(color, renderingMode: .alwaysOriginal)
    }

}

