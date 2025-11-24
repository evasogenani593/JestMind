
import SwiftUI
import UIKit
import AppsFlyerLib
import AppTrackingTransparency

@main
struct CipherWordApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.requestTrackingAuthorization()
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        AppsFlyerLib.shared().appsFlyerDevKey = Constant.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID     = Constant.appID
        AppsFlyerLib.shared().delegate       = self
        
        AppsFlyerLib.shared().start()
        
        return true
    }
    
    func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(token, forKey: "apnToken")
            print(token)
        }

        func application(_ application: UIApplication,
                         didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print(error.localizedDescription)
        }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    private func requestTrackingAuthorization() {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("1")
                    case .denied:
                        print("2")
                    case .restricted:
                        print("3")
                    case .notDetermined:
                        print("4")
                    @unknown default:
                        break
                    }
                    
                    self.makeRequest()
                }
            } else {
                self.makeRequest()
            }
        }

    func makeRequest() {
        var urlString = UserDefaults.standard.string(forKey: "urlString")
        
        guard urlString == nil || (urlString ?? "").isEmpty else { return }
        
        let builder = LinkBuilder()
    }
}


extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("\(conversionInfo)")

        if let afattr = getAFAttr(from: conversionInfo) {
            UserDefaults.standard.set(afattr, forKey: "AFAttr")
        }
    }

    func onConversionDataFail(_ error: Error) {
        print("\(error.localizedDescription)")
        
        #if DEBUG
        UserDefaults.standard.set("example", forKey: "AFAttr")
        #endif
    }
}

func getAFAttr(from conversionData: [AnyHashable: Any]) -> String? {
    guard let jsonData = try? JSONSerialization.data(withJSONObject: conversionData, options: []) else {
        return nil
    }

    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
        return nil
    }

    let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
    let encodedString = jsonString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)

    return encodedString
}
