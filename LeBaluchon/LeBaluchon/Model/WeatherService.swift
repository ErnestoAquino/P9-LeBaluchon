//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 02/05/2022.
//

import Foundation

class WeatherService {
    weak var viewDelegate: WeatherProtocol?
    private let weatherApiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY")
    private let breval = City(latitude: "48.9455", longitude: "1.5331")
    private let newYork = City(latitude: "40.7143", longitude: "-74.006")
    private let urlBase = URL(string: "https://api.openweathermap.org/data/2.5/weather")!

    private func getWeatherInformation(_ city: City, completionHandler: @escaping (WeatherData?, Error?) -> Void) {
        let urlWeather = URL(string: createUrlFor(city))
        var request = URLRequest(url: urlWeather!)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil,
                      let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else { return  completionHandler(nil, nil)}
                let decoderWeather = JSONDecoder()
                decoderWeather.keyDecodingStrategy = .convertFromSnakeCase
                decoderWeather.dateDecodingStrategy = .secondsSince1970
                guard let weatherInformation = try? decoderWeather.decode(WeatherData.self, from: data) else { return completionHandler(nil, nil)}
                completionHandler(weatherInformation, nil)
                print(weatherInformation)
            }
        }
        task.resume()
    }

    func updateWeatherInformation() {
        getWeatherInformation(breval) { weatherData, error in
            guard error == nil,
                  let weatherData = weatherData else {
                self.warningMessage("Sorry, we have a little problem, please check your internet connection")
                return
            }
            self.refreshBrevalTextFieldWith(self.createTextForUpadateInformation(weatherData))
        }
        getWeatherInformation(newYork) { weatherData, error in
            guard error == nil,
                  let weatherData = weatherData else {
                self.warningMessage("Sorry, we have a little problem, please check your internet connection")
                return
            }
            self.refreshNewYorkTextFieldWith(self.createTextForUpadateInformation(weatherData))
        }
    }

    private func createUrlFor(_ city: City) -> String {
        guard let key = weatherApiKey else { return "" }
        let urlWithKey =
        "https://api.openweathermap.org/data/2.5/weather?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(key)&units=metric"
        return urlWithKey
    }

    private func createTextForUpadateInformation(_ weather: WeatherData) -> String {
        var text = "Sorry, we have a little problem."
        guard let description = weather.weather?[0].description,
              let temperatureMin = weather.main?["temp_min"],
              let temperatureMax = weather.main?["temp_max"],
              let humidity = weather.main?["humidity"],
              let windSpeed = weather.wind?["speed"] else {return text}

        text = """
        \(description.uppercased())
        \(temperatureMin) °C - \(temperatureMax) °C
        \(windSpeed) Km/h
        \(humidity) % Humidity
        """
        return text
    }
}

extension WeatherService: WeatherProtocol {
    func warningMessage(_ message: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.warningMessage(message)
    }

    func refreshNewYorkTextFieldWith(_ value: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.refreshNewYorkTextFieldWith(value)
    }

    func refreshBrevalTextFieldWith(_ value: String) {
        guard let viewDelegate = viewDelegate else {return}
        viewDelegate.refreshBrevalTextFieldWith(value)
    }
}

struct WeatherData: Decodable {
    let weather: [Weather]?
    let main: [String: Double]?
    let wind: [String: Double]?
    let date: Date?

    private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weather
        case main
        case wind
    }
}

struct Weather: Decodable {
    let weatherID: Int?
    let main: String?
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case weatherID = "id"
        case main
        case description
    }
}

struct City {
    let latitude: String
    let longitude: String
}
