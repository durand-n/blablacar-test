//
//  BlaBlaApiModel.swift
//  blablacar-search
//
//  Created by Benoît Durand on 18/11/2020.
//

import Foundation

class BlaBlaApiModel {
    struct GetTokenResult: Codable {
        let accessToken: String
        let tokenType: String
        let expiresIn: Int

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case expiresIn = "expires_in"
        }
    }
    
    struct APIErrorResult: Codable {
        let exception: String
        let message: String
        let type: String
    }
    
    struct TripSearchResults: Codable {
        
        let trips: [Trip]
        let pagination: Pagination
        
        
        // MARK: - Trip
        struct Trip: Codable {
            let multimodalID: MultimodalID
            let waypoints: [Waypoint]
            let monetizationPrice: MonetizationPrice
            let driver: Driver

            enum CodingKeys: String, CodingKey {
                case multimodalID = "multimodal_id"
                case waypoints
                case monetizationPrice = "monetization_price"
                case driver
            }
        }
        
        struct Pagination: Codable {
            let nextCursor: String?
            
            enum CodingKeys: String, CodingKey {
                case nextCursor = "next_cursor"
            }
        }

        // MARK: - Driver
        struct Driver: Codable {
            let thumbnail: String
            let name: String
            let rating: Rating

            enum CodingKeys: String, CodingKey {
                case thumbnail
                case name = "display_name"
                case rating
            }
        }

        // MARK: - Rating
        struct Rating: Codable {
            let overall: Double
            let totalNumber: Int

            enum CodingKeys: String, CodingKey {
                case overall
                case totalNumber = "total_number"
            }
        }

        // MARK: - MonetizationPrice
        struct MonetizationPrice: Codable {
            let monetizedPrice, notMonetizedPrice: MonetizedPrice

            enum CodingKeys: String, CodingKey {
                case monetizedPrice = "monetized_price"
                case notMonetizedPrice = "not_monetized_price"
            }
        }

        // MARK: - MonetizedPrice
        struct MonetizedPrice: Codable {
            let currency: String
            let amount: String
            let formattedPrice: String

            enum CodingKeys: String, CodingKey {
                case currency
                case amount
                case formattedPrice = "formatted_price"
            }
        }

        // MARK: - MultimodalID
        struct MultimodalID: Codable {
            let source: String
            let id: String
        }

        // MARK: - Waypoint
        struct Waypoint: Codable {
            let mainText: String
            let place: Place
            let dateTime: Date
            let type: [String]

            enum CodingKeys: String, CodingKey {
                case mainText = "main_text"
                case place
                case dateTime = "date_time"
                case type
            }
        }


        // MARK: - Place
        struct Place: Codable {
            let city, address: String
            let latitude, longitude: Double
            let countryCode: String

            enum CodingKeys: String, CodingKey {
                case city, address, latitude, longitude
                case countryCode = "country_code"
            }
        }
    }
}
