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
    private let message = "Sorry, we have a little problem please check your internet connection."
    private let session: URLSessionProtocol
    private (set) var brevalWeatherInformation = ""
    private (set) var newyorkWeatherInformation = ""

    init(_ session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    /**
     This function retrieves weather information for Breval and New York and presents it to the user.
     */
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
        self.obtainWheatherInformationFor(self.newYork) { newYorkInformation, succes in
            guard succes == true,
                  let newYorkInformation = newYorkInformation else {
                self.warningMessage(self.message)
                return
            }
            self.newyorkWeatherInformation = newYorkInformation
            self.refreshNewYorkTextFieldWith(newYorkInformation)
        }
    }

    /**
     This function retrieves weather information using the networkManger class.
     
     - parameter city:       City for which you want to obtain the weather information.
     - parameter completion: returns the retrieved weather information and a true boolean to indicate its success.
     */
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

    /**
     This function prepares the information to be displayed to the user.
     
     - parameter weather: Structure with weather information.
     
     - returns: Returns a string ready to be displayed to user.
     */
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

    /**
     This function creates a URL Reques with method " GET".
     
     - parameter city: City to create the reques
     
     - returns: Returns a URL Reques for the city received in parameter.
     */
    private func createRequestFor(_ city: City) -> URLRequest? {
        guard let url = createURL(city) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }

    /**
     This function creates a url for a city.
     
     - parameter city: City structure to create the url.
     
     - returns: returns a non-optional url.
     */
    private func createURL(_ city: City) -> URL? {
        let url = "\(urlBase)?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(weatherApiKey ?? "")&units=metric"
        guard let urlWithKey = URL(string: url) else {
            return nil
        }
        return urlWithKey
    }
}
