//
//  CafeoTextAlert.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-18.
//

import SwiftUI

public struct CafeoTextAlert {
    /// Title of the alert
    public var title: String
    /// Message of the alert
    public var message: String?
    /// Placeholder text for the `TextField`
    public var placeholder: String = ""
    /// Accept button
    public var accept: String = "OK"
    /// Cancel button
    public var cancel: String = "Cancel"
    /// Triggers when `accept` or `cancel` button closes the alert
    public var action: (String?) -> ()
}

extension View {
    public func cafeoAlert(isPresented: Binding<Bool>, _ alert: CafeoTextAlert) -> some View {
        CafeoAlertWrapper(isPresented: isPresented, alert: alert, content: self)
    }
}

// MARK: -

struct CafeoAlertWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let alert: CafeoTextAlert
    let content: Content

    func makeUIViewController(context: UIViewControllerRepresentableContext<CafeoAlertWrapper>) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }

    final class Coordinator {
        var alertController: UIAlertController?
        init(_ controller: UIAlertController? = nil) {
            self.alertController = controller
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<CafeoAlertWrapper>) {

        uiViewController.rootView = content
        uiViewController.view.backgroundColor = .clear

        if self.isPresented && uiViewController.presentedViewController == nil {
            var alert = self.alert
            alert.action = {
                self.isPresented = false
                self.alert.action($0)
            }

            let ac = UIAlertController(alert: alert)
            ac.overrideUserInterfaceStyle = .dark
            context.coordinator.alertController = ac

            uiViewController.present(context.coordinator.alertController!, animated: true)
        }

        if !self.isPresented && uiViewController.presentedViewController == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
}


// MARK: -

extension UIAlertController {
    /// Initializes a `UIAlertController` based on the `CafeoTextAlert`
    convenience init(alert: CafeoTextAlert) {
        self.init(title: alert.title, message: alert.message, preferredStyle: .alert)

        addTextField {
            $0.placeholder = alert.placeholder
        }
        addAction(
            UIAlertAction(title: alert.cancel, style: .cancel, handler: { _ in
                alert.action(nil)
            })
        )

        let textField = self.textFields?.first
        addAction(
            UIAlertAction(title: alert.accept, style: .default, handler: { _ in
                alert.action(textField?.text)
            })
        )
    }
}
