//
//  Net.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Foundation
//import Network
import Firebase

final class Net: NSObject {

    static let shared = Net()

//    let service: NetService
//    let browser: NetServiceBrowser
    let db = Database.database().reference(withPath: "on_air")

    var isSomeoneOnAir: (Bool) -> Void = { _ in }

    var userId: String = {
        if UserDefaults.standard.string(forKey: "oaid") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "oaid")
        }
        return UserDefaults.standard.string(forKey: "oaid")!
    }()


    override init() {

//        service = NetService(domain: "local.", type: "_ona._tcp.", name: "onair")
//        browser = NetServiceBrowser()
        super.init()
//        service.delegate = self
//        service.publish()
//
//        browser.searchForServices(ofType: "_ona._tcp.", inDomain: "local.")

        db.observe(.value) { [unowned self] snapshot in
            var value = snapshot.value as! [String: String]
            print(value)
            value[userId] = "not"
            self.isSomeoneOnAir(value.values.contains("quiet_please"))
        }
    }

    func set(isOnAir: Bool) {
        db.child("\(userId)").setValue(isOnAir ? "quiet_please" : "not")
    }

}

//extension Net: NetServiceDelegate {
//
//    func netServiceWillPublish(_ sender: NetService) {
//        print(#function)
//    }
//
//
//    func netServiceDidPublish(_ sender: NetService) {
//        print(#function)
//    }
//
//
//    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
//        print(#function, errorDict)
//    }
//
//}
//
//
//extension Net: NetServiceBrowserDelegate {
//
//    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
//        print("Found Service", service, moreComing)
//    }
//
//    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
//        print(#function, errorDict)
//    }
//
//}
