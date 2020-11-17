//
//  UIViewController.swift
//  blablacar-search
//
//  Created by Benoît Durand on 17/11/2020.
//
//

import UIKit
import MessageUI
import ContactsUI

extension UIViewController {
    open func toPresent() -> UIViewController? {
        return self
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    public func sendEmail(_ mailAddress: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailAddress])
            self.present(mail as UIViewController, animated: true)
        } else {
            if let url = URL(string: "mailto:\(mailAddress)") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension UIViewController: CNContactViewControllerDelegate {

}