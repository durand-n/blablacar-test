//
//  CoordinatorFactoryImp.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit
import CoreData

class CoordinatorFactoryImp: CoordinatorFactory {
    func makeSearchCoordinator(router: Router) -> Coordinator {
        return SearchCoordinator(factory: ModuleFactoryImp(), router: router)
    }
}
