import UIKit

class CitiesViewController: UIViewController {
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
   
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties
    private var citiesWeatherData: [WeatherData] = []
    private var isCelsiusSelected = true
    
    // MARK: - Initializer
    init(weatherDataArray: [WeatherData]) {
        super.init(nibName: nil, bundle: nil)
        self.citiesWeatherData = weatherDataArray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCitiesWeatherData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Cities"
        view.backgroundColor = UIColor(red: 171/255, green: 242/255, blue: 1, alpha: 1) // #abf2ff
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Weather Data Update
    private func updateCitiesWeatherData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cityWeatherData = citiesWeatherData[indexPath.row]

        cell.textLabel?.text = "\(cityWeatherData.locationName)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        let cityLabel = UILabel()
        cityLabel.text = cityWeatherData.locationName
        cityLabel.textColor = .white
        cityLabel.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        cityLabel.textAlignment = .center
        cityLabel.layer.cornerRadius = 8
        cityLabel.clipsToBounds = true
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(cityLabel)

        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
            cityLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cityLabel.heightAnchor.constraint(equalToConstant: 30),
            cityLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])

        let weatherLabel = UILabel()
        weatherLabel.textAlignment = .center
        weatherLabel.text = isCelsiusSelected ? "\(cityWeatherData.temperatureCelsius)°C" : "\(cityWeatherData.temperatureFahrenheit)°F"
        weatherLabel.font = UIFont.boldSystemFont(ofSize: 18)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(weatherLabel)

        NSLayoutConstraint.activate([
            weatherLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            weatherLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])



        return cell
    }
}

// MARK: - UITableViewDelegate
extension CitiesViewController: UITableViewDelegate {
}
