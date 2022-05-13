//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 02/05/2022.
//

import Foundation

class WeatherService {
    weak var viewDelegate: WeatherDelegate?
    private let weatherApiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String
    private let breval = City(latitude: "48.9455", longitude: "1.5331")
    private let newYork = City(latitude: "40.7143", longitude: "-74.006")
    private let urlBase = "https://api.openweathermap.org/data/2.5/weather"
    private var networkManager = NetworkManager<WeatherData>()
    private let message = "Sorry, we have a little problem please check your internet connection."

    // This function retrives the information to be displayed to the user from a Weather Data
    // structure and stores it ini a string.
    private func createTextForUpadateInformation(_ weather: WeatherData) -> String {
        var text = "Sorry, we have a little problem."
        guard let description = weather.weather?[0].description,
              let temperatureMin = weather.main?["temp_min"],
              let temperatureMax = weather.main?["temp_max"],
              let humidity = weather.main?["humidity"],
              let windSpeed = weather.wind?["speed"] else {return text}

        text = """
        \(description.uppercased())
        \(temperatureMin) °C min - \(temperatureMax) °C max
        \(windSpeed) Km/h
        \(humidity) % Humidity
        """
        return text
    }
    // This function create a URL Request for URL Session.
    // Receives as parameter the city from which you want to
    // obtain the weather information.
    private func createRequestFor(_ city: City) -> URLRequest? {
        guard let key = weatherApiKey else {return nil}
        let urlWithKey = "\(urlBase)?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(key)&units=metric"
        guard let urlWeather = URL(string: urlWithKey) else {return nil}
        var request = URLRequest(url: urlWeather)
        request.httpMethod = "GET"

        return request
    }
    // This function retrives wether information for two cities, Breval and NewYork.
    // It creates a request for each one. Using the method of the network manager class
    // it retrives the information.
    func updateWeatherInformation() {
        guard let requestForBreval = createRequestFor(breval),
              let requestForNewYork = createRequestFor(newYork) else {return}
        networkManager.getInformation(request: requestForBreval) { weatherBreval, error in
            guard error == nil,
                  let weatherBreval = weatherBreval else {
                self.warningMessage(self.message)
                return
            }
            self.refreshBrevalTextFieldWith(self.createTextForUpadateInformation(weatherBreval))
            self.networkManager.getInformation(request: requestForNewYork) { weatherNewYork, error in
                guard error == nil,
                      let weatherNewYork = weatherNewYork else {
                    self.warningMessage(self.message)
                    return
                }
                self.refreshNewYorkTextFieldWith(self.createTextForUpadateInformation(weatherNewYork))
            }
        }
    }
}
