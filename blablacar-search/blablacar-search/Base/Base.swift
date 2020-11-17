//
//  Base.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit

public protocol Coordinator: class {
    func start()
    var finishFlow: (() -> Void)? { get set }
}

open class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    public var finishFlow: (() -> Void)?
    
    public init() {}
    
    open func start() {}
    
    public func addChild(_ coordinator: Coordinator) {
        childCoordinators.forEach { elem in
            if elem === coordinator {
                return
            }
        }
        childCoordinators.append(coordinator)
    }
    
    public func removeChild(_ coordinator: Coordinator) {
        guard !childCoordinators.isEmpty else { return }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    public func removeChilds() {
        guard !childCoordinators.isEmpty else { return }
        childCoordinators.removeAll()
    }
}

public protocol Presentable {
    func toPresent() -> UIViewController?
}

// MARK: base view
public protocol BaseView: NSObjectProtocol, Presentable {}
