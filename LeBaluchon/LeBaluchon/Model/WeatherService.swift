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

    func updateWeatherInformation() {
        updateWatherInformationForBreval()
        updateWeatherInformationForNewYork()
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
        \(temperatureMin) °C min - \(temperatureMax) °C max
        \(windSpeed) Km/h
        \(humidity) % Humidity
        """
        return text
    }

    private func createUrlFor(_ city: City) -> String {
        guard let key = weatherApiKey else { return "" }
        let urlWithKey =
        "\(urlBase)?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(key)&units=metric"

        return urlWithKey
    }

    private func createRequestFor(_ city: City) -> URLRequest? {
        guard let urlWeather = URL(string: createUrlFor(city)) else {return nil}
        var request = URLRequest(url: urlWeather)
        request.httpMethod = "GET"

        return request
    }

    private func updateWatherInformationForBreval() {
        guard let requestForBreval = createRequestFor(breval) else {
            warningMessage(message)
            return
        }
        networkManager.getInformation(request: requestForBreval) { weatherData, error in
            guard error == nil,
                  let weatherData = weatherData else {
                self.warningMessage(self.message)
                return
            }
            self.refreshBrevalTextFieldWith(self.createTextForUpadateInformation(weatherData))
        }
    }

    private func updateWeatherInformationForNewYork() {
        guard let requestForNewYork = createRequestFor(newYork) else {
            warningMessage(message)
            return
        }
        let networkManagerTest = NetworkManager<WeatherData>()
        networkManagerTest.getInformation(request: requestForNewYork) { weatherData, error in
            guard error == nil,
                  let weatherDataForNewYork = weatherData else {
                self.warningMessage(self.message)
                return
            }
            self.refreshNewYorkTextFieldWith(self.createTextForUpadateInformation(weatherDataForNewYork))
        }
    }
}
