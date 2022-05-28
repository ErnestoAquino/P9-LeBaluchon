//
//  TranslationResponse.swift
//  LeBaluchon
//
//  Created by Ernesto Elias on 09/05/2022.
//

import Foundation

/**
 * TranslationResponse:
 *
 * Structure to retrieve the response from the GOOGLE TRADUCTOR API.
 */
struct TranslationResponse: Decodable {
    let data: Translations?
    struct Translations: Decodable {
        let translations: [TranslationText]?
    }
    struct TranslationText: Decodable {
        let translatedText: String?
    }
}
