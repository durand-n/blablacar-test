//
//  BlaBlaApi.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import Foundation
import Alamofire
import MapKit

enum BlaBlaApiRoutes {
    case Token
    case Trip(from: String, to: String, uuid: String, type: TripSearchType)
}

extension BlaBlaApiRoutes {
    var path: String {
        switch self {
        case .Token:
            return "\(Constants.SERVER_URL)/token"
        case .Trip(from: let from, to: let to, uuid: let uuid, type: let type):
            var requestUrl = ""
            switch type {
            case .Coordinates:
                requestUrl = "\(Constants.SERVER_URL)/trip/search?from_coordinates=\(from)&to_coordinates=\(to)&search_uuid=\(uuid)&from_country=\(Constants.COUNTRY_CODE)&to_country=\(Constants.COUNTRY_CODE)"
            case .Address:
                requestUrl = "\(Constants.SERVER_URL)/trip/search?from_address=\(from)&to_address=\(to)&search_uuid=\(uuid)"
            }
            if let encoded = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                return encoded
            } else {
                return requestUrl
            }
        }
    }
}

enum TripSearchType {
    case Coordinates
    case Address
}

protocol BlaBlaApi {
    func getToken(completion: @escaping (_ token: String? , _ error: ApiError?) -> Void)
    func getTrips(from adress: String, to adress: String, type: TripSearchType, cursor: String?, completion: @escaping (_ result: BlaBlaApiModel.TripSearchResults? , _ error: ApiError?) -> Void)
}


class BlaBlaApiImp: BlaBlaApi {

    func getToken(completion: @escaping (String?, ApiError?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters: Parameters = ["grant_type": "client_credentials",
                                      "client_id": Constants.CLIENT_ID,
                                      "client_secret": Constants.CLIENT_SECRET,
                                      "scopes": [
                                          "SCOPE_TRIP_DRIVER",
                                          "DEFAULT",
                                          "SCOPE_INTERNAL_CLIENT"
                                      ]
                                    ]
        AF.request(BlaBlaApiRoutes.Token.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(encoding: String.Encoding.utf8) { response in
            switch response.result {
            case let .success(value):
                do {
                    let decoder = JSONDecoder()
                    let getTokenResult = try decoder.decode(BlaBlaApiModel.GetTokenResult.self, from: value.data(using: .utf8)!)
                    completion(getTokenResult.accessToken, nil)
                } catch  {
                    let error = try? JSONDecoder().decode(BlaBlaApiModel.APIErrorResult.self, from: value.data(using: .utf8)!)
                    completion(nil, ApiError(type: error?.type, message: error?.message))
                }
            case let .failure(error):
                completion(nil, ApiError(code: error.responseCode))
            }
        }
    }
    
    func getTrips(from: String, to: String, type: TripSearchType, cursor: String? = nil, completion: @escaping (BlaBlaApiModel.TripSearchResults?, ApiError?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Locale": "fr_FR",
                                    "X-Visitor-Id": UIDevice.current.identifierForVendor!.uuidString,
                                    "Authorization": "Bearer \(keychain.token())",
                                    "X-Currency": Constants.CURRENCY,
                                    "X-Client" : "iOS|1.0.0"
                                    ]
        AF.request(BlaBlaApiRoutes.Trip(from: from, to: to, uuid: UIDevice.current.identifierForVendor!.uuidString, type: type).path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(encoding: String.Encoding.utf8) { response in
            switch response.result {
            case let .success(value):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let results = try decoder.decode(BlaBlaApiModel.TripSearchResults.self, from: value.data(using: .utf8)!)
                    completion(results, nil)
                } catch {
                    let error = try? JSONDecoder().decode(BlaBlaApiModel.APIErrorResult.self, from: value.data(using: .utf8)!)
                    completion(nil, ApiError(type: error?.type, message: error?.message))
                }
            case let .failure(error):
                completion(nil, ApiError(code: error.responseCode))
            }
        }
    }
}
