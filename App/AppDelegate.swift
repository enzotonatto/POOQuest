import UIKit
import SwiftUI

// MARK: - Orientation lock (landscape only for iPad)
class AppDelegate: NSObject, UIApplicationDelegate {

    static var orientationLock = UIInterfaceOrientationMask.landscape

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        AppDelegate.orientationLock
    }

    static func lockLandscape() {
        orientationLock = .landscape
        if #available(iOS 16.0, *) {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .forEach { $0.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) }
        } else {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
        }
    }
}
