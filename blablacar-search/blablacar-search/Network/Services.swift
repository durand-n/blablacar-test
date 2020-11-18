//
//  Services.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//

import Foundation

class Services {
    static let shared = Services()
    
    var blablaApi: BlaBlaApi = BlaBlaApiImp()
}
