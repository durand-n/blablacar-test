//
//  RouterImp.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit

final public class RouterImp: NSObject, Router {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController: () -> Void]
    
    public init(rootController: UINavigationController) {
        self.rootController = rootController
        self.rootController?.interactivePopGestureRecognizer?.isEnabled = true
        completions = [:]
    }
    
    public func toPresent() -> UIViewController? {
        return rootController
    }
    
    public func present(_ module: Presentable?) {
        DispatchQueue.main.async {
            self.present(module, animated: true)
        }
    }
    
    public func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    public func openUrl(url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
    
    public func push(_ module: Presentable?) {
        self.push(module, animated: true)
    }
    
    public func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    public func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent(), (controller is UINavigationController == false) else { return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        rootController?.pushViewController(controller, animated: animated)
    }
    
    public func popModule() {
        self.popModule(animated: true)
    }
    
    public func popModule(animated: Bool) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    public func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    public func setRootModule(_ module: Presentable?) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
    }
    
    @discardableResult
    public func popTo<T>(module: T.Type) -> T? {
        guard let vc = rootController?.viewControllers.filter({ $0 is T }).first else {
            return nil
        }
        
        rootController?.popToViewController(vc, animated: true)
        return vc as? T
    }
    
    public func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
}
