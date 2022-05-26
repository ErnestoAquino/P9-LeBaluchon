//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 02/05/2022.
//

import Foundation

final class WeatherService {
    weak var viewDelegate: WeatherDelegate?
    private let weatherApiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String
    private let breval = City(latitude: "48.9455", longitude: "1.5331")
    private let newYork = City(latitude: "40.7143", longitude: "-74.006")
    private let urlBase = "https://api.openweathermap.org/data/2.5/weather"
    private var networkManager = NetworkManager<WeatherData>(networkManagerSession: URLSession.shared)
    private let message = "Sorry, we have a little problem please check your internet connection."
    private let session: URLSessionProtocol
    private (set) var brevalWeatherInformation = ""
    private (set) var newyorkWeatherInformation = ""

    init(_ session: URLSessionProtocol) {
        self.session = session
    }

    // This function retrives wether information for two cities, Breval and NewYork.
    // It creates a request for each one. Using the method getInformation of the network manager class
    // it retrives the information.
    public func updateWeatherInformation() {
        obtainWheatherInformationFor(breval) { brevalInformation, success in
            guard success == true,
                let brevalInformation = brevalInformation else {
                self.warningMessage(self.message)
                return
            }
            self.brevalWeatherInformation = brevalInformation
            self.refreshBrevalTextFieldWith(brevalInformation)
        }
        obtainWheatherInformationFor(newYork) { newYorkInformation, succes in
            guard succes == true,
                  let newYorkInformation = newYorkInformation else {
                self.warningMessage(self.message)
                return
            }
            self.newyorkWeatherInformation = newYorkInformation
            self.refreshNewYorkTextFieldWith(newYorkInformation)
        }
    }

    private func obtainWheatherInformationFor(_ city: City, completion: @escaping (String?, Bool) -> Void) {
        let networkManager = NetworkManager<WeatherData>(networkManagerSession: session)
        let request = createRequestFor(city)
        toogleActivityIndicator(shown: true)
        networkManager.getInformation(request: request) { weatherInformation, error in
            self.toogleActivityIndicator(shown: false)
            guard error ==  nil,
                  let weatherInformation = weatherInformation else {
                self.warningMessage(self.message)
                completion(nil, false)
                return
            }
            let informationToDisplay = self.createTextForUpadateInformation(weatherInformation)
            completion(informationToDisplay, true)
        }
    }

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
    private func createRequestFor(_ city: City) -> URLRequest {
        let url = createURL(city)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }
    private func createURL(_ city: City) -> URL {
        let key = getApiKey()
        let url = "\(urlBase)?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(key)&units=metric"
        guard let urlWithKey = URL(string: url) else {
            return URL(string: " ")!
        }
        return urlWithKey
    }

    private func getApiKey() -> String {
        guard let key = weatherApiKey  else {
            return ""
        }
        return key
    }
}
