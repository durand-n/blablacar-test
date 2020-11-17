//
//  CoordinatorFactory.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit
import CoreData

protocol CoordinatorFactory {
    func makeSearchCoordinator(router: Router) -> Coordinator
}
