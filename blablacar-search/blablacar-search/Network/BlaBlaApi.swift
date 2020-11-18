//
//  BlaBlaApi.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import Foundation
import Alamofire

enum BlaBlaApiRoutes {
    case token
    case trip(from: String, to: String, uuid: String)
}

extension BlaBlaApiRoutes {
    var path: String {
        switch self {
        case .token:
            return "\(Constants.SERVER_URL)/token"
        case .trip(from: let from, to: let to, uuid: let uuid):
            return "\(Constants.SERVER_URL)/trip/search?from_address=\(from)&to_address=\(to)&search_uuid=\(uuid)"
        }
    }
}

protocol BlaBlaApi {
    func getToken(completion: @escaping (_ token: String? , _ error: Error?) -> Void)
    func getTrips(from adress: String, to adress: String, completion: @escaping (_ result: [BlaBlaApiModel.TripSearchResults.Trip]? , _ error: Error?) -> Void)
}


class BlaBlaApiImp: BlaBlaApi {
    
    func getToken(completion: @escaping (String?, Error?) -> Void) {
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
        AF.request(BlaBlaApiRoutes.token.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(encoding: String.Encoding.utf8) { response in
            switch response.result {
            case let .success(value):
                do {
                    let decoder = JSONDecoder()
                    let getTokenResult = try decoder.decode(BlaBlaApiModel.GetTokenResult.self, from: value.data(using: .utf8)!)
                    completion(getTokenResult.accessToken, nil)
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
    func getTrips(from: String, to: String, completion: @escaping ([BlaBlaApiModel.TripSearchResults.Trip]?, Error?) -> Void) {
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "X-Locale": "fr_FR",
                                    "X-Visitor-Id": UIDevice.current.identifierForVendor!.uuidString,
                                    "Authorization": "Bearer \(keychain.token())",
                                    "X-Currency": "EUR",
                                    "X-Client" : "iOS|1.0.0"
                                    ]
        AF.request(BlaBlaApiRoutes.trip(from: from, to: to, uuid: UIDevice.current.identifierForVendor!.uuidString).path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString(encoding: String.Encoding.utf8) { response in
            switch response.result {
            case let .success(value):
                print(value)
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let results = try decoder.decode(BlaBlaApiModel.TripSearchResults.self, from: value.data(using: .utf8)!)
                    completion(results.trips, nil)
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}
